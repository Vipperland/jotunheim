package gate.sirius.isometric.view {
	
	import flash.display.BitmapData;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class ComposedSpriteSheet extends SpriteSheet {
		
		public function ComposedSpriteSheet() {
		
		}
		
		
		public function merge(... layers:Array):void {
			var i:int;
			var layer:SpriteSheet;
			var bounds:Vector.<Rectangle> = new Vector.<Rectangle>();
			var cur:Rectangle;
			for each (layer in layers)
				for (i = 0; i < layer._totalFrames; ++i) {
					if (i == bounds.length)
						bounds[i] = new Rectangle(0, 0, 0, 0);
					var bmp:BitmapData = layer._materials[i];
					cur = bounds[i];
					if (cur.width < bmp.width)
						cur.width = bmp.width;
					if (cur.height < bmp.height)
						cur.height = bmp.height;
				}
			for each (cur in bounds)
				addFrame(new BitmapData(cur.width, cur.height, true, 0), 0, 0);
			var tg:Point = new Point(0, 0);
			for each (layer in layers)
				for (i = 0; i < layer._totalFrames; ++i) {
					bmp = layer._materials[i];
					_materials[i].merge(bmp, bmp.rect, tg, 1, 1, 1, 1);
				}
			_renderFrame();
		}
	
	}

}