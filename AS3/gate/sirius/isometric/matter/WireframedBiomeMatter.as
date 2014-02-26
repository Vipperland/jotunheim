package gate.sirius.isometric.matter {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class WireframedBiomeMatter extends TexturizedBiomeMatter {
		
		public function WireframedBiomeMatter(name:String, bounds:BiomeBounds = null, location:BiomeFlexPoint = null) {
			super(name, bounds, location, null, PixelSnapping.NEVER, false);
		}
		
		
		public function drawTexture(color:int = 0xFFFFFF, cellWidth:int = 10, cellHeight:int = 10):void {
			texture = new BitmapData(_bounds.width * cellWidth, _bounds.height * cellHeight, false, color);
			var tx:int = 0;
			var ty:int = 0;
			var rect:Rectangle = new Rectangle(0, 0, cellWidth, cellHeight);
			var cA:int = 0x99000000 | color;
			var cB:int = 0xCC000000 | color;
			var alt:Boolean;
			while (ty < _bounds.height) {
				while (tx < _bounds.width) {
					texture.fillRect(rect, alt ? cB : cA);
					alt = !alt;
					++tx;
				}
				if (tx % 2 == 0) {
					alt = !alt;
				}
				tx = 0;
				++ty;
			}
		}
	
	}

}