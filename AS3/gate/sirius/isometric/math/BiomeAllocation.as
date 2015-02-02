package gate.sirius.isometric.math {
	import gate.sirius.isometric.matter.BiomeMatter;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class BiomeAllocation {
		
		internal var _linkedMatter:BiomeMatter;
		
		private var _bounds:Vector.<BiomeBounds>;
		
		private var _current:BiomeBounds;
		
		private var _position:int = 0;
		
		private function _setLink(matter:BiomeMatter):BiomeAllocation {
			_linkedMatter = matter;
			return this;
		}
		
		public function BiomeAllocation(... bounds:Array) {
			if (bounds[0] is Array) {
				bounds = bounds[0];
			}
			_current = bounds[0] ||= new BiomeBounds();
			_bounds = Vector.<BiomeBounds>(bounds);
		}
		
		public function get current():BiomeBounds {
			return _current;
		}
		
		public function get bounds():Vector.<BiomeBounds> {
			return _bounds;
		}
		
		public function find(bounds:BiomeBounds):void {
			var iof:int = _bounds.indexOf(bounds);
			if (iof !== -1) {
				_current = _bounds[iof];
			}
		}
		
		public function getLeft():BiomeBounds {
			if (_position == 0) {
				return _bounds[_bounds.length - 1];
			}
			return _bounds[_position - 1];
		}
		
		public function getRight():BiomeBounds {
			if (_position == _bounds.length - 1) {
				return _bounds[0];
			}
			return _bounds[_position + 1];
		}
		
		public function rotateLeft():BiomeBounds {
			if (--_position <= 0) {
				_position = _bounds.length - 1;
			}
			_current = _bounds[_position];
			_linkedMatter.post();
			return _current;
		}
		
		public function rotateRight():BiomeBounds {
			if (++_position >= _bounds.length) {
				_position = 0;
			}
			_current = _bounds[_position];
			_linkedMatter.post();
			return _current;
		}
		
		public function getUnique(matter:BiomeMatter):BiomeAllocation {
			if (_linkedMatter) {
				return new BiomeAllocation(_bounds)._setLink(matter);
			}
			_linkedMatter = matter;
			return this;
		}
		
		public function dispose():void {
			_linkedMatter = null;
			_current = null;
			_bounds = null;
			_position = 0;
		}
		
		public function clone(to:BiomeMatter, options:uint = 0, mirror:Boolean = false):BiomeAllocation {
			var bounds:Array = [];
			for each (var bound:BiomeBounds in _bounds) {
				bounds[bounds.length] = bound.clone(options, mirror);
			}
			return new BiomeAllocation(bounds).getUnique(to);
		}
		
		public function toString():String {
			return "[BiomeAllocation current=" + current + " totalBounds=" + bounds.length + " currentIndex=" + _current + "]";
		}
	
	}

}