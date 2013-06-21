package alchemy.vipperland.sirius.core {
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SiriusDecoder {
		
		/** @private */
		static private var _classList:Dictionary = new Dictionary(true);
		
		static private var _fileLogHandler:Function;
		
		private static var _enviro:Dictionary = new Dictionary(true);
		
		
		public static function getRegisteredClass(name:String):Class {
			return _classList[name];
		}
		
		
		public static function getClassCollection():Dictionary {
			return _classList;
		}
		
		
		public static function onFileLog(handler:Function):void {
			_fileLogHandler = handler;
		}
		
		
		/**
		 * Register a list of class(es) for run-time decoding
		 * @param	... classList
		 */
		public static function registerClass(... classList:Array):void {
			
			var className:String;
			var nsIndex:int;
			
			for each (var LClass:Class in classList) {
				
				className = getQualifiedClassName(LClass);
				className = className.split("::").join(BREAK);
				
				if (_classList[className])
					continue;
				
				_classList[className] = LClass;
				
				nsIndex = className.lastIndexOf(BREAK);
				
				if (nsIndex++ > 0) { // without namespace
					
					className = className.substr(nsIndex, className.length - nsIndex);
					
					_classList[className] = LClass;
					
				}
				
			}
		
		}
		
		
		private function _mergeApp(string:String, line:int, path:Array):String {
			
			var index:int = string.indexOf(APPLICATION_REF);
			
			if (index == -1)
				return string;
			
			var eof:int = string.indexOf(OBJECT_CLOSE, index + 4);
			
			if (eof == -1)
				return string;
			
			var command:String = string.substr(index, eof - index + 1);
			
			var param:String = command.substr(3, command.length - 4);
			
			var ifNot:Boolean = param.substr(0, 1) == IF_NOT;
			
			if (ifNot)
				param = param.substr(1, param.length - 1);
			
			var value:* = _searchForParamValue(param);
			
			var exists:Boolean = true;
			
			if (!value) {
				//if (!ifNot)
				//	_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.REFERENCE_ERROR, "Application variable '" + param + "' not found", line);
				exists = false;
			}
			
			var cIndex:Boolean = index > 2 && string.indexOf(CONDITIONAL_IF_REF) == index - 3;
			
			if (cIndex) {
				var elseIof:Boolean = string.indexOf(ELSE) !== -1;
				if (ifNot == exists) {
					if (!elseIof)
						return "";
				}
				++eof;
				string = string.substr(eof, string.length - eof);
				if (elseIof)
					string = string.split(ELSE)[1];
			}
			
			string = string.split(command).join(SiriusEncoder.explore(value, null, path.length + 1));
			
			return _mergeApp(string, line, path);
		
		}
		
		
		private function _mergeEviro(string:String, line:int):String {
			
			var index:int = string.indexOf(ENVIRONMENT_REF);
			
			if (index == -1)
				return string;
			
			var eof:int = string.indexOf(OBJECT_CLOSE, index + 4);
			
			if (eof == -1)
				return string;
			
			var command:String = string.substr(index, eof - index + 1);
			
			var param:String = command.substr(3, command.length - 4);
			
			var ifNot:Boolean = param.substr(0, 1) == IF_NOT;
			
			if (ifNot)
				param = param.substr(1, param.length - 1);
			
			var exists:Boolean = true;
			
			if (!_enviro[param]) {
				exists = false;
					//if(!ifNot)
					//_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.SINTAX_ERROR, "Environment variable '" + param + "' not found", line);
			}
			
			var cIndex:Boolean = string.indexOf(CONDITIONAL_IF_REF) == index - 3;
			
			if (cIndex) {
				var elseIof:Boolean = string.indexOf(ELSE) !== -1;
				if (ifNot == exists) {
					if (!elseIof)
						return "";
				}
				++eof;
				string = string.substr(eof, string.length - eof);
				if (elseIof)
					string = string.split(ELSE)[1];
			}
			
			string = string.split(command).join(_enviro[param]);
			
			return _mergeEviro(string, line);
		
		}
		
		
		/** @private */
		private function _removeComments(string:String):String {
			
			var index:int = string.indexOf(COMMENT_SIMPLE);
			
			if (index == -1)
				return string;
			else if (index == 0)
				return EMPTY;
			else if (string.substr(index - 1, 3) !== HTTP_REF)
				return string.substr(0, index);
			
			return string;
		
		}
		
		
		private function _searchForParamValue(alias:String):* {
			
			var path:Array = alias.split(BREAK);
			
			if (path.length == 1) {
				
				return _classList[alias];
				
			} else if (path.length > 1) {
				
				var targetClass:Class = _classList[path.shift()];
				
				return _getPath(targetClass, path, null);
				
			}
			
			return null;
		
		}
		
		
		public static function getEnvironment(path:String):SiriusDecoder {
			return parse(path, null, null);
		}
		
		private static const LINE_BREAK_1310:String = "\r\n";
		
		private static const LINE_BREAK_10:String = "\n";
		
		private static const LINE_BREAK_13:String = "\r";
		
		private static const LINE_BREAK_GLUE:String = "$__break__$";
		
		private static const SPACE:String = " ";
		
		private static const TAB:String = "	";
		
		private static const EMPTY:String = "";
		
		private static const EQUAL:String = "=";
		
		private static const COMMAND:String = "~";
		
		private static const CLEAR_COMMAND:String = "()";
		
		private static const COMMAND_OPEN:String = "(";
		
		private static const COMMAND_CLOSE:String = ")";
		
		private static const PUSH:String = "#";
		
		private static const OBJECT_OPEN:String = "{";
		
		private static const OBJECT_CLOSE:String = "}";
		
		private static const TYPE:String = ":";
		
		private static const BREAK:String = ".";
		
		private static const NOTATION:String = "·";
		
		private static const IF_NOT:String = "!";
		
		private static const ELSE:String = "<>";
		
		private static const COMMENT_BLOCK_START:String = "/*";
		
		private static const COMMENT_BLOCK_END:String = "*/";
		
		private static const COMMENT_SIMPLE:String = "//";
		
		private static const ENVIRO_DEFINITION:String = "[Define<";
		
		private static const INJECT_DEFINITION:String = "[Inject<";
		
		private static const LOAD_DEFINITION:String = "[Load<";
		
		private static const HEADER_REFERENCE:String = "[REF=";
		
		private static const DEFAULT_CLASS:String = "SiriusObject";
		
		private static const APPLICATION_REF:String = "{A:";
		
		private static const ENVIRONMENT_REF:String = "{E:";
		
		private static const CONDITIONAL_IF_REF:String = "IF:";
		
		private static const HTTP_REF:String = "://";
		
		private static const OBJECT_CLASS:String = "Object";
		
		private static const DICTIONARY_CLASS:String = "Dictionary";
		
		private static const UNTYPED_CLASS:String = "*";
		
		
		/** @private */
		private static function _formatData(data:String):Array {
			data = data.split(LINE_BREAK_1310).join(LINE_BREAK_GLUE);
			data = data.split(LINE_BREAK_13).join(LINE_BREAK_GLUE);
			data = data.split(LINE_BREAK_10).join(LINE_BREAK_GLUE);
			return data.split(LINE_BREAK_GLUE);
		}
		
		
		/** @private */
		private function _getClearLine(data:String):String {
			data = data.split(TAB).join(EMPTY);
			data = data.split(SPACE).join(EMPTY);
			return data;
		}
		
		/** @private */
		private var LINES:Array;
		
		/** @private */
		protected var _waitForBracerClose:int;
		
		
		/** @private */
		private function _parse(string:String):SiriusObject {
			
			LINES = _formatData(string);
			
			var path:Array = new Array();
			
			var mainObject:SiriusObject = _content;
			var currentObject:* = mainObject;
			var tempObject:*;
			
			_waitForBracerClose = 0;
			
			var line:String;
			var clearLine:String;
			
			var index:int;
			
			var isCommentBlock:Boolean;
			var isArray:Boolean;
			
			var paramName:String;
			var functionParam:String;
			var className:String;
			var classType:Class;
			var paramValue:*;
			var currentLine:int = -1;
			var maxLines:int = LINES.length;
			var refValue:Array;
			
			_currentFileLine = 0;
			
			_totalLines += maxLines;
			
			level0: while (++currentLine < maxLines) {
				
				_currentLine = currentLine + 1;
				
				line = LINES[currentLine];
				
				index = -1;
				
				if (isCommentBlock) {
					
					index = line.indexOf(COMMENT_BLOCK_END);
					
					if (index == -1) {
						continue level0;
					}
					
					line = line.substr(index, line.length - index - 2);
					
					isCommentBlock = false;
					
					if (line.length == 0) {
						continue level0;
					}
					
				}
				
				line = _removeComments(line);
				
				line = _mergeEviro(line, _currentLine - _currentFileLine);
				
				line = _mergeApp(line, _currentLine - _currentFileLine, path);
				
				clearLine = _getClearLine(line);
				
				if (clearLine.length == 0) {
					continue level0;
				}
				
				if (clearLine.indexOf(COMMENT_BLOCK_START) !== -1) {
					
					index = line.indexOf(COMMENT_BLOCK_END);
					
					if (index == -1) {
						isCommentBlock = true;
						continue level0;
					}
					
					line = line.substr(index + 2, line.length - index - 2);
					
					clearLine = _getClearLine(line);
					
					if (clearLine.length == 0) {
						continue level0;
					}
					
				}
				
				while (line.substr(line.length - 1, 1) == SPACE) {
					line = line.substr(0, line.length - 1);
				}
				
				index = clearLine.indexOf(ENVIRO_DEFINITION);
				
				if (index !== -1) {
					
					clearLine = clearLine.substr(8, clearLine.length - 9);
					
					index = clearLine.indexOf(EQUAL);
					
					if (index > 0) {
						
						refValue = clearLine.split(EQUAL);
						
						paramName = refValue[0];
						
						paramValue = refValue[1];
						
						_enviro[paramName] = paramValue;
						
					} else {
						
						_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.SINTAX_ERROR, "Error on [Define<VARIABLE=VALUE] sintax", _currentLine - _currentFileLine, _currentFile);
						
					}
					
					continue level0;
					
				}
				
				if (clearLine.indexOf(NOTATION) == 0) {
					try {
						currentObject.push(line);
					} catch (e:Error) {
						trace(e);
						_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.SINTAX_ERROR, "Notation error for object explorer. Can't push property on " + getQualifiedClassName(currentObject), _currentLine - _currentFileLine, _currentFile);
					}
					continue level0;
				}
				
				index = clearLine.indexOf(HEADER_REFERENCE);
				
				if (index !== -1) {
					
					_currentFile = clearLine.substring(index + 5, clearLine.length - 1);
					
					_currentFileLine = _currentLine;
					
					continue level0;
					
				}
				
				index = clearLine.indexOf(LOAD_DEFINITION);
				
				if (index !== -1) {
					
					clearLine = clearLine.substr(6, clearLine.length - 7);
					
					_toLoad[_toLoad.length] = clearLine;
					
					continue;
					
				}
				
				index = clearLine.indexOf(INJECT_DEFINITION);
				
				if (index !== -1) {
					
					clearLine = clearLine.substr(8, clearLine.length - 9);
					
					index = clearLine.indexOf(EQUAL);
					
					if (index > 0) {
						
						refValue = clearLine.split(EQUAL);
						
						paramName = refValue[0];
						
						paramValue = _searchForParamValue(refValue[1]);
						
						try {
							currentObject[paramName] = paramValue;
						} catch (e:Error) {
							_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.MISSING_PROPERTY, "Missing " + getQualifiedClassName(currentObject) + "[" + paramName + "] (value " + paramValue + ")", _currentLine - _currentFileLine, _currentFile);
						}
						
					} else {
						
						paramValue = _searchForParamValue(refValue[1]);
						
						currentObject.push(paramValue);
						
					}
					
					if (currentObject.hasOwnProperty("siriusRules")) {
						if (!currentObject.siriusRules) {
							currentObject.siriusRules = new SiriusEncoderRules();
							(currentObject.siriusRules as SiriusEncoderRules).built(currentObject);
						}
						(currentObject.siriusRules as SiriusEncoderRules).addInjectionCommand(_getClearLine(line));
						(currentObject.siriusRules as SiriusEncoderRules).setProperty(paramName, false);
					}
					
					continue level0;
					
				} else if (clearLine.indexOf(COMMAND) == 0) {
					
					if (_waitForBracerClose > 0) {
						continue level0;
					}
					
					clearLine = clearLine.substr(1, clearLine.length - 1);
					
					index = clearLine.indexOf(CLEAR_COMMAND);
					
					if (index > 0) {
						
						paramName = clearLine.substr(0, index);
						
						if (currentObject.hasOwnProperty(paramName)) {
							currentObject[paramName]();
						} else {
							_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.FUNCTION_NOT_FOUND, "The function \"" + paramName + "\" can't found on " + getQualifiedClassName(currentObject), _currentLine - _currentFileLine, _currentFile);
						}
						
						continue level0;
						
					}
					
					index = clearLine.indexOf(COMMAND_OPEN);
					
					if (index == clearLine.length - 1) {
						
						paramName = clearLine.substr(0, clearLine.length - 1);
						
						var functionParams:Array = new Array();
						
						var closeBracers:int = 0;
						
						level1: while (++currentLine < maxLines) {
							
							functionParam = LINES[currentLine];
							
							clearLine = _getClearLine(functionParam);
							
							index = clearLine.indexOf(COMMAND_OPEN);
							
							if (index == clearLine.length - 1)
								++closeBracers;
							
							if (clearLine.indexOf(COMMAND_CLOSE) == 0) {
								if (closeBracers == 0)
									break level1;
								else
									--closeBracers;
							} else {
								functionParams[functionParams.length] = functionParam;
							}
							
						}
						
					} else if (clearLine.indexOf(COMMAND_CLOSE) == clearLine.length - 1) {
						paramName = clearLine.substr(0, index);
						paramValue = clearLine.substr(index + 1, clearLine.length - paramName.length - 2);
						functionParams = paramValue.split(",");
					}
					
					if (functionParams.length > 0) {
						
						functionParams.unshift("#Array{");
						functionParams[functionParams.length] = OBJECT_CLOSE;
						
						line = functionParams.join(LINE_BREAK_13);
						
						functionParams = parse(line).extract(Array);
						
						if (currentObject.hasOwnProperty(paramName)) {
							
							currentObject[paramName].apply(currentObject, functionParams);
							
						} else {
							
							_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.FUNCTION_NOT_FOUND, "The function \"" + paramName + "\" can't found on " + getQualifiedClassName(currentObject), _currentLine - _currentFileLine, _currentFile);
							
						}
						
					}
					
					continue level0;
					
				} else if (clearLine.indexOf(PUSH) == 0) { // Push a Typed Object
					
					if (_waitForBracerClose > 0) {
						++_waitForBracerClose;
						continue;
					}
					
					index = clearLine.indexOf(OBJECT_OPEN);
					
					if (index > 0) {
						
						className = clearLine.substr(1, index - 1);
						
						if (className == OBJECT_CLASS || className == DICTIONARY_CLASS || className == "")
							className = DEFAULT_CLASS;
						
					} else {
						
						className = clearLine.substr(1, clearLine.length - 1);
						
						if (className == UNTYPED_CLASS)
							className = DEFAULT_CLASS;
						
						classType = _classList[className];
						
						if (!classType) {
							
							//++_waitForBracerClose;
							
							_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.CLASS_NOT_FOUND, "Class not found [" + className + "]. Hint: You can use SiriusDecoder.registerClass(...) to add missed classes", _currentLine - _currentFileLine, _currentFile);
							continue level0;
							
						}
						
						tempObject = new classType;
						
						currentObject.push(tempObject);
						
						if (tempObject is ISiriusStarter) {
							try {
								(tempObject as ISiriusStarter).onParsed();
							} catch (e:Error) {
								_criticalErrors[_criticalErrors.length] = new SiriusDecoderError(SiriusDecoderError.PARSER_ERROR, e.getStackTrace(), _currentLine - _currentFileLine, _currentFile);
							}
						}
						
						continue level0;
						
					}
					
					try {
						clearLine = currentObject.length + TYPE + className + OBJECT_OPEN;
					} catch (e:Error) {
						errors[errors.length] = new SiriusDecoderError(SiriusDecoderError.PARSER_ERROR, "Can't push a property " + className + " in a non dynamic class " + currentObject, _currentLine - _currentFileLine, _currentFile);
					}
					
				}
				
				index = line.indexOf(EQUAL);
				
				if (index > 0) { // Set value
					
					if (_waitForBracerClose > 0)
						continue level0;
					
					paramName = String(clearLine.split(EQUAL)[0]);
					
					paramValue = String(line.substr(index + 1, line.length - index - 1));
					
					while (paramValue.substr(0, 1) == SPACE)
						paramValue = paramValue.substr(1, line.length - 1);
					
					while (paramValue.substr(0, 1) == TAB)
						paramValue = paramValue.substr(1, line.length - 1);
					
					try {
						
						if (paramValue.length == 0)
							currentObject[paramName] = EMPTY; //Cast to empty string
						
						else if (paramValue.length < 20 && !isNaN(Number(paramValue)))
							currentObject[paramName] = Number(paramValue); //Cast to Number if str len is less than 20
						
						else if (paramValue == "true" || paramValue == "false")
							currentObject[paramName] = (paramValue == "true"); //Cast to Boolean
						
						else if (paramValue == "null")
							currentObject[paramName] = null; //Cast to null
						
						else
							currentObject[paramName] = paramValue.split("	").join(""); //Cast to String
						
					} catch (e:Error) {
						
						_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.MISSING_PROPERTY, "Missing " + getQualifiedClassName(currentObject) + "[" + paramName + "]", _currentLine - _currentFileLine, _currentFile);
						
					}
					
					continue level0;
					
				} else if (clearLine.indexOf(OBJECT_OPEN) > 0) { // Open named Object
					
					if (_waitForBracerClose > 0) {
						++_waitForBracerClose;
						continue;
					}
					
					paramName = clearLine.substr(0, clearLine.length - 1);
					
					index = paramName.indexOf(TYPE);
					
					if (index > 0) {
						
						className = paramName.substr(index + 1, paramName.length);
						
						if (className == OBJECT_CLASS || className == DICTIONARY_CLASS || className == UNTYPED_CLASS)
							className = DEFAULT_CLASS;
						
						paramName = paramName.substr(0, index);
						
					} else {
						className = DEFAULT_CLASS;
					}
					
					classType = _classList[className];
					
					if (!classType) {
						
						++_waitForBracerClose;
						
						_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.CLASS_NOT_FOUND, "Class not found [" + className + "]. Hint: You can use SiriusDecoder.registerClass(...) to add missed classes", _currentLine - _currentFileLine, _currentFile);
						continue level0;
						
					}
					
					path[path.length] = paramName;
					
					currentObject = _getPath(mainObject, path, classType);
					
					classType = null;
					
					continue level0;
					
				} else if (clearLine.indexOf(OBJECT_OPEN) == 0) { //Push a default Object
					
					if (_waitForBracerClose > 0) {
						++_waitForBracerClose;
						continue;
					}
					
					path[path.length] = String(currentObject.length);
					
					currentObject = _getPath(mainObject, path, SiriusObject);
					
					classType = null;
					
					continue level0;
					
				} else if (clearLine.indexOf(OBJECT_CLOSE) == 0) { // Close last Object
					
					if (_waitForBracerClose > 0) {
						--_waitForBracerClose;
						continue level0;
					}
					
					path.pop();
					
					if (currentObject is ISiriusStarter) {
						try {
							(currentObject as ISiriusStarter).onParsed();
						} catch (e:Error) {
							_criticalErrors[_criticalErrors.length] = new SiriusDecoderError(SiriusDecoderError.PARSER_ERROR, e.getStackTrace(), _currentLine - _currentFileLine, _currentFile);
						}
					}
					
					currentObject = _getPath(mainObject, path, null);
					
					continue level0;
					
				} else if (clearLine.indexOf(BREAK) == 0) { // Line break concat
					
					if (!currentObject.hasOwnProperty(paramName))
						continue level0;
					
					index = line.indexOf(BREAK);
					
					paramValue = line.substr(index + 1, line.length - index - 1);
					
					currentObject[paramName] += LINE_BREAK_1310 + paramValue;
					
					continue level0;
					
				} else {
					
					index = clearLine.indexOf(TYPE);
					
					if (index > 0) {
						
						paramName = clearLine.substr(index + 1, 1);
						
						if (paramName == PUSH) {
							
							paramName = clearLine.substr(0, index);
							
							className = clearLine.substr(index + 1, clearLine.length - index - 1);
							
							if (className == UNTYPED_CLASS)
								className = DEFAULT_CLASS;
							
							classType = _classList[className];
							
							if (!classType) {
								_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.CLASS_NOT_FOUND, "Class not found [" + className + "]. Hint: You can use SiriusDecoder.registerClass(...) to add missed classes", _currentLine - _currentFileLine, _currentFile);
								continue level0;
							}
							
							try {
								currentObject[paramName] = new classType;
							} catch (e:Error) {
								_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.MISSING_PROPERTY, "Missing " + getQualifiedClassName(currentObject) + "[" + paramName + "]", _currentLine - _currentFileLine, _currentFile);
							}
							
							continue level0;
							
						}
						
					}
					
					while (line.substr(0, 1) == TAB)
						line = line.substr(1, line.length - 1);
					
					while (line.substr(0, 1) == SPACE)
						line = line.substr(1, line.length - 1);
					
					currentObject.push(line);
					
					continue level0;
					
				}
				
			}
			
			return mainObject;
		
		}
		
		
		/** @private */
		private function _getPath(object:*, path:Array, Type:Class):* {
			
			var currentObject:* = object;
			var pushObject:*;
			
			for each (var pathName:String in path) {
				
				pushObject = currentObject[pathName];
				
				if (!pushObject && Type) {
					
					pushObject = new Type;
					
					try {
						if (!isNaN(parseInt(pathName)) && (currentObject is Array || currentObject is SiriusObject))
							currentObject.push(pushObject);
						else
							currentObject[pathName] = pushObject;
					} catch (e:Error) {
						_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.MISSING_PROPERTY, "Missing " + getQualifiedClassName(currentObject) + "[" + pathName + "]", _currentLine - _currentFileLine, _currentFile);
						/////////////////
						//++_waitForBracerClose;
						return null;
					}
					
				}
				
				if (!pushObject) {
					_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.REFERENCE_ERROR, "Missing " + getQualifiedClassName(currentObject) + "[" + pathName + "]", _currentLine - _currentFileLine, _currentFile);
					//++_waitForBracerClose;
					return null;
				}
				
				currentObject = pushObject;
				
			}
			
			return currentObject;
		
		}
		
		private static var _preinit:Boolean;
		
		
		/**
		 * Value of decoded object
		 * @param	data
		 * @return
		 */
		public static function parse(data:String, onParseComplete:Function = null, target:* = null):SiriusDecoder {
			
			if (!_preinit) {
				registerClass(Object, Array, SiriusObject);
				_preinit = true;
			}
			
			var result:SiriusDecoder = new SiriusDecoder(onParseComplete, target);
			result._initParser(data);
			
			return result;
		
		}
		
		private var _content:*;
		
		private var _data:String;
		
		private var _errors:Vector.<SiriusDecoderError>;
		
		private var _criticalErrors:Vector.<SiriusDecoderError>;
		
		private var _currentLine:int;
		
		private var _currentFileLine:int;
		
		private var _toLoad:Vector.<String>;
		
		private var _onParseComplete:Function;
		
		private var _loader:URLLoader;
		
		private var _totalLines:int;
		
		private var _lastURL:String;
		
		private var _currentFile:String;
		
		
		public function SiriusDecoder(onParseComplete:Function = null, target:* = null) {
			_content = target;
			_onParseComplete = onParseComplete;
			_errors = new Vector.<SiriusDecoderError>();
			_criticalErrors = new Vector.<SiriusDecoderError>();
		}
		
		
		public static function clone(target:*):SiriusDecoder {
			var value:String = SiriusEncoder.getValue(target);
			return parse(value);
		}
		
		
		private function _initParser(data:String):void {
			
			_toLoad = new Vector.<String>();
			
			if (!_content)
				_content = new SiriusObject();
			
			_data = "[REF=root]";
			
			_parseCheck(data);
		
		}
		
		
		protected function _parseCheck(data:String):void {
			
			_data += data + "\n";
			
			try {
				_parse(data);
			} catch (e:Error) {
				var ser:SiriusDecoderError = new SiriusDecoderError(SiriusDecoderError.PARSER_ERROR, e.getStackTrace(), _currentLine - _currentFileLine, _currentFile);
				_errors[_errors.length] = ser;
				_criticalErrors[_criticalErrors.length] = ser;
			}
			
			if (_toLoad.length > 0) {
				if (_fileLogHandler !== null) {
					_fileLogHandler(_toLoad.length, _toLoad[0], null);
				}
				_loadFile();
				return;
			}
			
			if (_loader) {
				_loader.removeEventListener(Event.COMPLETE, _loadFile);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, _loadFile);
			}
			
			if (_onParseComplete !== null) {
				_onParseComplete(this);
				_onParseComplete = null;
			}
		}
		
		
		protected function _loadFile(e:Event = null):void {
			
			if (e is IOErrorEvent) {
				_errors[_errors.length] = new SiriusDecoderError(SiriusDecoderError.LOAD_ERROR, "File \"" + (e as IOErrorEvent).text.split(" ").join("").split("URL:")[1] + "\" not found", 0, null);
				_parseCheck("");
				return;
			} else if (e is Event) {
				if (_fileLogHandler !== null) {
					_fileLogHandler(_toLoad.length, _lastURL, e.target);
				}
				_parseCheck(("[REF=" + _lastURL + "]\n") + e.target.data);
				return;
			}
			
			if (!_loader) {
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, _loadFile);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, _loadFile);
			}
			
			var url:String = _toLoad.shift();
			_lastURL = url;
			_loader.load(new URLRequest(url + "?t=" + Math.random()));
		
		}
		
		
		public function extract(type:*):* {
			
			for each (var obj:*in _content)
				if (obj is type)
					return obj;
				else if (getQualifiedClassName(obj).indexOf(type) !== -1)
					return obj;
			
			return null;
		
		}
		
		
		public function extractAll(... types:Array):* {
			
			if (types.length == 0)
				return _content;
			
			var result:Array = new Array();
			
			for each (var t:*in _content) {
				for each (var T:Class in types)
					if (t is T)
						if (result.indexOf(t) == -1)
							result[result.length] = t;
			}
			
			return result;
		
		}
		
		
		public function dispose():void {
			_content = null;
			_data = null;
			_errors = null;
			_criticalErrors = null
			_toLoad = null;
			_onParseComplete = null;
			_loader = null;
			_lastURL = null;
			_currentFile = null;
			LINES = null;
		}
		
		
		public function get content():* {
			return _content;
		}
		
		
		public function get errors():Vector.<SiriusDecoderError> {
			return _errors;
		}
		
		
		public function get hasError():Boolean {
			return _errors.length > 0;
		}
		
		
		public function get data():String {
			return _data;
		}
		
		
		public function get totalLines():int {
			return _totalLines;
		}
		
		
		public function get criticalErrors():Vector.<SiriusDecoderError> {
			return _criticalErrors;
		}
	
	}

}