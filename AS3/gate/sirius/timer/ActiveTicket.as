package gate.sirius.timer {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class ActiveTicket implements IActiveObject {
		
		private var _elapsedTime:Number;
		private var _fps:uint;
		private var _ticker:IActiveController;
		
		public function ActiveTicket(fps:uint = 30) {
			_fps = fps;
		}
		
		public function dispose():void {
			if (_ticker) {
				disconnect();
			}
		}
		
		private function disconnect():void {
			if (_ticker) {
				_ticker.unregister(this);
				_ticker = null;
			}
		}
		
		private function connect(ticker:IActiveController):void {
			disconnect();
			if (ticker) {
				ticker.register(this, _fps);
			}
		}
		
		public function resetTimer():void {
			_elapsedTime = 0;
		}
		
		public function get fps():uint {
			return _fps;
		}
		
		public function set fps(value:uint):void {
			_fps = value;
			if (_ticker) {
				connect(_ticker);
			}
		}
		
		public function get isConnected():Boolean {
			return _ticker !== null;
		}
		
		public function get elapsedTime():Number {
			return _elapsedTime;
		}
		
		public function get timer():IActiveController {
			return _ticker;
		}
		
		/* INTERFACE gate.sirius.timer.IActiveObject */
		
		public function tick(time:Number):void {
			_elapsedTime += time;
		}
		
		public function onActivate(ticker:IActiveController):void {
			_ticker = ticker;
			_isConnected = true;
		}
		
		public function onDeactivate(ticker:IActiveController):void {
			_ticker = null;
			_isConnected = false;
		}
	
	}

}