package gate.sirius.isometric.tools {
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import gate.sirius.isometric.Biome;
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
		
		private var _hook:Function;
		
		private var _drag:Boolean;
		
		private var _startPoint:Point;
		
		private var _alphaThreshold:uint;
		
		private var _endPoint:Point;
		
		private var _maxObjects:uint;
		
		
		public function BiomeInteraction(stage:Stage, biome:Biome, hook:Function, maxObjects:uint = 0):void {
			_maxObjects = maxObjects;
			_hook = hook;
			_biome = biome;
			_stage = stage;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, _onMouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
			_startPoint = new Point(0, 0);
			_endPoint = new Point(0, 0);
		}
		
		
		private function _onMouseUp(e:MouseEvent):void {
			mouseUp(e);
		}
		
		
		private function _onMouseDown(e:MouseEvent):void {
			mouseDown(e);
		}
		
		
		private function _onMouseMove(e:MouseEvent):void {
			mouseMove(e);
		}
		
		
		public function mouseMove(e:MouseEvent):void {
			var cursorData:Object;
			var alpha:int;
			var iof:int;
			var image:Bitmap;
			var matter:BiomeMatter;
			var objects:Array = _stage.getObjectsUnderPoint(new Point(stage.mouseX, _stage.mouseY));
			var mantain:Array = [];
			var objectCount:uint = 0;
			for (var i:uint = objects.length; i > 0; null) {
				var obj:DisplayObject = objects[--i] as DisplayObject;
				image = obj as Bitmap;
				if (image && image.bitmapData) {
					alpha = image.bitmapData.getPixel32(image.mouseX, image.mouseY) >> 24 & 0xFF;
					if (alpha > _alphaThreshold) {
						matter = _biome.getMatterByName(image.name);
						if (matter) {
							if (!matter.interaction)
								continue;
							iof = _mouseOver.indexOf(image);
							_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.MOVE, _drag, e, false, false, 0, _startPoint, _endPoint, image);
							if (iof == -1) {
								_mouseOver[_mouseOver.length] = image;
								_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.OVER, _drag, e, false, false, 0, _startPoint, _endPoint, image);
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
							_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.OUT, _drag, e, false, false, 0, _startPoint, _endPoint, image);
						}
						_mouseOver.splice(iof, 1);
					}
				}catch (e:Error) {
					
				}
			}
			if (!matter) {
				_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, null, BiomeActivations.MOVE, _drag, e, false, false, 0, _startPoint, _endPoint);
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
					if (alpha > _alphaThreshold) {
						matter = _biome.getMatterByName(image.name);
						if (matter && matter.interaction && _mouseDown.indexOf(matter) == -1) {
							_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.PRESS, _drag, e, false, false, 0, _startPoint, _endPoint, image);
							_mouseDown[_mouseDown.length] = matter;
							if (++objectCount == _maxObjects) {
								break;
							}
						}
					}
				}
			}
			if (!matter) {
				_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, null, BiomeActivations.PRESS, _drag, e, false, false, 0, _startPoint, _endPoint);
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
					if (alpha > _alphaThreshold) {
						matter = _biome.getMatterByName(image.name);
						if (matter) {
							if (!matter.interaction)
								continue;
							_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.RELEASE, _drag, e, false, false, 0, _startPoint, _endPoint, image);
							iof = _mouseDown.indexOf(matter);
							if (iof !== -1) {
								_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, matter, BiomeActivations.CLICK, _drag, e, false, false, 0, _startPoint, _endPoint, image);
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
				_biome.signals.INTERACTION.send(BiomeInteractionSignal, true, null, BiomeActivations.RELEASE, _drag, e, false, false, 0, _startPoint, _endPoint);
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
		
		
		public function dispose():void {
			if (_hook !== null) {
				_hook();
				_hook = null;
				_stage = null;
			}
		}
	
	}

}