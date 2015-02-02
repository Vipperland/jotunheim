package gate.sirius.isometric.tools {
	import flash.display.BitmapData;
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeMath;
	import gate.sirius.isometric.math.BiomePoint;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class MatterScanner {
		
		public static const GATE:MatterScanner = new MatterScanner();
		
		public static const XYSCAN:int = 1;
		
		public static const XZSCAN:int = 2;
		
		public static const YZSCAN:int = 4;
		
		public function MatterScanner() {
			if (GATE) {
				throw new Error("Can´t create MatterScanner instance. Use MatterScanner.GATE instead of new.");
			}
		}
		
		public function scan(target:BitmapData, blockSize:uint, options:uint = 1):BiomeBounds {
			var alpha:uint, color:uint;
			var bounds:BiomeBounds = new BiomeBounds();
			var points:Vector.<BiomePoint> = bounds.points;
			var tx:int = (target.width / blockSize) >> 0;
			var ty:int = (target.height / blockSize) >> 0;
			switch (options) {
				case XYSCAN:  {
					BiomeMath.iterateArea(0, 0, 0, tx, ty, 1, function(x:int, y:int, z:int):void {
							color = target.getPixel32(x * tx, y * ty);
							alpha = color >> 24;
							if (alpha > 0) {
								points[points.length] = BiomePoint.create(x, y, 0);
							}
						});
					break;
				}
				case XZSCAN:  {
					BiomeMath.iterateArea(0, 0, 0, tx, ty, 1, function(x:int, y:int, z:int):void {
							color = target.getPixel32(x * tx, y * ty);
							alpha = color >> 24;
							if (alpha > 0) {
								points[points.length] = BiomePoint.create(x, 0, y);
							}
						});
					break;
				}
				case YZSCAN:  {
					BiomeMath.iterateArea(0, 0, 0, tx, ty, 1, function(x:int, y:int, z:int):void {
							color = target.getPixel32(x * tx, y * ty);
							alpha = color >> 24;
							if (alpha > 0) {
								points[points.length] = BiomePoint.create(0, y, x);
							}
						});
					break;
				}
				default:  {
					throw new Error("Invalid Scan Options.");
				}
			}
			return bounds;
		}
	
	}

}