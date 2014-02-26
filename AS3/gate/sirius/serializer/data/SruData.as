package gate.sirius.serializer.data {
	import gate.sirius.serializer.hosts.SruObject;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruData implements IParserModule {
		
		static private const SPACE:String = " ";
		static private const CRLF:String = "\r\n";
		static private const LF:String = "-l";
		static private const CR:String = "\n";
		static private const TAB:String = "	";
		static private const EMPTY:String = "";
		
		static private const CALL_METHOD:String = "~";
		static private const CALL_METHOD_FREE:String = "()";
		static private const CALL_METHOD_START:String = "(";
		static private const CALL_METHOD_END:String = ")";
		
		static private const QUERY:String = "@";
		static private const PARAMETER_SET:String = "=";
		static private const OBJECT_TYPE:String = ":";
		
		static private const OBJECT_PUSH:String = "#";
		static private const OBJECT_OPEN:String = "{";
		static private const OBJECT_CLOSE:String = "}";
		static private const OBJECT_EMPTY:String = "{}";
		
		public var lineValue:String;
		public var lineClear:String;
		public var lineLength:int;
		public var command:String;
		public var comment:String;
		public var lines:Array;
		public var totalLines:int;
		public var currentLine:int;
		public var indexBuffer:int;
		public var paramValueBuffer:Array;
		public var splitCommand:String;
		public var pathOpen:Boolean;
		
		private function _parseValue(value:String):* {
			switch (value) {
				case "true":  {
					return true;
				}
				case "false":  {
					return false;
				}
				default:  {
					if (value.length < 19) {
						if (!isNaN(Number(value))) {
							return Number(value);
						}
					}
				}
			}
			return value;
		}
		
		private function _extractObjectProps():void {
			indexBuffer = lineValue.indexOf(OBJECT_EMPTY); // remove {}
			pathOpen = false;
			if (indexBuffer == lineLength - 2) {
				lineClear = lineClear.substring(0, lineLength - 2);
			} else {
				indexBuffer = lineClear.indexOf(OBJECT_OPEN);
				if (indexBuffer == lineLength - 1) {
					lineClear = lineClear.substring(0, lineLength - 1);
					pathOpen = true;
				}
			}
			paramValueBuffer = lineClear.split(splitCommand);
		}
		
		private function _getClearLine(value:String):String {
			value = value.split(TAB).join(EMPTY);
			value = value.split(SPACE).join(EMPTY);
			return value;
		}
		
		public function SruData() {
			lines = [];
			paramValueBuffer = [];
			currentLine = 0;
		}
		
		public function push(value:String):void {
			value = value.split(CRLF).join(CR);
			value = value.split(LF).join(CR);
			lines = lines.concat(value.split(CR));
			totalLines = lines.length;
		}
		
		public function isEmptyLine():Boolean {
			return lineValue.length == 0;
		}
		
		public function nextLine():Boolean {
			lineValue = lines[currentLine];
			++currentLine;
			if (lineValue !== null) {
				lineValue = _getLineValue(lineValue);
				lineClear = _getClearLine(lineValue);
				lineLength = lineClear.length;
				command = lineClear.substr(0, 1);
				comment = lineClear.substr(0, 2);
				return isEmptyLine() ? nextLine() : true;
			}
			reset();
			return false;
		}
		
		private function _getLineValue(value:String):String {
			while (value.substr(0, 1) == TAB) {
				value = value.substr(1, value.length - 1);
			}
			while (value.substr(value.length - 1, 1) == TAB) {
				value = value.substr(0, value.length - 1);
			}
			while (value.substr(0, 1) == SPACE) {
				value = value.substr(1, value.length - 1);
			}
			while (value.substr(value.length - 1, 1) == SPACE) {
				value = value.substr(0, value.length - 1);
			}
			return value;
		}
		
		public function reset():void {
			lines = [];
			currentLine = 0;
			lineValue = null;
			lineClear = null;
			command = null;
			comment = null;
		}
		
		public function hasBuffer():Boolean {
			return nextLine();
		}
		
		// }
		public function isObjectClose():Boolean {
			return lineClear == OBJECT_CLOSE;
		}
		
		// ~
		public function isMethod():Boolean {
			return command == CALL_METHOD;
		}
		
		// @
		public function isQuery():Boolean {
			return command == QUERY;
		}
		
		// 
		public function isBufferEmpty():Boolean {
			return lines.length == 0;
		}
		
		// =
		public function isValueSet():Boolean {
			indexBuffer = lineClear.indexOf(PARAMETER_SET);
			if (indexBuffer !== -1) {
				paramValueBuffer = [lineClear.substring(0, indexBuffer), lineValue.split(PARAMETER_SET)[1]];
				return true;
			} else {
				return false;
			}
		}
		
		// ~[callFooBar]
		public function getMethodName():String {
			return lineClear.substring(1, indexBuffer);
		}
		
		// ~callFooBar[()]
		public function isFreeExecution():Boolean {
			indexBuffer = lineClear.lastIndexOf("()", lineLength);
			return (indexBuffer - lineLength) == -2;
		}
		
		// [#]myObject | myObject [:] ObjectType
		public function isObjectKey():Boolean {
			if (command == OBJECT_PUSH) {
				splitCommand = OBJECT_PUSH;
				return true;
			} else {
				splitCommand = OBJECT_TYPE;
				return lineClear.indexOf(OBJECT_TYPE) !== -1;
			}
		
		}
		
		// [#]ObjectType
		public function isObjectPush():Boolean {
			_extractObjectProps();
			return splitCommand == OBJECT_PUSH;
		}
		
		// #|myObject:ObjectType [{]
		public function isObjectOpen():Boolean {
			indexBuffer = lineValue.indexOf(OBJECT_OPEN);
			return indexBuffer == lineLength - 1;
		}
		
		// ~callFooBar[(]
		public function hasParamBuffer():Boolean {
			indexBuffer = lineClear.lastIndexOf("()", lineLength);
			return (indexBuffer - lineLength) == -1;
		}
		
		// [myObject] : ObjectType
		public function getParamName():String {
			return paramValueBuffer[0];
		}
		
		// myObject : [ObjectType] | #[ObjectType]
		public function getObjectType():String {
			return paramValueBuffer[1];
		}
		
		// [someValue] | myVar = [someValue]
		public function getParamValue():* {
			return _parseValue(paramValueBuffer[1]);
		}
		
		// [Hello World!(string)] | [true|false(boolean)] | [0xFF|3.14|360(number)]
		public function getLineValue():* {
			return _parseValue(lineValue);
		}
		
		// @[myQueryName] prop1 prop2 ... propN
		public function getQueryName():String {
			paramValueBuffer = lineValue.split(SPACE);
			return paramValueBuffer.shift();
		}
		
		// @myQueryName [prop1 prop2 ... propN]
		public function getQueryArguments():Array {
			return paramValueBuffer;
		}
	
	}

}