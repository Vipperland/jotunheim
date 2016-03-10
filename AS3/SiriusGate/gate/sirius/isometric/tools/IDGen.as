package gate.sirius.isometric.tools {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class IDGen {
		
		public function IDGen() {
		
		}
		
		
		static public function get COMMON():String {
			var r:String = "";
			var n:int;
			while (r.length < 16) {
				n = Math.random() * 25 + 65;
				r += String.fromCharCode(n).toUpperCase();
			}
			return r;
		}
	
	}

}