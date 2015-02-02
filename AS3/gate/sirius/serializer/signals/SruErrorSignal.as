package gate.sirius.serializer.signals {
	
	import gate.sirius.serializer.SruDecoder;
	import gate.sirius.signals.Signal;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruErrorSignal extends Signal {
		
		private var _message:String;
		
		private var _line:uint;
		
		/**
		 * 1=default 2=properties 3=query 4=methods
		 */
		private var _code:String;
		
		private var _stack:String;
		
		private var _id:String;
		
		
		public function SruErrorSignal() {
			super(_construct);
		}
		
		
		private function _construct(message:String, line:uint, code:String, id:String, stack:String = "", file:String = ""):void {
			//message, line, code, id, object, param, value
			_id = id;
			_code = code;
			_line = line;
			_message = "[`Sirius#" + id + " at " + (file || "") + "#" + _line + ":(" + code + ")]\n	" + message;
			_stack = stack;
		}
		
		
		private function get decoder():SruDecoder {
			return dispatcher.author as SruDecoder;
		}
		
		
		public function get message():String {
			return _message;
		}
		
		
		public function get line():uint {
			return _line;
		}
		
		
		public function get code():String {
			return _code;
		}
		
		
		public function get id():String {
			return _id;
		}
		
		
		public function get stack():String {
			return _stack;
		}
	
	}

}