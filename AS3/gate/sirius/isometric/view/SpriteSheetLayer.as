package gate.sirius.isometric.view {
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SpriteSheetLayer {
		
		private var _offset:Point;
		
		private var _width:int;
		
		private var _height:int;
		
		private var _frames:Vector.<BitmapData>;
		
		private var _currentFrame:uint;
		
		
		public function SpriteSheetLayer(x:int = 0, y:int = 0) {
			_frames = new Vector.<BitmapData>();
			_offset = new Point(x, y);
			_currentFrame = 0;
		}
		
		
		public function addFrame(texture:BitmapData):void {
			_frames[_frames.length] = texture;
			if (texture.width > _width) {
				_width = texture.width;
			}
			if (texture.height > _height) {
				_height = texture.height;
			}
		}
		
		
		public function setOffset(x:int, y:int):void {
			_offset.y = y;
			_offset.x = x;
		}
		
		
		public function get width():int {
			return _width;
		}
		
		
		public function get height():int {
			return _height;
		}
		
		
		public function get current():BitmapData {
			return _frames[_currentFrame];
		}
		
		
		public function get offset():Point {
			return _offset;
		}
		
		
		public function next():void {
			if (_currentFrame == _frames.length) {
				_currentFrame = 0;
			} else {
				++_currentFrame;
			}
		}
		
		
		public function previous():void {
			if (_currentFrame > 0) {
				--_currentFrame;
			} else {
				_currentFrame = _frames.length;
			}
		}
		
		
		public function clone():SpriteSheetLayer {
			var layer:SpriteSheetLayer = new SpriteSheetLayer(_offset.x, _offset.y);
			layer._frames = _frames;
			return layer;
		}
		
		
		public function reset():void {
			_currentFrame = 0;
		}
	
	}

}