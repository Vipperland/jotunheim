package gate.sirius.isometric.math.low {
	/**
	 * ...
	 * @author asdasd
	 */
	public class Bit04 extends Bit02 {
		
		public function Bit04() {
			
		}
		
		public function get bit03():uint {
			return test(hash, Bit.P03) ? 1 : 0;
		}
		
		public function set bit03(value:uint):void {
			BitIO.IO[value](hash, Bit.P03);
		}
		
		public function get bit04():uint {
			return test(hash, Bit.P04) ? 1 : 0;
		}
		
		public function set bit04(value:uint):void {
			BitIO.IO[value](hash, Bit.P04);
		}
		
		override public function toString():String {
			return "[Bit02::hash=" + BitIO.getString(hash, 4) + "]";
		}
		
	}

}