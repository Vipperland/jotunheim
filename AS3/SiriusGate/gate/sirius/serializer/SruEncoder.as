package gate.sirius.serializer {
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import gate.sirius.serializer.data.SruComm;
	import gate.sirius.serializer.data.SruRules;
	import gate.sirius.serializer.hosts.IRules;
	import gate.sirius.serializer.hosts.SruObject;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import flash.xml.XMLNode;
	
	import flash.utils.describeType;
	
	public class SruEncoder {
		
		/** @private */
		private static var _classNames:Dictionary = new Dictionary(true);
		
		public static var excludeDisplayObjects:Boolean = false;
		
		/** @private */
		private static var _excludeDisplayObjectKeys:Vector.<String> = Vector.<String>(["transform", "scrollRect", "hitArea",
			"stage", "parent", "scale9Grid", "softKeyboardInputAreaOfInterest", "accessibilityImplementation", "accessibilityProperties",
			"soundTransform", "filters", "contextMenu", "mask", "focusRect", "fullScreenSourceRect", "defaultTextFormat",
			"alwaysShowSelection", "mouseX", "mouseY", "numChildren", "loaderInfo", "root"]);
		
		/** @private */
		private static var _excludeDisplayObjectKeysIfFalse:Vector.<String> = Vector.<String>(["z", "width", "height", "rotation",
			"rotationX", "rotationY", "rotationZ", "buttonMode", "cacheAsBitmap", "needsSoftKeyboard", "tabEnabled", "trackAsMenu",
			"doubleClickEnabled", "opaqueBackground", "focus", "name", "background", "border", "borderColor", "condenseWhite",
			"displayAsPassword", "embedFonts", "maxChars", "multiline", "restrict", "scrollH", "scrollV", "sharpness", "styleSheet",
			"thickness", "useRichTextClipboard", "wordWrap"]);
		
		/** @private */
		private static var _excludeDisplayObjectKeysIfTrue:Vector.<String> = Vector.<String>(["scaleX", "scaleY", "scaleZ",
			"alpha", "enabled", "mouseChildren", "mouseEnabled", "tabChildren", "useHandCursor", "visible", "showDefaultContextMenu",
			"stageFocusRect", "mouseWheelEnabled", "selectable"]);
		
		/** @private */
		private static var BREAK:String = "\n";
		
		
		/** @private */
		private static function _getClassName(classNamespace:String):String {
			
			var className:String = _classNames[classNamespace];
			
			if (className == null) {
				
				var nsIndex:int;
				
				className = classNamespace;
				
				nsIndex = className.lastIndexOf(":");
				
				if (nsIndex++ > 0)
					className = className.substr(nsIndex, className.length - nsIndex);
				
				if (className.substr(className.length - 1, 1) == ">")
					className = className.substr(0, className.length - 1);
				
				if (className == "SiriusObject" || className == "Dictionary")
					className = "SiriusObject";
				
				_classNames[classNamespace] = className;
				
			}
			
			return className;
		
		}
		
		
		private static function _clearLinebreaks(value:String, ident:int):String {
			value = value.split("\r\n").join("\n");
			value = value.split("\n").join("\r");
			value = value.split("\r").join("/NL;");
			return value;
		}
		
		
		/** @private */
		private static function _internalToString(value:Object, ident:int = 0, refs:Dictionary = null, sign:Boolean = false, filters:Object = null):String {
			
			var str:String;
			
			var type:String = value == null ? "null" : typeof(value);
			
			switch (type) {
				
				case "boolean":
				
				case "number":
					
					return value.toString();
				
				case "string":
					
					return _clearLinebreaks(value.toString(), ident);
				
				case "object":
					
					if (value is Date) {
						
						return value.toString();
						
					} else if (value is XMLNode || value is XML) {
						
						return _clearLinebreaks(value.toString(), ident);
						
					} else if (value is Class) {
						
						return "#" + getQualifiedClassName(value);
						
					} else {
						
						var classInfo:Object = getClassInfo(value);
						
						var properties:Array = classInfo.properties;
						
						var name:String = _getClassName(classInfo.name);
						
						str = (sign ? "#" : "") + name + " {";
						
						if (refs == null)
							refs = new Dictionary(true);
						
						try {
							var id:Array = refs[value];
							if (id != null) {
								str += id.join(_newline("", ident + 1));
								str = _newline(str, ident);
								str += "}";
								return str;
							}
						} catch (e:Error) {
							return String(value);
						}
						
						var isSO:Boolean = value is SruObject;
						var respectIndex:Boolean = isSO && value.isIndexed();
						var isArray:Boolean = value is Array || (isSO && !respectIndex);
						var isDict:Boolean = value is Dictionary;
						var isDisplayObject:Boolean = value is DisplayObject;
						var prop:*;
						var isN:Boolean;
						var valuesArray:Array = new Array("");
						var valueString:String;
						
						++ident;
						
						if (value)
							refs[value] = "";
						
						var filter:IRules = value as IRules;
						var valueRef:*;
						
						for (var j:int = 0; j < properties.length; j++) {
							
							valueString = "";
							
							prop = properties[j];
							valueRef = value[prop];
							
							if (valueRef is SruRules)
								continue;
							
							if (!(valueRef is Function)) {
							
								if (filter) {
									if (!filter.rules.isVisible(prop))
										continue;
								}
								
								if (isDisplayObject) {
									if (excludeDisplayObjects) {
										continue;
									} else if (_excludeDisplayObjectKeys.indexOf(String(prop)) !== -1)
										continue;
									else if (_excludeDisplayObjectKeysIfFalse.indexOf(String(prop)) !== -1) {
										if (!valueRef)
											continue;
									} else if (_excludeDisplayObjectKeysIfTrue.indexOf(String(prop)) !== -1) {
										if (int(valueRef))
											continue;
									}
								}
								
								isN = isArray ? isNaN(prop) : true;
								
								if (prop != 'command' || valueRef != null){
									if (isN && !isDict)
										valueString += prop.toString();
									
									if (valueRef is SruComm) {
										valueString += BREAK + valueRef.getData(ident);
									} else {
										if (!isDict) {
											if (typeof valueRef == "object" && valueRef !== null && isN)
												valueString += " : ";
											else if (isN)
												valueString += " = ";
										}
										
										try {
											valueString += _internalToString(valueRef, ident, refs, !isN || isDict, filters);
										} catch (e:Error) {
											valueString += "undefined";
										}
									}
								}
								
							}else {
								valueString = "// method:" + prop;
							}
							
							valuesArray[valuesArray.length] = valueString;
							
						}
						
						//valuesArray = isArray ? valuesArray.sort(Array.NUMERIC) : valuesArray.sort();
						
						refs[value] = valuesArray;
						
						str += valuesArray.join(_newline("", ident));
						
						--ident;
						
						if (ident !== -1) {
							str = _newline(str, ident);
							str += "}";
						}
						
						return str;
					}
					break;
				
				case "xml":
					
					return value.toXMLString();
				
				case "function":
					
					return "// @[method]";
				
				default:
					
					return type;
			
			}
			
		}
		
		
		/** @private */
		private static function _newline(str:String, n:int = 0):String {
			
			var result:String = str;
			result += BREAK;
			
			for (var i:int = 0; i < n; i++) {
				result += "	";
			}
			return result;
		}
		
		
		public static function getClassName(obj:Object):String {
			var n:String = getQualifiedClassName(obj);
			return n.indexOf("::") > -1 ? getQualifiedClassName(obj).split("::")[1] : n;
		}
		
		
		/**
		 * Get a Class info object
		 * @param	obj
		 * @param	options
		 * @return
		 */
		public static function getClassInfo(obj:Object, options:Object = null):Object {
			
			var n:int;
			var i:int;
			
			var result:Object;
			var propertyNames:Array = [];
			var propertyTypes:Object = {};
			var cacheKey:String;
			
			var className:String;
			var properties:XMLList;
			var prop:XML;
			var qName:QName;
			
			var classInfo:XML = describeType(obj);
			
			className = getQualifiedClassName(obj);
			
			properties = classInfo..accessor.(hasOwnProperty("@access")) + (classInfo..variable + classInfo..constant);
			
			var numericIndex:Boolean = false;
			
			result = {};
			result["name"] = className;
			result["dynamic"] = classInfo.@isDynamic.toString();
			
			var isArray:Boolean = (className.indexOf("__AS3__.vec") !== -1 || obj is Array);
			var isDict:Boolean = (className == "flash.utils::Dictionary");
			var isSObj:Boolean = obj is SruObject;
			
			var includeTypes:Boolean;
			var includeMethods:Boolean;
			var includeStatic:Boolean;
			if (options) {
				includeStatic = options.includeStatic;
				includeTypes = options.includeTypes;
				includeMethods = options.includeMethods;
			}
			
			if (isDict) {
				for (var key:*in obj)
					propertyNames[propertyNames.length] = key;
			} else {
				for (var p:String in obj) {
					if (isArray) {
						var pi:Number = parseInt(p);
						if (isNaN(pi))
							propertyNames[propertyNames.length] = (new QName("", p));
						else
							propertyNames[propertyNames.length] = (pi);
						continue;
					}
					propertyNames[propertyNames.length] = new QName("", p);
				}
				numericIndex = isArray && !isNaN(Number(p));
			}
			
			if (isArray) {
				
				var vars:XMLList = classInfo..variable;
				
				for each (var pname:XML in vars) {
					qName = new QName("", pname.@name);
					propertyNames[propertyNames.length] = qName;
					if (includeTypes) {
						propertyTypes[qName.toString()] = pname.@type.toString();
					}
					numericIndex = false;
				}
				
				var ind:int = propertyNames.indexOf("length");
				if (ind !== -1)
					propertyNames.splice(ind, 1);
				ind = propertyNames.indexOf("fixed");
				if (ind !== -1)
					propertyNames.splice(ind, 1);
				
			} else if (isDict || className == "Object") {
				
				for (p in obj) {
					propertyTypes[p] = getQualifiedClassName(obj[p]);
				}
				
			} else if (className == "XML") {
				n = properties.length();
				for (i = 0; i < n; i++) {
					p = properties[i].name();
					propertyNames[propertyNames.length] = (new QName("", "@" + p));
				}
			} else {
				
				n = properties.length();
				var uri:String;
				var idDO:Boolean = (obj is DisplayObject);
				
				for (i = 0; i < n; i++) {
					
					prop = properties[i];
					p = prop.@name.toString();
					uri = prop.@uri.toString();
					
					if (idDO) {
						if (_excludeDisplayObjectKeys.indexOf(p) !== -1 || _excludeDisplayObjectKeysIfFalse.indexOf(p) !== -1 || _excludeDisplayObjectKeysIfTrue.indexOf(p) !== -1) {
							continue;
						}
					}
					
					if (p == "length")
						continue;
					
					qName = new QName(uri, p);
					try {
						obj[qName];
						propertyNames[propertyNames.length] = qName;
						if (includeTypes) {
							propertyTypes[qName.toString()] = prop.@type.toString();
						}
					} catch (e:Error) {
					}
					
				}
				
			}
			
			if (obj.hasOwnProperty("rules"))
				if (obj.rules is IRules) {
					var sortmd:uint = (obj.rules as IRules).rules.sortMode;
					if(sortmd > 0)
						propertyNames.sort(sortmd);
				}
			
			if (!isDict) {
				
				for (i = 0; i < propertyNames.length - 1; i++) {
					
					if (propertyNames[i].toString() == propertyNames[i + 1].toString()) {
						propertyNames.splice(i, 1);
						i--;
					}
					
				}
				
			}
			
			if (includeMethods) {
				var methods:XMLList = classInfo..method;
				var methodNames:Array = [];
				var descmethod:Array;
				var types:XMLList;
				for each (var method:XML in methods) {
					descmethod = [method.@name, method.@returnType];
					types = method..parameter..@type;
					for each (var value:XML in types) {
						descmethod[descmethod.length] = value.valueOf();
					}
					methodNames[methodNames.length] = descmethod;
				}
				result["methods"] = methodNames;
			}
			
			result["properties"] = propertyNames;
			if (includeTypes) {
				result["types"] = propertyTypes;
			}
			
			return result;
		
		}
		
		
		/** @private */
		private static function _getCacheKey(o:Object, options:Object = null):String {
			
			var key:String = getQualifiedClassName(o);
			
			if (options != null) {
				for (var flag:String in options) {
					key += flag;
					var value:String = options[flag] as String;
					if (value != null)
						key += value;
				}
			}
			
			return key;
		
		}
		
		
		/**
		 * Convert any object to an event object (evo)
		 * @param	value
		 * @return
		 */
		public static function encode(value:Object, ident:int = 0):String {
			if (value is Stage)
				return "// Error, SiriusEncoder.getValue::value is Stage.";
			if (value is Function)
				return "// Error, SiriusEncoder.getValue::value is Function.";
			var result:String = _internalToString(value, ident, null, false);
			return (result.substr(0, 1) !== "#" ? "#" + result : result);
		}
		
		
		public static function explore(value:*, ident:int = 0):String {
			if (value is String)
				return String(value);
			BREAK = "/·br/";
			var result:String = encode(value, ident);
			BREAK = "\n";
			return "·" + result;
		}
		
		
		public static function tracer(value:*):void {
			trace(encode(value));
		}
		
	}

}
