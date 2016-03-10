package gate.sirius.isometric.math.low {
	/**
	 * ...
	 * @author asdasd
	 */
	public class Bit02 {
		
		public var hash:uint = 0;
		
		public function Bit02() {
			
		}
		
		public function get bit01():uint {
			return test(hash, Bit.P01) ? 1 : 0;
		}
		
		public function set bit01(value:uint):void {
			BitIO.IO[value](hash, Bit.P01);
		}
		
		public function get bit02():uint {
			return test(hash, Bit.P02) ? 1 : 0;
		}
		
		public function set bit02(value:uint):void {
			BitIO.IO[value](hash, Bit.P02);
		}
		
		public function toString():String {
			return "[Bit02::hash=" + BitIO.getString(hash, 2) + "]";
		}
		
	}

}