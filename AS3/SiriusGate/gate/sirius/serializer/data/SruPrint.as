package gate.sirius.serializer.data {
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class SruPrint {
		
		public static const GATE:SruPrint = new SruPrint();
		
		public function SruPrint() {
			
		}
		
		public function toString(object:*, prefix:String):String {
			
			var data:XML = new describeType(object);
			
		}
		
	}

}