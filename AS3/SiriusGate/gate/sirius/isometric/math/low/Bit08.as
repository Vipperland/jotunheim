package gate.sirius.isometric.math.low {
	/**
	 * ...
	 * @author asdasd
	 */
	public class Bit08 extends Bit04 {
		
		public function Bit08() {
			
		}
		
		public function get bit05():uint {
			return test(hash, Bit.P05) ? 1 : 0;
		}
		
		public function set bit05(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P05);
		}
		
		public function get bit06():uint {
			return test(hash, Bit.P06) ? 1 : 0;
		}
		
		public function set bit06(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P06);
		}
		
		public function get bit07():uint {
			return test(hash, Bit.P07) ? 1 : 0;
		}
		
		public function set bit07(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P07);
		}
		
		public function get bit08():uint {
			return test(hash, Bit.P08) ? 1 : 0;
		}
		
		public function set bit08(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P08);
		}
		
		override public function toString():String {
			return "[Bit08::hash=" + BitIO.getString(hash, 8) + "]";
		}
		
	}

}