package gate.sirius.isometric.view {
	import gate.sirius.isometric.recycler.IRecyclable;
	import gate.sirius.isometric.recycler.Recycler;
	
	import gate.sirius.isometric.timer.IActiveObject;
	import gate.sirius.isometric.timer.TickController;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SpriteSheet extends Bitmap implements IRecyclable, IActiveObject {
		
		protected var _controller:TickController;
		
		protected var _fps:int;
		
		protected var _timeMultiplier:Number;
		
		protected var _frameX:int;
		
		protected var _frameY:int;
		
		protected var _currentFrameNumber:int;
		
		protected var _currentFrame:BitmapData;
		
		protected var _currentOffset:FrameOffset;
		
		protected var _isPlaying:Boolean;
		
		protected var _materials:Vector.<BitmapData>;
		
		protected var _offsets:Vector.<FrameOffset>;
		
		protected var _totalFrames:int;
		
		protected var _backframe:int;
		
		public var repeat:Boolean;
		
		
		public function SpriteSheet() {
			_materials = new Vector.<BitmapData>();
			_offsets = new Vector.<FrameOffset>();
			_currentFrameNumber = -1;
			_backframe = -1;
			_timeMultiplier = 1;
			_currentOffset = new FrameOffset(0, 0);
		}
		
		
		public function addFrames(... list:Array):void {
			for each (var bmp:BitmapData in list) {
				addFrame(bmp, 0, 0);
			}
		}
		
		
		public function addFrame(bitmapData:BitmapData, x:int = 0, y:int = 0):void {
			_materials[_materials.length] = bitmapData;
			_offsets[_offsets.length] = new FrameOffset(x, y);
			_backframe = 0;
			if (_currentFrameNumber == -1) {
				nextFrame();
			}
		}
		
		
		public function setFrameOffset(frame:int, x:int, y:int):void {
			_offsets[frame].x = x;
			_offsets[frame].y = y;
		}
		
		
		public function removeFrame(... list:Array):void {
			list = list.sort(Array.NUMERIC).reverse();
			for each (var index:int in list) {
				if (index < _materials.length) {
					_materials.splice(index, 1);
					_offsets.splice(index, 1);
				}
			}
			
			var iof:int = _materials.indexOf(_currentFrame);
			
			if (_materials.length == 0)
				_backframe = -1;
			
			if (iof == -1)
				_currentFrameNumber = _backframe;
			else if(_currentFrameNumber !== iof)
				_currentFrameNumber = iof;
		}
		
		
		/* INTERFACE alchemy.vipperland.isometric.timer.IActiveObject */
		
		public function tick(timeMultiplier:Number):void {
			_timeMultiplier = timeMultiplier;
			nextFrame();
		}
		
		
		public function inactivated():void {
		
		}
		
		
		public function activated():void {
		
		}
		
		
		/* INTERFACE alchemy.vipperland.isometric.recycler.IRecyclable */
		
		public function onDump():void {
		
		}
		
		
		public function onCollect():void {
		
		}
		
		
		/* Class */
		
		protected function _renderFrame():void {
			_currentFrame = _materials[_currentFrameNumber];
			_currentOffset = _offsets[_currentFrameNumber];
			this.bitmapData = _currentFrame;
			super.x = (_frameX + _currentOffset.x) * _timeMultiplier;
			super.y = (_frameY + _currentOffset.y) * _timeMultiplier;
		}
		
		
		public function play(controller:TickController = null, fps:int = 0):void {
			if (_isPlaying)
				return;
			_isPlaying = true;
			gotoAndPlay(_currentFrameNumber, controller, fps);
		}
		
		
		public function nextFrame():void {
			if (++_currentFrameNumber == _totalFrames) {
				if (repeat) {
					_currentFrameNumber = 0;
				} else {
					_currentFrameNumber = _totalFrames;
				}
			}
			_renderFrame();
		}
		
		
		public function prevFrame():void {
			if (--_currentFrameNumber < 0) {
				if (repeat) {
					_currentFrameNumber += _totalFrames;
				} else {
					_currentFrameNumber = _backframe;
				}
			}
			_renderFrame();
		}
		
		
		public function stop():void {
			if (!_isPlaying)
				return;
			_isPlaying = false;
			if (_controller) {
				_controller.removeObject(this);
				_controller = null;
			}
		}
		
		
		public function gotoAndPlay(frame:int, controller:TickController = null, fps:int = 0):void {
			_isPlaying = true;
			_currentFrameNumber = frame;
			_renderFrame();
			if (controller) {
				controller.addObject(fps);
				_controller = this;
			}
		}
		
		
		public function gotoAndStop(frame:int):void {
			_isPlaying = false;
			_currentFrameNumber = frame;
			_renderFrame();
			stop();
		}
		
		
		public function clone():void {
			var asprite:SpriteSheet = new SpriteSheet();
			asprite._materials = new Vector.<BitmapData>().concat(_materials);
			for each (var offset:FrameOffset in _offsets) {
				asprite._offsets = offset.clone();
			}
		}
		
		
		override public function get x():Number {
			return _frameX;
		}
		
		
		override public function set x(value:Number):void {
			_frameX = value;
			super.x = (value + _currentOffset.x);
		}
		
		
		override public function get y():Number {
			return _frameY;
		}
		
		
		override public function set y(value:Number):void {
			_frameY = value;
			super.y = (value + _currentOffset.y);
		}
		
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		
		public function get timeMultiplyer():Number {
			return _timeMultiplier;
		}
		
		
		public function set timeMultiplyer(value:Number):void {
			_timeMultiplier = value;
		}
		
		
		public function destroy(recycle:Recycler):void {
			stop();
			if (recycle) {
				recycle.dump(this, SpriteSheet);
			}
		}
	
	}

}

class FrameOffset {
	
	public var y:int;
	
	public var x:int;
	
	public function FrameOffset(x:int, y:int) {
		this.y = y;
		this.x = x;
	
	}
	
	
	public function clone():void {
		return new FrameOffset(x, y);
	}
}