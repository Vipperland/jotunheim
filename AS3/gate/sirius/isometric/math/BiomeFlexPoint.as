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
			_x = point.x;
			_y = point.y;
			_z = point.z;
		}
		
		
		public function clone():BiomeFlexPoint {
			return new BiomeFlexPoint(_x, _y, _z);
		}
		
		
		public function cloneStatic():BiomePoint {
			return BiomePoint.create(_x, _y, _z);
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
		
		
		public function join(location:BiomePoint):void {
			_x += location.x;
			_y += location.y;
			_z += location.z;
		}
		
		
		public function unjoin(location:BiomePoint):void {
			_x -= location.x;
			_y -= location.y;
			_z -= location.z;
		}
		
		
		override public function getLeftPoint():BiomePoint {
			return BiomePoint.create(getLeft(), _y, _z);
		}
		
		
		override public function getRightPoint():BiomePoint {
			return BiomePoint.create(getRight(), _y, _z);
		}
		
		
		override public function getTopPoint():BiomePoint {
			return BiomePoint.create(_x, getTop(), _z);
		}
		
		
		override public function getBottomPoint():BiomePoint {
			return BiomePoint.create(_x, getBottom(), _z);
		}
		
		
		override public function getFrontPoint():BiomePoint {
			return BiomePoint.create(_x, _y, getFront());
		}
		
		
		override public function getBackPoint():BiomePoint {
			return BiomePoint.create(_x, _y, getBack());
		}
	
	}

}