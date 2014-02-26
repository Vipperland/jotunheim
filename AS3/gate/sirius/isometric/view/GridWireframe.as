package gate.sirius.isometric.view {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class GridWireframe extends Bitmap {
		
		protected var _spaceX:int;
		protected var _spaceY:int;
		protected var _border:int;
		
		public function GridWireframe(bitmapWidth:int, bitmapHeight:int, columns:int, rows:int, border:int = 0, bgcolor:uint = 0xFF000000, gridcolor:uint = 0xFFFFFFFF) {
			_border = border;
			var fullborder:int = (border << 1);
			var texture:BitmapData = new BitmapData(bitmapWidth + fullborder + 1, bitmapHeight + fullborder + 1, false, bgcolor);
			_spaceX = bitmapWidth / columns;
			_spaceY = bitmapHeight / rows;
			var ty:int = 0;
			var tx:int = 0;
			var fillRectangle:Rectangle = new Rectangle(border, border, 1, 1);
			++rows;
			++columns;
			while (ty < rows) {
				fillRectangle.y = ty * _spaceY + border;
				fillRectangle.width = bitmapWidth;
				texture.fillRect(fillRectangle, gridcolor);
				++ty;
			}
			
			fillRectangle.y = border;
			fillRectangle.width = 1;
			while (tx < columns) {
				fillRectangle.x = tx * _spaceX + border;
				fillRectangle.height = bitmapHeight + 1;
				texture.fillRect(fillRectangle, gridcolor);
				++tx;
			}
			
			super(texture, PixelSnapping.NEVER, true);
		}
		
		public function get spaceX():int {
			return _spaceX;
		}
		
		public function get spaceY():int {
			return _spaceY;
		}
		
		public function get border():int {
			return _border;
		}
		
		
	
	}

}