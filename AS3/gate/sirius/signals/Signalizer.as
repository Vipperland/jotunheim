package gate.sirius.signals {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class Signalizer implements ISignalizer {
		
		protected var signals:ISignalizer = new SignalDispatcher(this);
		
		public function Signalizer() {
		
		}
		
		/* INTERFACE gate.sirius.signals.ISignalizer */
		
		public function get author():Object {
			return signals.author;
		}
		
		public function hold(name:String, handler:Function):void {
			signals.hold(name, handler);
		}
		
		public function push(... rest:Array):void {
			signals.push.apply(signals, rest);
		}
		
		public function release(name:String, handler:Function):void {
			signals.release(name, handler);
		}
		
		public function send(signal:Signal):void {
			signals.send(signal);
		}
		
		public function reset():void {
			signals.reset();
		}
		
		public function dispose():void {
			signals.dispose();
			signals = null;
		}
	
	}

}