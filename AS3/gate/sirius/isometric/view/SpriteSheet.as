package gate.sirius.isometric.view {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class SpriteSheet extends Bitmap {
		
		private var _layers:Array;
		
		private var _visible:Vector.<SpriteSheetLayer>;
		
		private var _canvas:BitmapData;
		
		
		public function SpriteSheet(width:uint = 0, height:uint = 0) {
			_layers = [];
			_visible = new Vector.<SpriteSheetLayer>();
			if (width > 3 && height > 3) {
				_createCanvas(width, height);
			}
		}
		
		
		private function _createCanvas(width:uint, height:uint):void {
			_canvas = new BitmapData(width, height, true, 0x0);
			this.bitmapData = _canvas;
			update();
		}
		
		
		public function detectSize():void {
			var tx:uint = 0;
			var ty:uint = 0;
			for each (var layer:SpriteSheetLayer in _layers) {
				if (tx < layer.width) {
					tx = layer.width;
				}
				if (ty < layer.height) {
					ty = layer.height;
				}
			}
			_createCanvas(tx, ty);
		}
		
		
		public function addLayer(id:uint, layer:SpriteSheetLayer, visible:Boolean):SpriteSheetLayer {
			if (layer) {
				_layers[id] = layer;
				if (visible) {
					showLayer(id);
				}
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
			}
		}
		
		
		public function hideLayer(id:uint):void {
			var layer:SpriteSheetLayer;
			if (id in _layers) {
				layer = _layers[id];
				var iof:int = _visible.indexOf(layer);
				if (iof !== -1) {
					_visible.splice(iof, 1);
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
		
		
		public function get length():uint {
			return _layers.length;
		}
		
		
		public function clear():void {
			_canvas.fillRect(_canvas.rect, 0x0);
		}
		
		
		public function clone():SpriteSheet {
			var layer:SpriteSheetLayer;
			var clayer:SpriteSheetLayer;
			var i:uint;
			var copy:SpriteSheet = new SpriteSheet();
			
			for (i = 0; i < _layers.length; i++) {
				layer = _layers[i] as SpriteSheetLayer;
				clayer = layer ? layer.clone() : null;
				copy._layers[i] = clayer;
				if (layer && _visible.indexOf(layer) !== -1) {
					copy._visible[i] = clayer;
				}
			}
			if (!_canvas) {
				detectSize();	
			}
			copy._createCanvas(_canvas.width, _canvas.height);
			copy.update();
			
			return copy;
		}
		
		public function merge(sprite:SpriteSheet, offset:Point):void {
			for each(var layer:SpriteSheetLayer in sprite._layers) {
				addLayer(length, layer.clone(offset), sprite._visible.indexOf(layer) !== -1);
			}
			update();
		}
		
		public function dispose():void {
			if (_canvas) {
				_layers = null;
				_visible = null;
				_canvas.dispose();
				_canvas = null;
			}
		}
	
	}

}