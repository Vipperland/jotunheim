package gate.sirius.isometric.tools {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import gate.sirius.isometric.Biome;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.math.low.Bit;
	import gate.sirius.isometric.math.low.BitIO;
	import gate.sirius.isometric.matter.BiomeActivations;
	import gate.sirius.isometric.matter.BiomeMatter;
	import gate.sirius.isometric.signal.BiomeInteractionSignal;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class BiomeInteraction {
		
		private const _mouseDown:Array = [];
		
		private const _mouseOver:Array = [];
		
		private var _stage:Stage;
		
		private var _biome:Biome;
		
		private var _drag:Boolean;
		
		private var _startPoint:Point;
		
		private var _alphaThreshold:uint;
		
		private var _endPoint:Point;
		
		private var _maxObjects:uint;
		
		private var _mousePoint:Point;
		
		private var _enabled:Boolean;
		
		private var _tileSize:Point;
		
		private var _mouse_value:uint;
		
		public function BiomeInteraction(stage:Stage, biome:Biome, maxObjects:uint = 0):void {
			_maxObjects = maxObjects;
			_biome = biome;
			_stage = stage;
			_mouse_value = 0
			_startPoint = new Point(0, 0);
			_endPoint = new Point(0, 0);
			_mousePoint = new Point(0, 0);
			_alphaThreshold = 0;
		}
		
		private function _onMouseMove(e:MouseEvent):void {
			mouseMove(e);
		}
		
		private function _onMouseUp_left(e:MouseEvent):void {
			mouseUp(e);
			_mouse_value = BitIO.not(_mouse_value, Bit.P01);
		}
		
		private function _onMouseDown_left(e:MouseEvent):void {
			_mouse_value = BitIO.or(_mouse_value, Bit.P01);
			mouseDown(e);
		}
		
		private function _onMouseUp_middle(e:MouseEvent):void {
			mouseUp(e);
			_mouse_value = BitIO.not(_mouse_value, Bit.P02);
		}
		
		private function _onMouseDown_middle(e:MouseEvent):void {
			_mouse_value = BitIO.or(_mouse_value, Bit.P02);
			mouseDown(e);
		}
		
		private function _onMouseUp_right(e:MouseEvent):void {
			mouseUp(e);
			_mouse_value = BitIO.not(_mouse_value, Bit.P03);
		}
		
		private function _onMouseDown_right(e:MouseEvent):void {
			_mouse_value = BitIO.or(_mouse_value, Bit.P03);
			mouseDown(e);
		}
		
		public function mouseMove(e:MouseEvent):void {
			_mousePoint.x = stage.mouseX;
			_mousePoint.y = stage.mouseY;
			var cursorData:Object;
			var alpha:int;
			var iof:int;
			var image:Bitmap;
			var matter:BiomeMatter;
			var objects:Array = _stage.getObjectsUnderPoint(_mousePoint);
			var mantain:Array = [];
			var objectCount:uint = 0;
			for (var i:uint = objects.length; i > 0; null) {
				var obj:DisplayObject = objects[--i] as DisplayObject;
				image = obj as Bitmap;
				if (image && image.bitmapData) {
					alpha = image.bitmapData.getPixel32(image.mouseX, image.mouseY) >> 24 & 0xFF;
					if (alpha >= _alphaThreshold) {
						matter = _biome.getMatterByName(image.name);
						if (matter) {
							if (!matter.interaction)
								continue;
							iof = _mouseOver.indexOf(image);
							_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.MOVE, _drag, e, _mouse_value, 0, _startPoint, _endPoint, image);
							if (iof == -1) {
								_mouseOver[_mouseOver.length] = image;
								_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.OVER, _drag, e, _mouse_value, 0, _startPoint, _endPoint, image);
							}
							mantain[mantain.length] = image;
							if (_maxObjects !== 0 && ++objectCount == _maxObjects) {
								break;
							}
						}
					}
				}
			}
			
			for (iof = _mouseOver.length - 1; iof !== -1; --iof) {
				image = _mouseOver[iof];
				try {
					alpha = image.bitmapData.getPixel32(image.mouseX, image.mouseY) >> 24 & 0xFF;
					if (alpha <= _alphaThreshold || mantain.indexOf(image) == -1) {
						matter = _biome.getMatterByName(image.name);
						if (matter && matter.interaction) {
							_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.OUT, _drag, e, _mouse_value, 0, _startPoint, _endPoint, image);
						}
						_mouseOver.splice(iof, 1);
					}
				}catch (e:Error) {
					
				}
			}
			if (!matter) {
				_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, null, BiomeActivations.MOVE, _drag, e, _mouse_value, 0, _startPoint, _endPoint);
			}
		
		}
		
		
		public function mouseDown(e:MouseEvent):void {
			_drag = true;
			_startPoint = new Point(_stage.mouseX, _stage.mouseY);
			var matter:BiomeMatter;
			var image:Bitmap;
			var objects:Array = _stage.getObjectsUnderPoint(_startPoint);
			var objectCount:uint = 0;
			for (var i:uint = objects.length; i > 0; null) {
				var obj:DisplayObject = objects[--i] as DisplayObject;
				image = obj as Bitmap;
				if (image && image.bitmapData) {
					var alpha:int = image.bitmapData.getPixel32(image.mouseX, image.mouseY) >> 24 & 0xFF;
					if (alpha >= _alphaThreshold) {
						matter = _biome.getMatterByName(image.name);
						if (matter && matter.interaction && _mouseDown.indexOf(matter) == -1) {
							_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.PRESS, _drag, e, _mouse_value, 0, _startPoint, _endPoint, image);
							_mouseDown[_mouseDown.length] = matter;
							if (++objectCount == _maxObjects) {
								break;
							}
						}
					}
				}
			}
			if (!matter) {
				_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, null, BiomeActivations.PRESS, _drag, e, _mouse_value, 0, _startPoint, _endPoint);
			}
		}
		
		
		public function mouseUp(e:MouseEvent):void {
			_drag = false;
			var iof:int;
			var matter:BiomeMatter;
			var image:Bitmap;
			_endPoint = new Point(stage.mouseX, _stage.mouseY);
			var objects:Array = _stage.getObjectsUnderPoint(_endPoint);
			var objectCount:uint = 0;
			for (var i:uint = objects.length; i > 0; null) {
				var obj:DisplayObject = objects[--i] as DisplayObject;
				image = obj as Bitmap;
				if (image && image.bitmapData) {
					var alpha:int = image.bitmapData.getPixel32(image.mouseX, image.mouseY) >> 24 & 0xFF;
					if (alpha >= _alphaThreshold) {
						matter = _biome.getMatterByName(image.name);
						if (matter) {
							if (!matter.interaction)
								continue;
							_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.RELEASE, _drag, e, _mouse_value, 0, _startPoint, _endPoint, image);
							iof = _mouseDown.indexOf(matter);
							if (iof !== -1) {
								_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.CLICK, _drag, e, _mouse_value, 0, _startPoint, _endPoint, image);
								_mouseDown.splice(iof, 1);
							}
							if (++objectCount == _maxObjects) {
								break;
							}
						}
					}
				}
			}
			if (!matter) {
				_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, null, BiomeActivations.RELEASE, _drag, e, _mouse_value, 0, _startPoint, _endPoint);
				if (_mouseDown.length == 0){
					_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, null, BiomeActivations.CLICK, _drag, e, _mouse_value, 0, _startPoint, _endPoint);
				}
			}
			
		}
		
		
		public function get stage():Stage {
			return _stage;
		}
		
		
		public function get drag():Boolean {
			return _drag;
		}
		
		
		public function get alphaThreshold():uint {
			return _alphaThreshold;
		}
		
		
		public function set alphaThreshold(value:uint):void {
			_alphaThreshold = value;
			if (_alphaThreshold > 254) {
				_alphaThreshold = 254;
			}
		}
		
		public function setTileSize(width:int, height:int):void {
			_tileSize = new Point(width, height);
		}
		
		public function dispose():void {
			disable();
			_stage = null;
		}
		
		public function enable():void {
			if (!_enabled){
				_enabled = true;
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown_left, false, 0, true);
				_stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp_left, false, 0, true);
				_stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, _onMouseDown_middle, false, 0, true);
				_stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, _onMouseUp_middle, false, 0, true);
				_stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, _onMouseDown_right, false, 0, true);
				_stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, _onMouseUp_right, false, 0, true);
			}
		}
		
		public function disable():void {
			if (_enabled){
				_enabled = false;
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
				_stage.removeEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown_left);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, _onMouseUp_left);
				_stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, _onMouseDown_middle);
				_stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, _onMouseUp_middle);
				_stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, _onMouseDown_right);
				_stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, _onMouseUp_right);
			}
		}
		
		public function getTile():BiomeFlexPoint {
			if (_tileSize != null){
				var tx:int = _biome.viewport.location.x + ((_mousePoint.x / _tileSize.x) >> 0);
				var ty:int = _biome.viewport.location.y + ((_mousePoint.y / _tileSize.y) >> 0);
				return new BiomeFlexPoint(tx, ty, 0);
			}else{
				return new BiomeFlexPoint(_mousePoint.x, _mousePoint.y, 0);
			}
		}
		
	}

}