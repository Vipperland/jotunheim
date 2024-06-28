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
			Array.prototype.random = function(ammount:int, remove:Boolean, fill:Array = null):void {
				random.call(this, ammount, remove, fill);
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
		
		public static function random(from:Array, ammount:int, fill:Array):Array {
			if(fill == null){
				fill = [];
			}
			if(ammount > from.length){
				ammount = from.length;
			}
			while(ammount-- > 0){
				fill.push(from.splice((Math.random() * from.length) >> 0)[0]);
			}
			return fill;
		}
	
	}

}