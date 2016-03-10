package gate.sirius.isometric.tools {
	import gate.sirius.isometric.matter.BiomeMatter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class VectorFilter {
		
		public static function apply(target:Vector.<BiomeMatter>, ... filter:Array):Vector.<BiomeMatter> {
			var matter:BiomeMatter;
			var index:int;
			main: for (var i:int = target.length; i > 0; --i) {
				index = i - 1;
				matter = target[index];
				for each (var cClass:Class in filter) {
					if (matter is cClass) {
						continue main;
					}
				}
				target.splice(index, 1);
			}
			return target;
		}
	
	}

}