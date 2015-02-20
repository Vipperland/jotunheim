package gate.sirius.serializer.data {
	import gate.sirius.serializer.hosts.SruObject;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruData implements IParserModule {
		
		static private const CRLF:String = "\r\n";
		
		static private const LF:String = "\r";
		
		static private const CR:String = "\n";
		
		static private const TAB:String = "	";
		
		static private const EMPTY:String = "";
		
		static private const SPACE:String = " ";
		
		static private const DOT:String = ".";
		
		static private const DOUBLE_SPACE:String = SPACE + SPACE;
		
		static private const CALL_METHOD:String = "~";
		
		static private const CALL_METHOD_START:String = "(";
		
		static private const CALL_METHOD_END:String = ")";
		
		static private const REFERENCE:String = "$";
		
		static private const REFERENCE_SPLIT:String = "<";
		
		static private const REFERENCE_FILE_NAME:String = "file";
		
		static private const QUERY:String = "@";
		
		static private const PARAMETER_SET:String = "=";
		
		static private const OBJECT_TYPE:String = ":";
		
		static private const OBJECT_PUSH:String = "#";
		
		static private const OBJECT_OPEN:String = "{";
		
		static private const OBJECT_CLOSE:String = "}";
		
		static private const OBJECT_EMPTY:String = "{}";
		
		static private const COMMENT_BLOCK_START:String = "/*";
		
		static private const COMMENT_BLOCK_END:String = "*/";
		
		static private const COMMENT_LINE:String = "//";
		
		private var paramPath:Array;
		
		private var currentPath:String;
		
		public var lineValue:String;
		
		public var lineClear:String;
		
		public var lineLength:int;
		
		public var command:String;
		
		public var lines:Array;
		
		public var totalLines:int;
		
		public var currentLine:int;
		
		public var indexBuffer:int;
		
		public var paramValueBuffer:Array;
		
		public var splitCommand:String;
		
		public var pathOpen:Boolean;
		
		public var skippedLines:String;
		
		public var fileName:String;
		
		
		private function _parseValue(value:String):* {
			value = _getLineValue(value);
			switch (value) {
				case "true":  {
					return true;
				}
				case "false":  {
					return false;
				}
				default:  {
					if (value.length < 22) {
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
		
		
		private function _pathLine():String {
			var s:String = currentLine.toString();
			while (s.length < 8) {
				s = "0" + s;
			}
			return s;
		}
		
		
		public function SruData() {
			reset();
		}
		
		
		public function push(value:String):void {
			value = value.split(CRLF).join(CR);
			value = value.split(LF).join(CR);
			lines = lines.concat(value.split(CR));
			totalLines = lines.length;
		}
		
		
		public function isEmptyLine():Boolean {
			return lineClear.length == 0 || lineClear.substr(0, 2) == COMMENT_LINE;
		}
		
		
		public function nextLine():Boolean {
			lineValue = lines[currentLine];
			++currentLine;
			if (lineValue !== null) {
				lineValue = _getLineValue(lineValue);
				lineClear = _getClearLine(lineValue);
				lineLength = lineClear.length;
				command = lineClear.substr(0, 1);
				return isEmptyLine() ? nextLine() : true;
			}
			reset();
			return false;
		}
		
		
		private function _getLineValue(value:String):String {
			lineLength = value.length;
			while (value.substring(0, 1) == TAB) {
				value = value.substring(1, lineLength);
				--lineLength;
			}
			while (value.substring(lineLength - 1, lineLength) == TAB) {
				--lineLength;
				value = value.substring(0, lineLength);
			}
			while (value.substring(0, 1) == SPACE) {
				value = value.substring(1, lineLength);
				--lineLength;
			}
			while (value.substring(lineLength - 1, lineLength) == SPACE) {
				--lineLength;
				value = value.substring(0, lineLength);
			}
			return value;
		}
		
		
		public function reset():void {
			lines = [];
			skippedLines = "";
			currentLine = 0;
			lineLength = 0;
			lineValue = null;
			lineClear = null;
			command = null;
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
		
		
		// )
		public function isMethodEnd():Boolean {
			return lineClear.indexOf(")") == lineLength - 1;
		}
		
		
		// @
		public function isQuery():Boolean {
			return command == QUERY;
		}
		
		
		// 
		public function isBufferEmpty():Boolean {
			return lines.length == 0;
		}
		
		
		// $
		public function isReference():Boolean {
			if (command == REFERENCE) {
				_parseReference();
				return true;
			} else {
				return false;
			}
		}
		
		
		private function _parseReference():void {
			paramValueBuffer = lineClear.substr(1, lineLength - 1).split(REFERENCE_SPLIT);
			switch (getParamName().toLowerCase()) {
				case REFERENCE_FILE_NAME:  {
					fileName = getParamValue();
					break;
				}
			}
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
		
		
		// myObject [{]
		public function isObjectOpen():Boolean {
			indexBuffer = lineClear.lastIndexOf(OBJECT_OPEN);
			return indexBuffer == lineLength - 1;
		}
		
		
		// ~callFooBar([arg1,arg2,...,argN])
		public function hasInlineArguments():Boolean {
			indexBuffer = lineClear.lastIndexOf(CALL_METHOD_END, lineLength - 1);
			return indexBuffer !== -1 && (indexBuffer - lineClear.indexOf(CALL_METHOD_START)) > 1;
		}
		
		
		// ~callFooBar([arg1,arg2,...,argN])
		public function getInlineMethodArgs():Array {
			indexBuffer = lineValue.indexOf(CALL_METHOD_START);
			paramValueBuffer = lineValue.substring(indexBuffer + 1, lineValue.length - 1).split(",");
			for (var p:String in paramValueBuffer)
				paramValueBuffer[p] = _getLineValue(paramValueBuffer[p]);
			return paramValueBuffer;
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
		
		
		public function getObjectName():String {
			return lineClear.substring(0, indexBuffer);
		}
		
		
		// ~[callFooBar]
		public function getMethodName():String {
			indexBuffer = lineClear.indexOf(CALL_METHOD_START);
			return lineClear.substring(1, indexBuffer);
		}
		
		
		// @[myQueryName] prop1 prop2 ... propN
		public function getQueryName():String {
			lineValue = lineValue.substr(1, lineValue.length - 1);
			lineValue = lineValue.split(TAB).join(SPACE);
			while (lineValue.indexOf(DOUBLE_SPACE) !== -1) {
				lineValue = lineValue.split(DOUBLE_SPACE).join(SPACE);
			}
			paramValueBuffer = lineValue.split(SPACE);
			return paramValueBuffer.shift();
		}
		
		
		// @myQueryName [prop1 prop2 ... propN]
		public function getQueryArguments():Array {
			return paramValueBuffer;
		}
		
		
		public function skipLine():void {
			skippedLines += _pathLine() + "	" + lineValue + "\n";
		}
		
		
		public function releaseLog():void {
			skippedLines = "";
		}
		
		
		public function hasCommentStart():Boolean {
			return lineClear.lastIndexOf(COMMENT_BLOCK_START) !== -1;
		}
		
		
		public function hasCommentEnd():Boolean {
			return lineClear.lastIndexOf(COMMENT_BLOCK_END) == lineClear.length - 2;
		}
		
		
		public function writeProperty(target:Object):void {
			paramPath = getParamName().split(".");
			if (paramPath.length > 1) {
				paramValueBuffer[0] = paramPath.pop();
				for each (currentPath in paramPath)
					target = target[currentPath];
			}
			target[getParamName()] = getParamValue();
		}
	
	
	}

}