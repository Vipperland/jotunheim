package gate.sirius.utils {
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class ArrayExtender {
		
		static public function enable():void {
			Array.prototype.remove = function(... values:Array):void {
				remove.apply(this, values);
			}
			Array.prototype.register = function(... values:Array):void {
				register.apply(this, values);
			}
		}
		
		public static function remove(from:Array, ... values:Array):void {
			var iof:int;
			for each (var v:*in values) {
				iof = from.indexOf(v);
				if (iof !== -1) {
					from.splice(iof, 1);
				}
			}
		}
		
		public static function register(from:Array, ... values:Array):void {
			var iof:int;
			for each (var v:*in values) {
				iof = from.indexOf(v);
				if (iof == -1) {
					from[from.length] = v;
				}
			}
		}
	
	}

}