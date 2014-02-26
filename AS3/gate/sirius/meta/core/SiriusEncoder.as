package gate.sirius.meta.core {
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import flash.xml.XMLNode;
	
	import mx.utils.DescribeTypeCache;
	
	public class SiriusEncoder {
		
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
			value = value.split("\r\n").join("$$__BREAK__$$");
			value = value.split("\n").join("$$__BREAK__$$");
			value = value.split("\r").join("$$__BREAK__$$");
			value = value.split("$$__BREAK__$$$$__BREAK__$$").join("$$__BREAK__$$");
			value = value.split("$$__BREAK__$$").join(_newline("", ident + 1) + ".");
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
						
						var isSO:Boolean = value is SiriusObject;
						var respectIndex:Boolean = isSO && value.isIndexed();
						var isArray:Boolean = value is Array || (isSO && !respectIndex);
						var isDict:Boolean = value is Dictionary;
						var isDisplayObject:Boolean = value is DisplayObject;
						var isSiriusLink:Boolean = value is SiriusLink || value is ISiriusLink;
						var prop:*;
						var isN:Boolean;
						var valuesArray:Array = new Array("");
						var valueString:String;
						
						++ident;
						
						if (value)
							refs[value] = "";
						
						var hasFilter:Boolean = value.hasOwnProperty("siriusRules") && value.siriusRules;
						
						if (hasFilter)
							if (value.siriusRules.hasInjections())
								valuesArray[valuesArray.length] = (value.siriusRules as SiriusEncoderRules).getInjections(ident);
						
						for (var j:int = 0; j < properties.length; j++) {
							
							valueString = "";
							
							prop = properties[j];
							
							if (value[prop] is SiriusEncoderRules || prop == "siriusRules" || value[prop] is Function)
								continue;
							
							if (filters) {
								if (filters.hasOwnProperty(name)) {
									if (!filters[name][prop])
										continue;
								}
							} else if (hasFilter) {
								if (!value.siriusRules.verify(prop))
									continue;
							}
							
							if (isDisplayObject) {
								if (excludeDisplayObjects) {
									continue;
								} else if (_excludeDisplayObjectKeys.indexOf(String(prop)) !== -1)
									continue;
								else if (_excludeDisplayObjectKeysIfFalse.indexOf(String(prop)) !== -1) {
									if (!value[prop])
										continue;
								} else if (_excludeDisplayObjectKeysIfTrue.indexOf(String(prop)) !== -1) {
									if (int(value[prop]))
										continue;
								}
							}
							
							isN = isArray ? isNaN(prop) : true;
							//isN = isNaN(prop);
							
							if (isN && !isDict)
								valueString += prop.toString();
							
							if (value[prop] is ISiriusLink) {
								valueString += BREAK + value[prop].dumpCommands(ident);
							} else {
								
								if (!isDict) {
									if (typeof value[prop] == "object" && value[prop] !== null && isN)
										valueString += " : ";
									else if (isN)
										valueString += " = ";
								}
								
								try {
									valueString += _internalToString(value[prop], ident, refs, !isN || isDict, filters);
								} catch (e:Error) {
									valueString += "null// Parse error, unknow value type";
								}
								
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
					
					return "//function call";
				
				default:
					
					return type;
			
			}
			
			return "(unknown value type)";
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
			
			var classInfo:XML = DescribeTypeCache.describeType(obj).typeDescription;
			
			className = classInfo.@name.toString();
			
			properties = classInfo..accessor.(hasOwnProperty("@access")) + classInfo..variable;
			
			var numericIndex:Boolean = false;
			
			result = {};
			result["name"] = className;
			result["dynamic"] = classInfo.@isDynamic.toString();
			
			var isArray:Boolean = (className.indexOf("__AS3__.vec") !== -1 || obj is Array);
			var isDict:Boolean = (className == "flash.utils::Dictionary");
			var isSObj:Boolean = obj is SiriusObject;
			
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
					propertyNames.push(key);
			} else {
				for (var p:String in obj) {
					if (isArray) {
						var pi:Number = parseInt(p);
						if (isNaN(pi))
							propertyNames.push(new QName("", p));
						else
							propertyNames.push(pi);
						continue;
					}
					propertyNames.push(new QName("", p));
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
				
			} else if (className == "XML") {
				n = properties.length();
				for (i = 0; i < n; i++) {
					p = properties[i].name();
					propertyNames.push(new QName("", "@" + p));
				}
			} else {
				
				n = properties.length();
				var uri:String;
				
				for (i = 0; i < n; i++) {
					
					prop = properties[i];
					p = prop.@name.toString();
					uri = prop.@uri.toString();
					
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
			
			var sort:Boolean = true;
			
			if (obj.hasOwnProperty("siriusRules"))
				if (obj.siriusRules is SiriusEncoderRules)
					sort = !obj.siriusRules.noSort;
			
			if (sort)
				propertyNames.sort(Array.CASEINSENSITIVE | (numericIndex ? Array.NUMERIC : 0));
			
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
		public static function getValue(value:Object, filters:Object = null, ident:int = 0):String {
			if (value is Stage)
				return "// Error, SiriusEncoder.getValue::value is Stage.";
			if (value is Function)
				return "// Error, SiriusEncoder.getValue::value is Function.";
			var result:String = _internalToString(value, ident, null, false, filters);
			return (result.substr(0, 1) !== "#" ? "#" + result : result);
		}
		
		
		public static function explore(value:*, filters:Object = null, ident:int = 0):String {
			if (value is String)
				return String(value);
			BREAK = "/·br/";
			var result:String = getValue(value, filters, ident);
			BREAK = "\n";
			return "·" + result;
		}
		
		
		public static function traceObject(value:*):void {
			trace(getValue(value));
		}
	
	}

}
