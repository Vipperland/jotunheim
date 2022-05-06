package gate.sirius.serializer {
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import gate.sirius.meta.Console;
	import gate.sirius.serializer.data.SruData;
	import gate.sirius.serializer.hosts.IList;
	import gate.sirius.serializer.hosts.IStartable;
	import gate.sirius.serializer.hosts.SruObject;
	import gate.sirius.serializer.signals.SruDecoderSignal;
	import gate.sirius.serializer.signals.SruErrorSignal;
	import gate.sirius.serializer.signals.SruSignals;
	
	
	/**
	 * ...
	 *
	 * Fast Help:
	 *
	 * //	Basics
	 * 	propName = test					Set String Variable
	 * 	propName = 1					Set Number Variable
	 * 	propName = 0xFF					Set Number Variable
	 * 	propName = 0001					Set Number Variable
	 * 	propName = true					Set Boolean Variable
	 *
	 * //	Objects
	 * 	#ClassName					Equals to cursor.push(new ClassName());
	 * 	#ClassName(					Create an alternate cursor to buffer constructor properties
	 * 	#ClassName{					Equals to cursor.push(new ClassName()); and set value to cursor
	 * 	){							Close the current alternated cursor and call the class constructor with the buffer values
	 * 	prop:ClassName					Equals to myProp = new ClassName();
	 * 	propA.propB:ClassName			Equals to myObject.prop = new ClassName(); and set value to cursor
	 * 	prop:ClassName{					Equals to myProp = new ClassName(); and set value to cursor
	 * 	}							Close current object and set the previous object to cursor
	 * 			Ex.:
	 * 				users:Array {
	 * 					#Object {
	 * 						name=Foo
	 * 						nick=Bar
	 * 					}
	 * 				}
	 *
	 * //	Methods
	 * 	~methodName()					Equals to myFunction();
	 * 	~prop.methodName()				Equals to myObject.myFunction();
	 * 	~methodName(a,b,c,d,e)			Equals to myFunction(a,b,c,d,e);
	 * 	~methodName(					Create an alternate cursor to buffer methods properties
	 * 	)							Close the current alternated cursor and call the method with the buffer values
	 * 			Ex.:
	 * 				#Sprite {
	 * 					~addChild(
	 * 						#Loader {
	 * 							~load(
	 * 								#URLRequest(foobar.jpg)
	 * 							)
	 * 						}
	 * 						rotationY = 3
	 * 					)
	 * 					x = 10
	 * 					y = 10
	 * 				}
	 * 
	 *
	 * //	Queries
	 * 	@ methodName					Equal to myFunction();
	 * 	@ prop.methodName				Equal to myObject.myFunction();
	 * 	@ methodName a b c d e			Equal to myFunction(a,b,c,d,e);
	 * 			Ex.:
	 * 				numbers:Array
	 * 				@ numbers.push a b c d e f ...
	 * 				@ numbers.splice 1 2
	 *
	 * @author Rafael moreira
	 */
	public class SruDecoder {
		
		/**
		 * @private
		 */
		static internal const CLASS_COLLECTION:Dictionary = new Dictionary(true);
		
		static public function getClassCollection():Dictionary {
			return CLASS_COLLECTION;
		}
		
		/**
		 *
		 * @param	...list
		 */
		static public function allowClasses(... list:Array):void {
			var fullNamespace:String;
			var nameOnly:String;
			for each (var regClass:Class in list) {
				fullNamespace = getQualifiedClassName(regClass);
				nameOnly = fullNamespace.split("::").pop();
				CLASS_COLLECTION[fullNamespace] = regClass;
				CLASS_COLLECTION[nameOnly] = regClass;
			}
		}
		
		
		/**
		 *
		 * @param	target
		 */
		static public function extractClasses(target:ApplicationDomain):void {
			var names:Vector.<String> = target.getQualifiedDefinitionNames();
			var collection:Vector.<Class> = new Vector.<Class>();
			for each (var name:String in names){
				collection[collection.length] = target.getDefinition(name) as Class;
			}
			allowClasses.apply(null, collection);
		}
		
		
		/**
		 *
		 * @param	name
		 * @param	allowDefaultObject
		 * @return
		 */
		static public function getClass(name:String, allowDefaultObject:Boolean):Class {
			if (name == null || name == "" || name == "Object" || name == "*" || name == "SruObject")
				return SruObject;
			else if (name == "Array")
				return Array;
			return CLASS_COLLECTION[name] || (allowDefaultObject ? SruObject : null);
		}
		
		
		/**
		 *
		 * @param	value
		 * @param	mergeTo
		 * @return
		 */
		static public function parse(value:String, mergeTo:* = null, onComplete:Function = null, enableDefaultObjects:Boolean = false, onError:Function = null, id:String = ""):SruDecoder {
			return new SruDecoder(enableDefaultObjects).parse(value, mergeTo, onComplete, onError, id);
		}
		
		/**
		 * @private
		 */
		private const _data:SruData = new SruData();
		
		/**
		 * @private
		 */
		private var _mainObject:Object;
		
		/**
		 * @private
		 */
		private var _currentObject:Object;
		
		/**
		 * @private
		 */
		private var _tempObject:Object;
		
		/**
		 * @private
		 */
		private var _skipping:Boolean;
		
		/**
		 * @private
		 */
		private var _mainPath:Vector.<String>;
		
		/**
		 * @private
		 */
		private var _mainChain:Vector.<uint>;
		
		/**
		 * @private
		 */
		private var _handlerPath:Vector.<MethodTicket>;
		
		/**
		 * @private
		 */
		private var _lastMethodTicket:MethodTicket;
		
		/**
		 * @private
		 */
		private var _missingObjects:int;
		
		/**
		 * @private
		 */
		private var _signals:SruSignals;
		
		/**
		 * @private
		 */
		private var _enableDefaultObjects:Boolean;
		
		/**
		 * @private
		 */
		private var _startTime:int;
		
		/**
		 * @private
		 */
		private var _blockParseTime:int;
		
		/**
		 * @private
		 */
		private var _stopProccess:Boolean;
		
		/**
		 * @private
		 */
		private var _delayedParse:int;
		
		/**
		 * @private
		 */
		private var _skippedLines:String;
		
		/**
		 * @private
		 */
		private var _busy:Boolean;
		
		/**
		 * @private
		 */
		private var _tempPath:Array;
		
		/**
		 * @private
		 */
		private var _targetPath:Vector.<String>;
		
		/**
		 * @private
		 */
		private var _targetChain:Vector.<uint>;
		
		/**
		 * @private
		 */
		private var _targetObject:Object;
		
		
		/**
		 * @private
		 */
		private function _resumeParser():void {
			_blockParseTime = getTimer();
			_parseData();
		}
		
		
		/**
		 * @private
		 */
		private function _refreshTime():Boolean {
			var current:int = getTimer();
			var result:Boolean = current - _blockParseTime > 1000;
			_blockParseTime = current;
			return result;
		}
		
		
		private function _expand(target:*, param:String):Boolean {
			if (_currentObject && param in _currentObject) {
				_currentObject = _currentObject[param];
				return true;
			} else {
				_signals.ERROR.send(SruErrorSignal, true, ("Can´t open path " + param + " in " + getQualifiedClassName(_currentObject) + " object (target " + _targetPath.join(".") + ")."), _data.currentLine, _data.lineValue, 2003, "", _data.fileName);
				return false;
			}
		}
		
		
		/**
		   /**
		 *
		 * @param	param
		 * @private
		 */
		private function _buildPath(param:*):void {
			if (param !== null) {
				if (param is String) {
					_tempPath = param.split(".");
					_targetChain[_targetChain.length] = _tempPath.length;
					for each (var p:String in _tempPath) {
						if (!_expand(_currentObject, p))
							break;
						_targetPath[_mainPath.length] = p;
					}
				} else {
					_targetChain[_targetChain.length] = 1;
					if (_expand(_currentObject, param))
						_targetPath[_targetPath.length] = param;
				}
				return;
			} else {
				var length:int = _targetChain.pop();
				_targetPath.splice(_targetPath.length - length, length);
				if (_currentObject is IStartable)
					(_currentObject as IStartable).onConstruct();
			}
			_resetPath();
		}
		
		
		/**
		 * @private
		 */
		private function _resetPath():void {
			_currentObject = _targetObject;
			for each (var str:String in _targetPath){
				_expand(_currentObject, str);
			}
		}
		
		
		/**
		 * @private
		 */
		private function _pushObject(currentObject:Object, objectType:String, open:Boolean, classArgs:Array):void {
			var index:uint;
			var CType:Class = getClass(objectType, _enableDefaultObjects);
			if (CType) {
				try {
					index = currentObject.push(_endCreate(CType, classArgs));
					if (open)
						_buildPath(index - 1);
					return;
				} catch (e:Error) {
					trace(e.getStackTrace());
					_signals.ERROR.send(SruErrorSignal, true, ("Can´t push " + objectType + " at index #" + index + " in " + getQualifiedClassName(currentObject)), _data.currentLine, _data.lineValue, 2002, e.getStackTrace(), _data.fileName);
				}
			} else {
				_signals.ERROR.send(SruErrorSignal, true, ("Definition [" + objectType + "] not registered."), _data.currentLine, _data.lineValue, 2003, "", _data.fileName);
			}
			if (open)
				++_missingObjects;
		}
		
		
		/**
		 * @private
		 */
		private function _createObject(currentObject:Object, objectType:String, paramName:String, open:Boolean, classArgs:Array):void {
			var CType:Class = getClass(objectType, _enableDefaultObjects);
			if (CType) {
				try {
					currentObject[paramName] = _endCreate(CType, classArgs);
					if (open)
						_buildPath(paramName);
					return;
				} catch (e:Error) {
					_signals.ERROR.send(SruErrorSignal, true, ("Can´t create property " + paramName + " in " + getQualifiedClassName(currentObject)), _data.currentLine, _data.lineValue, 2001, e.getStackTrace(), _data.fileName);
				}
			} else {
				_signals.ERROR.send(SruErrorSignal, true, ("Definition [" + objectType + "] not registered."), _data.currentLine, _data.lineValue, 2003, "", _data.fileName);
			}
			if (open)
				++_missingObjects;
		}
		
		private function _endCreate(CType:Class, a:Array):* {
			if (a == null){
				return new CType();
			}else{
				switch(a.length){
					case  0 : return new CType();
					case  1 : return new CType(a[0]);
					case  2 : return new CType(a[0],a[1]);
					case  3 : return new CType(a[0],a[1],a[2]);
					case  4 : return new CType(a[0],a[1],a[2],a[3]);
					case  5 : return new CType(a[0],a[1],a[2],a[3],a[4]);
					case  6 : return new CType(a[0],a[1],a[2],a[3],a[4],a[5]);
					case  7 : return new CType(a[0],a[1],a[2],a[3],a[4],a[5],a[6]);
					case  8 : return new CType(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7]);
					case  9 : return new CType(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8]);
					default : return new CType(a[0],a[1],a[2],a[3],a[4],a[5],a[6],a[7],a[8],a[9]);
				}
			}
		}
		
		
		/**
		 * @private
		 */
		private function _parseComplete():void {
			_skippedLines = _data.skippedLines;
			_data.releaseLog();
			_signals.PARSED.send(SruDecoderSignal, true, false);
			_resetTargets();
			if (_data.isBufferEmpty())
				_data.reset();
		}
		
		
		/**
		 * @private
		 */
		private function _parseData():SruDecoder {
			
			var index:uint;
			var param:String;
			var ticket:ParseTicket;
			
			_startTime = getTimer();
			_blockParseTime = _startTime;
			_busy = true;
			
			while (_data.hasBuffer()) {
				
				if (_refreshTime()) {
					_delayedParse = setTimeout(_resumeParser, 10);
					break;
				}
				
				if (_data.isCommentStart()) {
					_skipping = true;
					continue;
				}
				if (_skipping) {
					if (_data.isCommentEnd())
						_skipping = false;
					continue;
				}
				
				// Case object enclosing } found
				if (_data.isObjectClose()) {
					if (_missingObjects == 0) {
						_buildPath(null);
					} else {
						_data.skipLine();
						--_missingObjects;
					}
					continue;
				}
				
				// Case error lines causes script damage, the entire bracket session will be skipped
				if (_missingObjects > 0) {
					if (_data.isObjectOpen()) {
						_data.skipLine();
						++_missingObjects;
					}
					continue;
				}
				
				// check if file name is present, for more detailed error
				if (_data.isReference())
					continue;
				
				// check if function call and create arguments buffer
				// ~method
				if (_data.isMethod()) {
					if(_data.isMethodStart()){
						_addMethodTicket(_data.getMethodName());
						if (_data.isFreeExecution()){
							_releaseMethodTicket();
							continue;
						} else if (_data.hasInlineArguments()){
							_lastMethodTicket.target = _data.getInlineMethodArgs();
							_releaseMethodTicket();
							continue;
						} else if (!_data.isMethodEnd()){
							continue;
						}
					}else{
						_signals.ERROR.send(SruErrorSignal, true, 'Error on call [' + _data.lineValue + '] missing function end.', _data.currentLine, _data.lineValue, 2004, '', _data.fileName);
					}
				}
				
				if (_lastMethodTicket) {
					if (!_data.isMethodStart() && _data.isMethodEnd()){
						_releaseMethodTicket();
						continue;
					}
				}
				
				if (_data.isQuery()) {
					//try {
					ticket = ParseTicket.GATE.search(_data.getQueryName());
					if (!ticket.run(_currentObject, _data.getQueryArguments())){
						_signals.ERROR.send(SruErrorSignal, true, ticket.error, _data.currentLine, _data.lineValue, 2003, ticket.stack, _data.fileName);
					}
					continue;
				}
				
				if (_data.isObjectKey()) {
					// Check if param:Class or #Class
					if (_data.isObjectPush()) {	// Check if [#] (push)
						_pushObject(_currentObject, _data.getObjectType(), _data.pathOpen, _data.argumentBuffer);
					} else {				// Create parameter for [param]:Class or [param] {
						_createObject(_currentObject, _data.getObjectType(), _data.getParamName(), _data.pathOpen, _data.argumentBuffer);
					}
					continue;
				}
				
				if (_data.isObjectOpen()) {
					_buildPath(_data.getObjectName());
					continue;
				}
				
				if (_data.isValueSet()) { // default value
					try {
						_data.writeProperty(_currentObject);
					} catch (e:Error) {
						_signals.ERROR.send(SruErrorSignal, true, e.message, _data.currentLine, _data.lineValue, 2001, e.getStackTrace(), _data.fileName);
					}
					continue;
				} else if (_currentObject is IList || _currentObject is Array) {
					_currentObject.push(_data.getLineValue());
				}
				
				continue;
				
			}
			
			if (_data.isBufferEmpty()) {
				_busy = false;
				_parseComplete();
			}
			
			return this;
			
		}
		
		
		/**
		 * @private
		 */
		private function _addMethodTicket(path:String):void {
			_lastMethodTicket = new MethodTicket(path, _currentObject);
			_handlerPath[_handlerPath.length] = _lastMethodTicket;
			_updatePaths(_lastMethodTicket.target);
		}
		
		
		/**
		 * @private
		 */
		private function _releaseMethodTicket():void {
			if (!_handlerPath.pop().call()){
				_signals.ERROR.send(SruErrorSignal, true, ParseTicket.GATE.error, _data.currentLine, _data.lineValue, 2003, ParseTicket.GATE.stack, _data.fileName);
			}
			if (_handlerPath.length > 0) {
				_lastMethodTicket = _handlerPath[_handlerPath.length - 1];
				_updatePaths(_lastMethodTicket.target);
			} else {
				_lastMethodTicket = null;
				_resetTargets();
			}
		}
		
		
		/**
		 * @private
		 */
		private function _resetTargets():void {
			_targetPath = _mainPath;
			_targetChain = _mainChain;
			_targetObject = _mainObject;
			_resetPath();
		}
		
		
		/**
		 * @private
		 */
		private function _updatePaths(flush:Object):void {
			_targetPath = _lastMethodTicket.openPath;
			_targetChain = _lastMethodTicket.chain;
			_targetObject = flush;
			_resetPath();
		}
		
		
		/**
		 *
		 */
		public function SruDecoder(enableDefaultObjects:Boolean = false) {
			_enableDefaultObjects = enableDefaultObjects;
			_mainPath = new Vector.<String>();
			_handlerPath = new Vector.<MethodTicket>();
			_mainChain = new Vector.<uint>();
			_signals = new SruSignals(this);
		}
		
		
		/**
		 *
		 * @param	value
		 * @param	targetObject
		 * @return
		 */
		public function parse(value:String, mergeTo:*, onComplete:Function = null, onError:Function = null, fileId:String = ""):SruDecoder {
			value = "$File<" + fileId + "\r" + value;
			if (_busy) {
				_data.push(value);
				return this;
			}
			_mainObject = mergeTo || new SruObject();
			_currentObject = _mainObject;
			_resetTargets();
			_data.push(value);
			if (onComplete !== null){
				_signals.PARSED.hold(onComplete);
			}
			if (onError !== null){
				_signals.ERROR.hold(onError);
			}
			return _parseData();
		}
		
		
		public function cancel():void {
			_busy = false;
			clearTimeout(_delayedParse);
			_signals.CANCEL.send(SruDecoderSignal, true, true);
		}
		
		
		/**
		 * Top level content
		 */
		public function get content():Object {
			return _mainObject;
		}
		
		
		/**
		 * Main event handler
		 */
		public function get signals():SruSignals {
			return _signals;
		}
		
		
		/**
		 * Dispose decoder instance
		 */
		public function dispose():void {
			_signals.ERROR.dispose();
			_signals.CANCEL.dispose();
			_signals.PARSED.dispose();
		}
		
		/**
		 * 
		 * @param	val
		 * @return
		 */
		private function _coTrace(val:*):* {
			trace(val);
			return val;
		}
	
	}

}

import flash.utils.getQualifiedClassName;
import gate.sirius.serializer.SruDecoder;
class ParseTicket {
	
	public static const GATE:ParseTicket = new ParseTicket();
	
	public var param:String;
	
	public var path:Array;
	
	public var lastQueryName:String;
	
	public var lastArgsLength:uint;
	
	public var error:String;
	
	public var stack:String;
	
	
	public function ParseTicket() {
	}
	
	
	public function search(from:String):ParseTicket {
		lastQueryName = from;
		path = from.split(".");
		param = path.pop();
		return this;
	}
	
	
	public function run(to:*, args:Array):Boolean {
		var obj:* = getEnd(to) || getEnd(SruDecoder.getClassCollection());
		if (obj && param in obj) {
			lastArgsLength = args.length;
			try {
				(obj[param] as Function).apply(to, args);
			} catch (e:Error) {
				error = "Error on call " + lastQueryName + "(args:" + lastArgsLength + ")";
				stack = e.getStackTrace();
				return false;
			}
		} else {
			error = "Error on call method " + lastQueryName + "(), " + (obj ? "Method not found in " + getQualifiedClassName(to) : "Target object is Null");
			return false;
		}
		return true;
	}
	
	
	public function getEnd(to:*):* {
		for each (var p:String in path) {
			if (p in to)
				to = to[p];
			else
				return null;
		}
		return to;
	}
	
	
	public function setValue(to:*, value:*):void {
		(getEnd(to) || getEnd(SruDecoder.getClassCollection()))[param] = value;
	}
	
	
	public function reset():void {
		lastQueryName = null;
		error = "";
		lastArgsLength = 0;
	}

}


class MethodTicket {
	
	private var _result:Boolean;
	
	public var to:Object;
	
	public var path:String;
	
	public var target:Array;
	
	public var openPath:Vector.<String>;
	
	public var chain:Vector.<uint>;
	
	
	public function MethodTicket(path:String, to:Object) {
		this.to = to;
		this.openPath = new Vector.<String>();
		this.chain = new Vector.<uint>();
		this.path = path;
		this.target = [];
	}
	
	
	public function call():Boolean {
		trace('MAIN>', path, openPath, target.length);
		_result = ParseTicket.GATE.search(path).run(to, target);
		this.to = null;
		this.openPath = null;
		this.chain = null;
		this.path = null;
		this.target = null;
		return _result;
	}

}