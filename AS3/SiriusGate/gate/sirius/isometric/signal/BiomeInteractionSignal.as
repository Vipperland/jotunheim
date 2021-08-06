package gate.sirius.isometric.signal {
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import gate.sirius.isometric.math.low.Bit;
	import gate.sirius.isometric.math.low.BitIO;
	import gate.sirius.isometric.matter.BiomeMatter;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class BiomeInteractionSignal extends BiomeSignal {
		
		private var _matter:BiomeMatter;
		
		private var _phase:uint;
		
		private var _event:MouseEvent;
		
		private var _drag:Boolean;
		
		private var _scroll:int;
		
		private var _buttom:uint;
		
		private var _startPoint:Point;
		
		private var _endPoint:Point;
		
		private var _image:Bitmap;
		
		
		public function BiomeInteractionSignal() {
			super(_constructor);
		}
		
		
		private function _constructor(matter:BiomeMatter, phase:uint, drag:Boolean, event:MouseEvent, buttom:uint = 0, scroll:int = 0, startPoint:Point = null, endPoint:Point = null, image:Bitmap = null, mode:int = 0):void {
			_image = image;
			_endPoint = endPoint.clone();
			_startPoint = startPoint.clone();
			_scroll = scroll;
			_drag = drag;
			_event = event;
			_buttom = buttom;
			_phase = phase;
			_matter = matter;
		}
		
		
		public function get matter():BiomeMatter {
			return _matter;
		}
		
		
		public function get phase():uint {
			return _phase;
		}
		
		
		public function get event():MouseEvent {
			return _event;
		}
		
		
		public function get stage():Stage {
			return _event.currentTarget as Stage;
		}
		
		
		public function get drag():Boolean {
			return _drag;
		}
		
		public function get scroll():int {
			return _scroll;
		}
		
		
		public function get startPoint():Point {
			return _startPoint;
		}
		
		
		public function get endPoint():Point {
			return _endPoint;
		}
		
		
		public function get movementX():Number {
			return _endPoint.x - _startPoint.x;
		}
	
		public function get movementY():Number {
			return _endPoint.y - _startPoint.y;
		}
		
		public function get totalMovement():Number {
			return Point.distance(_endPoint, _startPoint);
		}
		
		public function get image():Bitmap {
			return _image;
		}
		
		public function get isLeftClick():Boolean {
			return BitIO.test(_buttom, Bit.P01);
		}
		
		public function get isMidClick():Boolean {
			return BitIO.test(_buttom, Bit.P02);
		}
		
		public function get isRightClick():Boolean {
			return BitIO.test(_buttom, Bit.P03);
		}
		
		override public function dispose(recyclable:Boolean):void {
			_matter = null;
			_event = null;
			super.dispose(recyclable);
		}
		
		
		public function toString():String {
			return "[BiomeInteractionSignal matter=" + matter + " phase=" + phase + " event=" + event + " stage=" + stage + " drag=" + drag + " buttom=" + _buttom + " scroll=" + scroll + "]";
		}
	
	}

}