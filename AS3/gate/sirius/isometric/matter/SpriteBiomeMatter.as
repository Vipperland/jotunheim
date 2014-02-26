package gate.sirius.isometric.matter {
	
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SpriteBiomeMatter extends BiomeMatter {
		
		public function SpriteBiomeMatter(name:String, bounds:BiomeBounds = null, location:BiomeFlexPoint = null, texture:Sprite = null, pixelSnapping:String = "auto", smoothing:Boolean = false) {
			super(name, bounds, location);
			_content = texture;
		}
		
	}

}