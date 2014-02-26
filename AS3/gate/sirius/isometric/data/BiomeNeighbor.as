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
		
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const FRONT:String = "front";
		public static const BACK:String = "back";
		public static const NONE:String = "none";
		
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
			var neightbor:BiomeEntry = _biome.getTile(origin.location.x + x, origin.location.y + y, origin.location.z + z);
			if (neightbor) {
				if (cost == 0 || BiomeMath.costOfPointToPoint(origin.location, neightbor.location) <= cost) {
					_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.CASCADE, origin, neightbor));
					neightbor.neighbors._cascade(origin, x, y, z, cost);
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
		protected function _doTransfer(filter:Function, tile:BiomeEntry, vector:Vector.<BiomeEntry>, levels:int, data:Object, delay:int):void {
			clearTimeout(_currentCall);
			if (delay == 0)
				_transfer(filter, tile, vector, levels, data, delay);
			else
				_currentCall = setTimeout(_transfer, delay, filter, tile, vector, levels, data, delay);
		}
		
		/**
		 * Verify a point (if exists) and if is open
		 * @param	point
		 * @param	open
		 * @return
		 */
		private function _isClosed(point:BiomeEntry, open:Vector.<BiomeEntry>):Boolean {
			return point && open.indexOf(point) == -1;
		}
		
		/**
		 * Flow() will be called in each neighboor
		 * @param	cost
		 * @param	filter
		 * @param	from
		 * @param	open
		 * @return
		 */
		internal function _flow(cost:int, filter:Function, from:BiomePoint, open:Vector.<BiomeEntry>):Boolean {
			
			open[open.length] = _tile;
			
			var currentCost:int = 0;
			
			if (cost > 0)
				currentCost = BiomeMath.costOfPointToPoint(from, _tile.location);
			
			if (currentCost > cost || !filter(_tile, currentCost))
				return false;
			
			if (_isClosed(left, open))
				(!_left.neighbors._flow(cost, filter, from, open))
			
			if (_isClosed(bottom, open))
				(!_bottom.neighbors._flow(cost, filter, from, open))
			
			if (_isClosed(right, open))
				(!_right.neighbors._flow(cost, filter, from, open))
			
			if (_isClosed(top, open))
				(!_top.neighbors._flow(cost, filter, from, open))
			
			if (_isClosed(back, open))
				(!_back.neighbors._flow(cost, filter, from, open))
			
			if (_isClosed(front, open))
				(!_front.neighbors._flow(cost, filter, from, open))
			
			return true;
		
		}
		
		internal function _transfer(filter:Function, from:BiomeEntry, open:Vector.<BiomeEntry>, levels:int, data:Object, delay:int):Vector.<BiomeEntry> {
			open[open.length] = from;
			if (--levels !== -1) {
				if (_isClosed(left, open)) {
					if (filter(from, _left, data))
						_left.neighbors._doTransfer(filter, _left, open, levels, data, delay);
				}
				if (_isClosed(right, open)) {
					if (filter(from, _right, data))
						_right.neighbors._doTransfer(filter, _right, open, levels, data, delay);
				}
				if (_isClosed(top, open)) {
					if (filter(from, _top, data))
						_top.neighbors._doTransfer(filter, _top, open, levels, data, delay);
				}
				if (_isClosed(bottom, open)) {
					if (filter(from, _bottom, data))
						_bottom.neighbors._doTransfer(filter, _bottom, open, levels, data, delay);
				}
				if (_isClosed(front, open)) {
					if (filter(from, _front, data))
						_front.neighbors._doTransfer(filter, _front, open, levels, data, delay);
				}
				if (_isClosed(back, open)) {
					if (filter(from, _back, data))
						_back.neighbors._doTransfer(filter, _back, open, levels, data, delay);
				}
			}
			return open;
		}
		
		public function BiomeNeighbor(tile:BiomeEntry, biome:Biome) {
			_biome = biome;
			_tile = tile;
		}
		
		/**
		 * The left neighbor
		 */
		public function get left():BiomeEntry {
			return _left ||= _biome.getTileFromPoint(_tile.location.getLeftPoint());
		}
		
		/**
		 * The right neighbor
		 */
		public function get right():BiomeEntry {
			return _right ||= _biome.getTileFromPoint(_tile.location.getRightPoint());
		}
		
		/**
		 * The top neighbor
		 */
		public function get top():BiomeEntry {
			return _top ||= _biome.getTileFromPoint(_tile.location.getTopPoint());
		}
		
		/**
		 * The bottom neighbor
		 */
		public function get bottom():BiomeEntry {
			return _bottom ||= _biome.getTileFromPoint(_tile.location.getBottomPoint());
		}
		
		/**
		 * The front neighbor
		 */
		public function get front():BiomeEntry {
			return _front ||= _biome.getTileFromPoint(_tile.location.getFrontPoint());
		}
		
		/**
		 * The back neighbor
		 */
		public function get back():BiomeEntry {
			return _back ||= _biome.getTileFromPoint(_tile.location.getBackPoint());
		}
		
		/**
		 * Send a signal to ach neighbor
		 */
		public function updateNeighbors():void {
			if (left)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _left, _tile));
			if (right)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _right, _tile));
			if (top)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _top, _tile));
			if (bottom)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _bottom, _tile));
			if (front)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _front, _tile));
			if (back)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _back, _tile));
		}
		
		/**
		 * Send a signal to ach neighbor
		 */
		public function filterNeighbors(... exclude:Array):void {
			if (left && exclude.indexOf(LEFT) == -1)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _left, _tile));
			if (right && exclude.indexOf(RIGHT) == -1)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _right, _tile));
			if (top && exclude.indexOf(TOP) == -1)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _top, _tile));
			if (bottom && exclude.indexOf(BOTTOM) == -1)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _bottom, _tile));
			if (front && exclude.indexOf(FRONT) == -1)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _front, _tile));
			if (back && exclude.indexOf(BACK) == -1)
				_biome.signals.send(new BiomeNeighborSignal(BiomeNeighborSignal.FOUND, _back, _tile));
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
		 * Search all neighbors
		 * @param	cost
		 * @param	filter
		 */
		public function flow(cost:int, filter:Function):void {
			if (cost == 0)
				cost = 999;
			_flow(cost, filter, _tile.location, new Vector.<BiomeEntry>);
		}
		
		/**
		 * Pass a signal through neighbors
		 * @param	cost
		 * @param	filter
		 */
		public function transfer(filter:Function, data:Object, levels:int = 0, delay:int = 0):void {
			if (levels == 0)
				levels = 999;
			_doTransfer(filter, _tile, new Vector.<BiomeEntry>, levels, data, delay);
		}
	
	}

}