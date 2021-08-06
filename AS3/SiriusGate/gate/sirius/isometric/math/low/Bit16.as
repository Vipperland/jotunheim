package gate.sirius.isometric.math.low {
	/**
	 * ...
	 * @author asdasd
	 */
	public class Bit16 extends Bit08 {
		
		public function Bit16() {
			
		}
		
		public function get bit09():uint {
			return test(hash, Bit.P09) ? 1 : 0;
		}
		
		public function set bit09(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P09);
		}
		
		public function get bit10():uint {
			return test(hash, Bit.P10) ? 1 : 0;
		}
		
		public function set bit10(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P10);
		}
		
		public function get bit11():uint {
			return test(hash, Bit.P11) ? 1 : 0;
		}
		
		public function set bit11(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P11);
		}
		
		public function get bit12():uint {
			return test(hash, Bit.P12) ? 1 : 0;
		}
		
		public function set bit12(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P12);
		}
		
		public function get bit13():uint {
			return test(hash, Bit.P13) ? 1 : 0;
		}
		
		public function set bit13(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P13);
		}
		
		public function get bit14():uint {
			return test(hash, Bit.P14) ? 1 : 0;
		}
		
		public function set bit14(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P14);
		}
		
		public function get bit15():uint {
			return test(hash, Bit.P15) ? 1 : 0;
		}
		
		public function set bit15(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P15);
		}
		
		public function get bit16():uint {
			return test(hash, Bit.P16) ? 1 : 0;
		}
		
		public function set bit16(value:uint):void {
			hash = BitIO.IO[value](hash, Bit.P16);
		}
		
		override public function toString():String {
			return "[Bit16::hash=" + BitIO.getString(hash, 16) + "]";
		}
		
	}

}