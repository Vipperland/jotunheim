package gate.sirius.isometric.matter {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class TexturizedBiomeMatter extends BiomeMatter {
		
		protected var _texture:BitmapData;
		
		
		public function TexturizedBiomeMatter(name:String, bounds:BiomeBounds = null, location:BiomeFlexPoint = null, texture:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false) {
			super(name, bounds, location);
			_texture = texture;
			_content = new Bitmap(texture, pixelSnapping, smoothing);
		}
		
		
		public function get texture():BitmapData {
			return _texture;
		}
		
		
		public function set texture(value:BitmapData):void {
			_texture = value;
			(content as Bitmap).bitmapData = _texture;
		}
	
	}

}