package gate.sirius.isometric.math {
	import flash.display.DisplayObject;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class MatterOffset {
		
		private var _location:BiomeFlexPoint;
		
		private var _x:Number;
		
		private var _y:Number;
		
		private var _z:Number;
		
		
		public function MatterOffset(location:BiomeFlexPoint) {
			_location = location;
			reset();
		}
		
		
		public function moveX(ammount:Number, lock:Boolean = false):void {
			_x += ammount;
			if (lock) {
				if (ammount < 0) {
					if (_x < 0) _x = 0;
				}else {
					if (_x > 0) _x = 0;
				}
			}else {
				if (ammount > 0) {
					while (_x >= 1) {
						++_location.x;
						_x -= 1;
					}
				} else if (ammount < 0) {
					while (_x < 0) {
						--_location.x;
						_x += 1;
					}
				}
			}
		}
		
		
		public function moveY(ammount:Number, lock:Boolean = false):void {
			_y += ammount;
			if (lock) {
				if (ammount < 0) {
					if (_y < 0) _y = 0;
				}else {
					if (_y > 0) _y = 0;
				}
			}else {
				if (ammount > 0) {
					while (_y >= 1) {
						++_location.y;
						_y -= 1;
					}
				} else if (ammount < 0) {
					while (_y < 0) {
						--_location.y;
						_y += 1;
					}
				}
			}
		}
		
		
		public function moveZ(ammount:Number, lock:Boolean = false):void {
			_z += ammount;
			if (lock) {
				if (ammount < 0) {
					if (_z < 0) _z = 0;
				}else {
					if (_z > 0) _z = 0;
				}
			}else {
				if (ammount > 0) {
					while (_z >= 1) {
						++_location.z;
						_z -= 1;
					}
				} else if (ammount < 0) {
					while (_y < 0) {
						--_location.z;
						_z += 1;
					}
				}
			}
		}
		
		
		public function move(x:Number, y:Number, z:Number):void {
			moveX(x);
			moveY(y);
			moveZ(z);
		}
		
		
		public function write(x:Number, y:Number, z:Number):void {
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		
		public function reset():void {
			_x = 0;
			_y = 0;
			_z = 0;
		}
		
		
		public function get location():BiomeFlexPoint {
			return _location;
		}
		
		
		public function get x():Number {
			return _x;
		}
		
		
		public function set x(value:Number):void {
			_x = isNaN(value) ? 0 : value;
		}
		
		
		public function get y():Number {
			return _y;
		}
		
		
		public function set y(value:Number):void {
			_y = isNaN(value) ? 0 : value;
		}
		
		
		public function get z():Number {
			return _z;
		}
		
		
		public function set z(value:Number):void {
			_z = isNaN(value) ? 0 : value;
		}
		
		
		public function get ax():Number {
			return _x - _y;
		}
		
		
		public function get ay():Number {
			return _x + _y - _z;
		}
		
		
		public function get totalX():Number {
			return _location.x + _x;
		}
		
		
		public function get totalY():Number {
			return _location.y + _y;
		}
		
		
		public function get totalZ():Number {
			return _location.z + _z;
		}
		
		
		public function get totalAX():Number {
			return _location.ax + ax;
		}
		
		
		public function get totalAY():Number {
			return _location.ay + ay;
		}
		
		public function toString():String {
			return "[MatterOffset{x:" + totalX + ",y:" + totalY + ",z:" + totalZ + "}]";
		}
		
		public function getStepTop():BiomePoint {
			return _y > 0 ? _location : _location.getTopPoint();
		}
	
		public function getStepBottom():BiomePoint {
			return _y > 0 ? _location : _location.getBottomPoint();
		}
	
		public function getStepLeft():BiomePoint {
			return _x > 0 ? _location : _location.getLeftPoint();
		}
	
		public function getStepRight():BiomePoint {
			return _x > 0 ? _location : _location.getRightPoint();
		}
	
	}

}