package gate.sirius.meta.core {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SiriusDecoderError {
		
		public static const FUNCTION_NOT_FOUND:String = "FUNCTION_NOT_FOUND";
		
		public static const CLASS_NOT_FOUND:String = "CLASS_NOT_FOUND";
		
		public static const MISSING_PROPERTY:String = "MISSING_PROPERTY";
		
		public static const PARSER_ERROR:String = "UNKNOW_PARSER_ERROR";
		
		public static const SINTAX_ERROR:String = "SINTAX_ERROR";
		
		public static const ENVIRONMENT_ERROR:String = "UNDEFINED_ENVIRONMENT_VARIABLE";
		
		public static const REFERENCE_ERROR:String = "APPLICATION_REFERENCE_ERROR";
		
		public static const LOAD_ERROR:String = "FILE_LOAD_ERROR";
		
		protected var _type:String;
		
		protected var _message:String;
		
		protected var _line:int;
		
		protected var _file:String;
		
		protected var _text:String;
		
		
		public function SiriusDecoderError(type:String, message:String, line:int, file:String) {
			
			_file = file || "$ROOT";
			
			if (_file !== "$ROOT")
				--line;
			
			_type = type;
			
			_line = line;
			
			_text = message;
			
			_message = "(" + _file + "#" + _line + ") " + _text;
		
		}
		
		
		public function get type():String {
			return _type;
		}
		
		
		public function get message():String {
			return _message;
		}
		
		
		public function get line():int {
			return _line;
		}
		
		
		public function get file():String {
			return _file;
		}
		
		
		public function get text():String {
			return _text;
		}
		
		
		public function toString():String {
			return "[SiriusDecoderError message=" + _message + "]";
		}
	
	}

}