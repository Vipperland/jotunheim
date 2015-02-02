package gate.sirius.isometric.view {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class SpriteSheet extends Bitmap {
		
		private var _layers:Array;
		
		private var _visible:Vector.<SpriteSheetLayer>;
		
		private var _canvas:BitmapData;
		
		
		public function SpriteSheet(width:uint, height:uint) {
			_layers = [];
			_visible = new Vector.<SpriteSheetLayer>();
			_createCanvas(width, height);
		}
		
		
		private function _createCanvas(width:uint, height:uint):void {
			_canvas = new BitmapData(width, height, true, 0x0);
			this.bitmapData = _canvas;
			update();
		}
		
		
		public function addLayer(id:uint, layer:SpriteSheetLayer, visible:Boolean):SpriteSheetLayer {
			_layers[id] = layer;
			if (visible) {
				showLayer(id);
			}
			return layer;
		}
		
		
		public function removeLayer(id:uint):Boolean {
			if (id in _layers) {
				hideLayer(id);
				delete _layers[id];
				return true;
			}
			return false;
		}
		
		
		public function showLayer(id:uint):void {
			var layer:SpriteSheetLayer;
			if (id in _layers) {
				layer = _layers[id];
				if (_visible.indexOf(layer) == -1) {
					_visible[_visible.length] = layer;
				}
				update();
			}
		}
		
		
		public function hideLayer(id:uint):void {
			var layer:SpriteSheetLayer;
			if (id in _layers) {
				layer = _layers[id];
				var iof:int = _visible.indexOf(layer);
				if (iof !== -1) {
					_visible.splice(iof, 1);
					update();
				}
			}
		}
		
		
		public function update():void {
			_canvas.fillRect(_canvas.rect, 0x0);
			for each (var layer:SpriteSheetLayer in _visible) {
				var texture:BitmapData = layer.current;
				if (texture) {
					_canvas.copyPixels(texture, texture.rect, layer.offset, null, null, true);
				}
			}
		}
		
		
		public function next():void {
			_canvas.fillRect(_canvas.rect, 0x0);
			for each (var layer:SpriteSheetLayer in _visible) {
				layer.next();
				var texture:BitmapData = layer.current;
				if (texture) {
					_canvas.copyPixels(texture, texture.rect, layer.offset, null, null, true);
				}
			}
		}
		
		
		public function previous():void {
			_canvas.fillRect(_canvas.rect, 0x0);
			for each (var layer:SpriteSheetLayer in _visible) {
				layer.previous();
				var texture:BitmapData = layer.current;
				if (texture) {
					_canvas.copyPixels(texture, texture.rect, layer.offset, null, null, true);
				}
			}
		}
		
		
		public function reset():void {
			_canvas.fillRect(_canvas.rect, 0x0);
			for each (var layer:SpriteSheetLayer in _visible) {
				layer.reset();
				var texture:BitmapData = layer.current;
				if (texture) {
					_canvas.copyPixels(texture, texture.rect, layer.offset, null, null, true);
				}
			}
		}
		
		
		public function clear():void {
			_canvas.fillRect(_canvas.rect, 0x0);
		}
	
	}

}