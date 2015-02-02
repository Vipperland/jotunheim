package gate.sirius.isometric.math.low {
	/**
	 * ...
	 * @author asdasd
	 */
	public class Bit32 extends Bit16 {
		
		public function Bit32() {
		}
		
		public function get bit17():uint {
			return test(hash, Bit.P17) ? 1 : 0;
		}
		
		public function set bit17(value:uint):void {
			BitIO.IO[value](hash, Bit.P17);
		}
		
		public function get bit18():uint {
			return test(hash, Bit.P18) ? 1 : 0;
		}
		
		public function set bit18(value:uint):void {
			BitIO.IO[value](hash, Bit.P18);
		}
		
		public function get bit19():uint {
			return test(hash, Bit.P19) ? 1 : 0;
		}
		
		public function set bit19(value:uint):void {
			BitIO.IO[value](hash, Bit.P19);
		}
		
		public function get bit20():uint {
			return test(hash, Bit.P20) ? 1 : 0;
		}
		
		public function set bit20(value:uint):void {
			BitIO.IO[value](hash, Bit.P20);
		}
		
		public function get bit21():uint {
			return test(hash, Bit.P21) ? 1 : 0;
		}
		
		public function set bit21(value:uint):void {
			BitIO.IO[value](hash, Bit.P21);
		}
		
		public function get bit22():uint {
			return test(hash, Bit.P22) ? 1 : 0;
		}
		
		public function set bit22(value:uint):void {
			BitIO.IO[value](hash, Bit.P22);
		}
		
		public function get bit23():uint {
			return test(hash, Bit.P23) ? 1 : 0;
		}
		
		public function set bit23(value:uint):void {
			BitIO.IO[value](hash, Bit.P23);
		}
		
		public function get bit24():uint {
			return test(hash, Bit.P24) ? 1 : 0;
		}
		
		public function set bit24(value:uint):void {
			BitIO.IO[value](hash, Bit.P24);
		}
		
		public function get bit25():uint {
			return test(hash, Bit.P25) ? 1 : 0;
		}
		
		public function set bit25(value:uint):void {
			BitIO.IO[value](hash, Bit.P25);
		}
		
		public function get bit26():uint {
			return test(hash, Bit.P26) ? 1 : 0;
		}
		
		public function set bit26(value:uint):void {
			BitIO.IO[value](hash, Bit.P26);
		}
		
		public function get bit27():uint {
			return test(hash, Bit.P27) ? 1 : 0;
		}
		
		public function set bit27(value:uint):void {
			BitIO.IO[value](hash, Bit.P27);
		}
		
		public function get bit28():uint {
			return test(hash, Bit.P28) ? 1 : 0;
		}
		
		public function set bit28(value:uint):void {
			BitIO.IO[value](hash, Bit.P28);
		}
		
		public function get bit29():uint {
			return test(hash, Bit.P29) ? 1 : 0;
		}
		
		public function set bit29(value:uint):void {
			BitIO.IO[value](hash, Bit.P29);
		}
		
		public function get bit30():uint {
			return test(hash, Bit.P30) ? 1 : 0;
		}
		
		public function set bit30(value:uint):void {
			BitIO.IO[value](hash, Bit.P30);
		}
		
		public function get bit31():uint {
			return test(hash, Bit.P31) ? 1 : 0;
		}
		
		public function set bit31(value:uint):void {
			BitIO.IO[value](hash, Bit.P31);
		}
		
		public function get bit32():uint {
			return test(hash, Bit.P32) ? 1 : 0;
		}
		
		public function set bit32(value:uint):void {
			BitIO.IO[value](hash, Bit.P32);
		}
		
		override public function toString():String {
			return "[Bit02::hash=" + BitIO.getString(hash, 32) + "]";
		}
		
	}

}