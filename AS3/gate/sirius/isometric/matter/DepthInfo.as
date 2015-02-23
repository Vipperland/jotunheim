package gate.sirius.isometric.matter {
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class DepthInfo {
		
		public var visited:Boolean;
		
		public var current:uint;
		
		private var _matter:BiomeMatter;
		
		private var _behind:Vector.<BiomeMatter>;
		
		
		public function DepthInfo(matter:BiomeMatter) {
			_matter = matter;
			_behind = new Vector.<BiomeMatter>();
			current = 0;
		}
		
		
		public function get matter():BiomeMatter {
			return _matter;
		}
		
		
		public function get behind():Vector.<BiomeMatter> {
			return _behind;
		}
		
		
		public function get x():int {
			return _matter.location.x;
		}
		
		
		public function get y():int {
			return _matter.location.y;
		}
		
		
		public function get z():int {
			return _matter.location.z;
		}
		
		
		public function get width():int {
			return x + _matter.allocation.current.width;
		}
		
		
		public function get height():int {
			return y + _matter.allocation.current.height;
		}
		
		
		public function get depth():int {
			return z + _matter.allocation.current.depth;
		}
		
		
		public function dispose():void {
			_matter = null;
			_behind = null;
		}
		
		public function toString():String {
			return "[DepthInfo name=" + _matter.name + " current=" + current + " x=" + x + " y=" + y + " z=" + z + " width=" + width + " height=" + height + " depth=" + depth + "]";
		}
	
	}

}