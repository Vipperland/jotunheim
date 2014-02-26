package gate.sirius.serializer {
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import gate.sirius.serializer.data.SruData;
	import gate.sirius.serializer.hosts.IList;
	import gate.sirius.serializer.hosts.IStartable;
	import gate.sirius.serializer.hosts.SruObject;
	import gate.sirius.serializer.signals.SruDecoderSignal;
	import gate.sirius.signals.ISignalizer;
	import gate.sirius.signals.SignalDispatcher;
	import gate.sirius.timer.ActiveController;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruDecoder {
		
		/**
		 * @private
		 */
		static private const CLASS_COLLECTION:Dictionary = new Dictionary(true);
		
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
			for each (var name:String in names) {
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
			if (name == "Object" || name == "Array" || name == "*") {
				return SruObject;
			}
			return CLASS_COLLECTION[name] || (allowDefaultObject ? SruObject : null);
		}
		
		/**
		 * @private
		 */
		static private const COMMENT_LINE:String = "//";
		
		/**
		 * @private
		 */
		static private const COMMENT_BLOCK_START:String = "/*";
		
		/**
		 * @private
		 */
		static private const COMMENT_BLOCK_END:String = "*/";
		
		/**
		 *
		 * @param	value
		 * @param	mergeTo
		 * @return
		 */
		static public function parse(value:String, mergeTo:* = null, enableDefaultObjects:Boolean = false):SruDecoder {
			return new SruDecoder(enableDefaultObjects).parse(value, mergeTo);
		}
		
		/**
		 * @private
		 */
		private const _data:SruData = new SruData();
		
		/**
		 * @private
		 */
		private var _content:Object;
		
		/**
		 * @private
		 */
		private var _currentObject:Object;
		
		/**
		 * @private
		 */
		private var _skipping:Boolean;
		
		/**
		 * @private
		 */
		private var _openPath:Vector.<String>;
		
		/**
		 * @private
		 */
		private var _missingObjects:int;
		
		/**
		 * @private
		 */
		private var _signals:ISignalizer;
		
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
		
		/**
		 *
		 * @param	param
		 * @param	className
		 * @return
		 * @private
		 */
		private function _buildPath(param:*):Boolean {
			if (param) {
				_openPath[_openPath.length] = param;
			} else {
				_openPath.pop();
				if (_currentObject is IStartable)
					(_currentObject as IStartable).onParseClose();
			}
			_currentObject = _content;
			for each (var str:String in _openPath) {
				try {
					_currentObject = _currentObject[str];
					if (_currentObject is IStartable)
						(_currentObject as IStartable).onParseOpen();
				} catch (e:Error) {
					// !ERROR! Can't create property
					return false;
				}
			}
			return false;
		}
		
		/**
		 * @private
		 */
		private function _pushObject(currentObject:Object, objectType:String, open:Boolean):uint {
			var index:uint;
			try {
				var CType:Class = getClass(objectType, _enableDefaultObjects);
				index = currentObject.push(new CType);
				if (open)
					_buildPath(index - 1);
			} catch (e:Error) {
				// !ERROR!
				if (open)
					++_missingObjects;
			}
			return index;
		}
		
		/**
		 * @private
		 */
		private function _createObject(currentObject:Object, objectType:String, paramName:String, open:Boolean):void {
			try {
				var CType:Class = getClass(objectType, _enableDefaultObjects);
				currentObject[paramName] = new CType();
				if (open)
					_buildPath(paramName);
			} catch (e:Error) {
				// !ERROR!
				if (open)
					++_missingObjects;
			}
		}
		
		/**
		 * @private
		 */
		private function _parseComplete():void {
			_signals.send(new SruDecoderSignal(SruDecoderSignal.COMPLETE, this));
		}
		
		/**
		 * @private
		 */
		private function _parseData():void {
			
			var index:uint;
			var param:String;
			
			_startTime = getTimer();
			_blockParseTime = _startTime;
			
			while (_data.hasBuffer()) {
				
				if (_refreshTime()) {
					ActiveController.GATE.delayedCall(_resumeParser, 250, 0);
					return;
				}
				
				switch (_data.comment) {
					// Stop skipping mode if comment block end [*/]
					case COMMENT_BLOCK_END:  {
						_skipping = false;
					}
					// Start skipping lines if comment block start [/*]
					case COMMENT_BLOCK_START:  {
						_skipping = true;
					}
					// Skip current line if single comment line found [//]
					case COMMENT_LINE:  {
						continue;
					}
				}
				
				// Case comment block skipping
				if (_skipping) {
					continue;
				}
				
				// Case object enclosing } found
				if (_data.isObjectClose()) {
					if (_missingObjects == 0) {
						_buildPath(null);
					} else {
						--_missingObjects;
					}
					continue;
				}
				
				// Case error lines causes script damage, the entire bracket session will be skipped
				if (_missingObjects > 0) {
					if (_data.isObjectOpen()) {
						++_missingObjects;
					}
					continue;
				}
				
				if (_data.isObjectKey()) { // Check if param:Class or #Class
					
					if (_data.isObjectPush()) { // Check if [#] (push)
						_pushObject(_currentObject, _data.getObjectType(), _data.pathOpen);
					} else { // Create parameter for [param]:Class
						_createObject(_currentObject, _data.getObjectType(), _data.getParamName(), _data.pathOpen);
					}
					
					continue;
				}
				
				if (_data.isQuery()) {
					try {
						ParseTicket.GATE.search(_data.getQueryName()).run(_currentObject, _data.getQueryArguments());
					} catch (e:Error) {
						// !ERROR! Function not found or invalid arguments count
					}
					continue;
				}
				
				if (_data.isValueSet()) { // default value
					_currentObject[_data.getParamName()] = _data.getParamValue();
					continue;
				} else if (_currentObject is IList) {
					(_currentObject as IList).push(_data.getLineValue());
				}
				
			}
			
			if (_data.isBufferEmpty()) {
				_parseComplete();
			}
		
		}
		
		/**
		 *
		 */
		public function SruDecoder(enableDefaultObjects:Boolean = false) {
			_enableDefaultObjects = enableDefaultObjects;
			_openPath = new Vector.<String>();
			_signals = new SignalDispatcher(this);
		}
		
		/**
		 *
		 * @param	value
		 * @param	targetObject
		 * @return
		 */
		public function parse(value:String, targetObject:Object):SruDecoder {
			_content = targetObject || new SruObject();
			_currentObject = _content;
			_data.push(value);
			ActiveController.GATE.delayedCall(_parseData, 100);
			return this;
		}
		
		public function cancel():void {
			ActiveController.GATE.cancelDelayedCall(_resumeParser);
		}
		
		/**
		 * @private
		 */
		public function get content():Object {
			return _content;
		}
		
		/**
		 * @private
		 */
		public function get signals():ISignalizer {
			return _signals;
		}
	
	}

}

class ParseTicket {
	
	public static const GATE:ParseTicket = new ParseTicket();
	
	public var param:String;
	public var path:Array;
	
	public function ParseTicket() {
	}
	
	public function search(from:String):ParseTicket {
		path = from.split(".");
		param = path.pop();
		return this;
	}
	
	public function run(to:*, args:Array):void {
		(getEnd(to)[param] as Function).apply(to, args);
	}
	
	public function getEnd(to:*):* {
		for each (var p:String in path) {
			to = to[p];
		}
		return to;
	}
	
	public function setValue(to:*, value:*):void {
		getEnd(to)[param] = value;
	}

}