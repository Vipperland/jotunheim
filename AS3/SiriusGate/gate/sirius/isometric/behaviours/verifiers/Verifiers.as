package gate.sirius.isometric.behaviours.verifiers {
	import flash.utils.Dictionary;
	import gate.sirius.isometric.behaviours.report.Report;
	import gate.sirius.serializer.hosts.IList;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public dynamic class Verifiers implements IList {
		
		private var _length:uint = 0;
		
		private var _canceled:Boolean;
		
		
		public function Verifiers() {
		
		}
		
		
		public function stopPropagation():void {
			_canceled = true;
		}
		
		
		public function check(report:Report):Boolean {
			var errors:uint = 0;
			var result:Boolean;
			for each (var verifier:BasicVerifier in this) {
				if (verifier) {
					result = report.registerVerifierEntry(verifier);
					if (!result) {
						++errors;
					}
					verifier.resolve(report, result);
					if (_canceled) {
						_canceled = false;
						break;
					}
				}
			}
			return errors == 0;
		}
		
		
		/* INTERFACE gate.sirius.serializer.hosts.IList */
		
		public function get length():uint {
			return _length;
		}
		
		
		public function push(value:*):uint {
			var verifier:BasicVerifier = value as BasicVerifier;
			if (verifier) {
				this[_length] = verifier.id;
				++_length;
			}
			return _length;
		}
		
		
		public function remove(value:*):* {
			var i:uint = 0;
			var organize:int = 0;
			var found:Boolean;
			
			for (i = 0; i < _length; ++i) {
				if (organize) {
					this[i - organize] = this[i];
					continue;
				}
				if (value == this[i]) {
					++organize;
					found = true;
					delete this[i];
				}
			}
			
			if (found) {
				--_length;
			}
			
			return value;
		}
		
		
		public function toString():String {
			var s:String = "	Verifiers:\n";
			var i:uint = 0;
			for (i = 0; i < _length; ++i) {
				var v:BasicVerifier = this[i] as BasicVerifier;
				if (v) {
					s += "	" + v.toString() + "\n";
				}
			}
			return s;
		}
	
	}

}