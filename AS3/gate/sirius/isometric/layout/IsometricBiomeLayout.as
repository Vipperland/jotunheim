package gate.sirius.isometric.layout {
	import flash.utils.Dictionary;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.matter.DepthInfo;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class IsometricBiomeLayout implements IBiomeLayout {
		
		private static const SORT_PROP:String = "depth";
		
		private var matterA:BiomeMatter;
		
		private var matterB:BiomeMatter;
		
		private var depthA:DepthInfo;
		
		private var depthB:DepthInfo;
		
		private var filter:Dictionary;
		
		private var countA:uint;
		
		private var countB:uint;
		
		private var _preFilter:Function;
		
		private var _postFilter:Function;
		
		private var _noSort:Boolean;
		
		
		public function IsometricBiomeLayout(noSort:Boolean, preFilter:Function = null, postFilter:Function = null) {
			_noSort = noSort;
			_postFilter = postFilter;
			_preFilter = preFilter;
		}
		
		
		public function clear():void {
			matterA = null;
			matterB = null;
			depthA = null;
			depthB = null;
			filter = null;
		}
		
		
		/* INTERFACE gate.sirius.isometric.layout.IBiomeLayout */
		
		public function sort(objects:Vector.<BiomeMatter>):Vector.<BiomeMatter> {
			
			filter = new Dictionary(true);
			countA = 0;
			
			var result:Array = [];
			
			for each (matterA in objects) {
				if (!_filter(matterA))
					continue;
				depthA = matterA.depthInfo;
				depthA.visited = false;
				if (!_noSort)
					result[countA] = matterA;
				countB = 0;
				for each (matterB in objects) {
					if (matterA !== matterB && _filter(matterB)) {
						depthB = matterB.depthInfo;
						if (depthB.x < depthA.width && depthB.y < depthA.height && depthB.z < depthA.depth) {
							depthA.behind[countB] = depthB.matter;
							++countB;
						}
					}
				}
				++countA;
			}
			
			countA = 0;
			
			for each (matterA in objects) {
				_path(matterA);
			}
			
			return _noSort ? objects : Vector.<BiomeMatter>(result.sortOn(SORT_PROP, Array.NUMERIC));
		}
		
		
		private function _filter(matter:BiomeMatter):Boolean {
			return _preFilter == null || (filter[matter.name] ||= _preFilter(matter));
		}
		
		
		private function _path(matter:BiomeMatter):void {
			
			var depth:DepthInfo = matter.depthInfo;
			
			if (!depth.visited) {
				
				depth.visited = true;
				
				for each (matter in depth.behind) {
					_path(matter);
				}
				
				depth.behind.splice(0, depth.behind.length);
				
				depth.current = countA;
				
				if (_postFilter !== null) {
					_postFilter(matter);
				}
				
				++countA;
				
			}
		
		}
	
	}

}