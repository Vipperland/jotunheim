package gate.sirius.isometric.data {
	
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.math.BiomeMath;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.signal.BiomeNeighborSignal;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class BiomeNeighbor {
		
		public static const LEFT:int = 1;
		
		public static const RIGHT:int = 2;
		
		public static const TOP:int = 4;
		
		public static const BOTTOM:int = 8;
		
		public static const FRONT:int = 16;
		
		public static const BACK:int = 32;
		
		public static const X_ONLY:int = LEFT | RIGHT;
		
		public static const Y_ONLY:int = TOP | BOTTOM;
		
		public static const Z_ONLY:int = FRONT | BACK;
		
		public static const ORTHOGONAL:int = X_ONLY | Y_ONLY;
		
		public static const ALL:int = X_ONLY | Y_ONLY | Z_ONLY;
		
		/** @private */
		private var _tile:BiomeEntry;
		
		/** @private */
		private var _biome:Biome;
		
		/** @private */
		private var _left:BiomeEntry;
		
		/** @private */
		private var _right:BiomeEntry;
		
		/** @private */
		private var _top:BiomeEntry;
		
		/** @private */
		private var _bottom:BiomeEntry;
		
		/** @private */
		private var _front:BiomeEntry;
		
		/** @private */
		private var _back:BiomeEntry;
		
		/** @private */
		private var _currentCall:uint;
		
		/**
		 * Pass a signal trought neighbors
		 * @param	origin
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	cost
		 */
		internal function _cascade(origin:BiomeEntry, x:int, y:int, z:int, cost:int = 0):void {
			var neighbor:BiomeEntry = _biome.getTile(origin.location.x + x, origin.location.y + y, origin.location.z + z);
			if (neighbor) {
				if (cost == 0 || BiomeMath.costOfPointToPoint(origin.location, neighbor.location) <= cost) {
					_biome.signals.NEIGHBOR_CASCADE.send(BiomeNeighborSignal, true, origin, neighbor);
					neighbor.neighbors._cascade(origin, x, y, z, cost);
				}
			}
		}
		
		/**
		 * Transfer data to all neighbors
		 * @param	filter
		 * @param	tile
		 * @param	vector
		 * @param	levels
		 * @param	data
		 * @param	delay
		 */
		protected function _doTransfer(filter:Function, origin:BiomeEntry, tile:BiomeEntry, vector:Vector.<BiomeEntry>, levels:int, data:Object, delay:int):void {
			clearTimeout(_currentCall);
			if (delay == 0)
				_transfer(filter, origin, tile, vector, levels, data, delay);
			else
				_currentCall = setTimeout(_transfer, delay, filter, origin, tile, vector, levels, data, delay);
		}
		
		/**
		 * Verify a point (if exists) and if is open
		 * @param	point
		 * @param	open
		 * @return
		 */
		private function _isOpen(point:BiomeEntry, closed:Vector.<BiomeEntry>):Boolean {
			return point && closed.indexOf(point) == -1;
		}
		
		internal function _transfer(filter:Function, origin:BiomeEntry, from:BiomeEntry, closed:Vector.<BiomeEntry>, levels:int, data:Object, delay:int):Vector.<BiomeEntry> {
			closed[closed.length] = from;
			if (--levels !== -1) {
				if (_isOpen(left, closed)) {
					if (filter(origin, from, _left, data))
						_left.neighbors._doTransfer(filter, origin, _left, closed, levels, data, delay);
				}
				if (_isOpen(right, closed)) {
					if (filter(origin, from, _right, data))
						_right.neighbors._doTransfer(filter, origin, _right, closed, levels, data, delay);
				}
				if (_isOpen(top, closed)) {
					if (filter(origin, from, _top, data))
						_top.neighbors._doTransfer(filter, origin, _top, closed, levels, data, delay);
				}
				if (_isOpen(bottom, closed)) {
					if (filter(origin, from, _bottom, data))
						_bottom.neighbors._doTransfer(filter, origin, _bottom, closed, levels, data, delay);
				}
				if (_isOpen(front, closed)) {
					if (filter(origin, from, _front, data))
						_front.neighbors._doTransfer(filter, origin, _front, closed, levels, data, delay);
				}
				if (_isOpen(back, closed)) {
					if (filter(origin, from, _back, data))
						_back.neighbors._doTransfer(filter, origin, _back, closed, levels, data, delay);
				}
			}
			return closed;
		}
		
		public function BiomeNeighbor(tile:BiomeEntry, biome:Biome) {
			_biome = biome;
			_tile = tile;
		}
		
		/**
		 * The left neighbor
		 */
		public function get left():BiomeEntry {
			return _left ||= _biome.getTileIn(_tile.location.getLeftPoint());
		}
		
		/**
		 * The right neighbor
		 */
		public function get right():BiomeEntry {
			return _right ||= _biome.getTileIn(_tile.location.getRightPoint());
		}
		
		/**
		 * The top neighbor
		 */
		public function get top():BiomeEntry {
			return _top ||= _biome.getTileIn(_tile.location.getTopPoint());
		}
		
		/**
		 * The bottom neighbor
		 */
		public function get bottom():BiomeEntry {
			return _bottom ||= _biome.getTileIn(_tile.location.getBottomPoint());
		}
		
		/**
		 * The front neighbor
		 */
		public function get front():BiomeEntry {
			return _front ||= _biome.getTileIn(_tile.location.getFrontPoint());
		}
		
		/**
		 * The back neighbor
		 */
		public function get back():BiomeEntry {
			return _back ||= _biome.getTileIn(_tile.location.getBackPoint());
		}
		
		
		/**
		 * Send a signal to each neighbor
		 */
		public function updateNeighbors(hash:int):void {
			var handler:Function = _biome.signals.NEIGHBOR_UPDATE.send;
			if (left && (hash & LEFT) == LEFT)
				handler(BiomeNeighborSignal, true, _left, _tile);
			if (right && (hash & RIGHT) == RIGHT)
				handler(BiomeNeighborSignal, true, _right, _tile);
			if (top && (hash & TOP) == TOP)
				handler(BiomeNeighborSignal, true, _top, _tile);
			if (bottom && (hash & BOTTOM) == BOTTOM)
				handler(BiomeNeighborSignal, true, _bottom, _tile);
			if (front && (hash & FRONT) == FRONT)
				handler(BiomeNeighborSignal, true, _front, _tile);
			if (back && (hash & BACK) == BACK)
				handler(BiomeNeighborSignal, true, _back, _tile);
		}
		
		/**
		 * Cast a beam in a direction
		 * @param	x
		 * @param	y
		 * @param	z
		 * @param	cost
		 */
		public function sight(direction:BiomePoint, range:uint = 0, cost:int = 0):void {
			_cascade(_tile, direction.x, direction.y, direction.z, cost);
		}
		
		/**
		 * Pass a signal through neighbors
		 * @param	cost
		 * @param	filter (origin:BiomeEntry, previous:BiomeEntry, current:BiomeEntry, data:*)
		 */
		public function transfer(filter:Function, data:Object, levels:int = 0, delay:int = 0):void {
			if (levels == 0)
				levels = 999;
			_doTransfer(filter, _tile, _tile, new Vector.<BiomeEntry>, levels, data, delay);
		}
	
	}

}