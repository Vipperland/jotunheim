package gate.sirius.isometric.math {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeAreaPoint extends BiomePoint {
		
		public function BiomeAreaPoint(x:int, y:int, z:int) {
			super(x, y, z);
		}
		
		public function moveLeft():void {
			--_x;
		}
		
		public function moveRight():void {
			++_x;
		}
		
		public function moveUp():void {
			--_y;
		}
		
		public function moveDown():void {
			++_y;
		}
		
		public function moveFront():void {
			--_z;
		}
		
		public function moveBack():void {
			++_z;
		}
		
		public function moveTo(x:int, y:int, z:int):void {
			_x = x;
			_y = y;
			_z = z;
		}
		
		public function clone():BiomeAreaPoint {
			return new BiomeAreaPoint(_x, _y, _z);
		}
	
	}

}