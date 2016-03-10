package gate.sirius.serializer {
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruQuery {
		
		private var _queryBuffer:String;
		
		private var _decoder:SruDecoder;
		
		private var _onComplete:Function;
		
		private var _target:*;
		
		
		public function SruQuery(target:*, onComplete:Function, defaultObjects:Boolean) {
			clearBuffer();
			_target = target;
			_onComplete = onComplete;
			_decoder = new SruDecoder(defaultObjects);
		}
		
		
		private function clearBuffer():void {
			_queryBuffer = "";
		}
		
		
		public function push(... args:Array):SruQuery {
			for each (var q:*in args) {
				if (!(q is Array)) {
					q = [q];
				}
				pushSingle.apply(null, q);
			}
			return this;
		}
		
		
		public function pushSingle(name:String, ... args:Array):SruQuery {
			_queryBuffer += "@" + arguments.join(" ") + "\n";
			return this;
		}
		
		
		public function run(... args:Array):SruQuery {
			var secbuffer:String = "";
			for each (var q:*in args) {
				if (!(q is Array)) {
					q = [q];
				}
				secbuffer += "@" + q.join(" ") + "\n";
			}
			_decoder.parse(secbuffer, _target, _onComplete);
			return this;
		}
		
		
		public function runSingle(name:String, ... args:Array):SruQuery {
			_decoder.parse("@" + args.join(" ") + "\n", _target, _onComplete);
			return this;
		}
		
		
		public function execute():SruDecoder {
			var data:String = _queryBuffer;
			clearBuffer();
			return _decoder.parse(data, _target, _onComplete);
		}
		
		
		public function get decoder():SruDecoder {
			return _decoder;
		}
		
		
		public function get queryBuffer():String {
			return _queryBuffer;
		}
	
	}

}