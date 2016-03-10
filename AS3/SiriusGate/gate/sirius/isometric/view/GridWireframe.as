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
		
		private var _backgroundColor:uint;
		private var _fillRect:Rectangle;
		private var _tileWidth:uint;
		private var _tileHeight:uint;
		private var _border:uint;
		
		public function GridWireframe(tileWidth:uint, tileHeight:uint, columns:uint, rows:uint, border:uint = 0, bgcolor:uint = 0xFF000000, gridcolor:uint = 0xFFFFFFFF) {
			
			_tileHeight = tileHeight;
			_tileWidth = tileWidth;
			_backgroundColor = gridcolor;
			
			var fullborder:uint = (border << 1);
			
			var texture:BitmapData = new BitmapData(tileWidth * columns + fullborder, tileHeight * rows + fullborder, true, bgcolor);
			var ty:uint = 0;
			var tx:uint = 0;
			
			_fillRect = new Rectangle(0, 0, tileWidth - 2, tileHeight - 2);
			
			var totalTiles:uint = columns * rows;
			var currentTile:uint = 0;
			
			super(texture, PixelSnapping.NEVER, true);
			
			while (currentTile < totalTiles) {
				flushTile(currentTile % columns, int(currentTile / columns), gridcolor);
				++currentTile;
			}
		}
		
		public function flushTile(x:int, y:int, color:uint):void {
			_fillRect.x = x * _tileWidth + 1;
			_fillRect.y = y * _tileHeight + 1;
			bitmapData.fillRect(_fillRect, color);
		}
		
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
	
	}

}