package gate.sirius.isometric.math {
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeFlexPoint extends BiomePoint {
		
		public function BiomeFlexPoint(x:int, y:int, z:int) {
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
		
		
		public function moveToLocation(x:int, y:int, z:int):void {
			_x = x;
			_y = y;
			_z = z;
		}
		
		
		public function moveToPoint(point:BiomePoint):void {
			_x = point._x;
			_y = point._y;
			_z = point._z;
		}
		
		
		public function clone():BiomeFlexPoint {
			return new BiomeFlexPoint(_x, _y, _z);
		}
		
		
		public function isEqual(value:BiomeFlexPoint):Boolean {
			return _x == value._x && _y == value._y && _z == value._z;
		}
		
		
		public function set x(value:int):void {
			_x = value;
		}
		
		
		public function set y(value:int):void {
			_y = value;
		}
		
		
		public function set z(value:int):void {
			_z = value;
		}
	
	}

}