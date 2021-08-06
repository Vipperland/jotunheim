package gate.sirius.isometric.math.low {
	/**
	 * ...
	 * @author asdasd
	 */
	public class Bit02 extends Bit {
		
		public function Bit02() {
			super();
		}
		
		public function get bit01():uint {
			return test(Bit.P01) ? 1 : 0;
		}
		
		public function set bit01(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P01);
		}
		
		public function get bit02():uint {
			return test(Bit.P02) ? 1 : 0;
		}
		
		public function set bit02(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P02);
		}
		
		public function toString():String {
			return "[Bit02::hash=" + BitIO.getString(hash, 2) + "]";
		}
		
	}

}