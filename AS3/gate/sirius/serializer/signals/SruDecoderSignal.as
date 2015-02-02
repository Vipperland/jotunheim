package gate.sirius.serializer.signals {
	import gate.sirius.serializer.SruDecoder;
	import gate.sirius.signals.Signal;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruDecoderSignal extends Signal {
		
		private var _canceled:Boolean;
		
		public function SruDecoderSignal() {
			super(_constructor);
		}
		
		private function _constructor(canceled:Boolean = false):void {
			_canceled = canceled;
		
		}
		
		public function get decoder():SruDecoder {
			return dispatcher.author as SruDecoder;
		}
		
		public function get canceled():Boolean {
			return _canceled;
		}
		
		public function extractOne(type:Class):* {
			for each (var t:*in decoder.content) {
				if (t is type) {
					break;
				}
			}
			return t;
		}
		
		public function extractAll(type:Class):Vector.<Object> {
			var result:Vector.<Object> = new Vector.<Object>();
			var len:int = 0;
			for each (var t:*in decoder.content) {
				if (t is type) {
					result[len] = t;
					++len;
				}
			}
			return result;
		}
	
	}

}