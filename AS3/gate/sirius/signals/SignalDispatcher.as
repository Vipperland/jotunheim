package gate.sirius.signals {
	
	import gate.sirius.isometric.recycler.Recycler;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SignalDispatcher implements ISignalDispatcher {
		
		/** @private */
		private var _author:Object;
		
		/** @private */
		private var _signals:Vector.<Function>;
		
		
		/**
		 * Create a new SignalDispatcher instance
		 * @param	author
		 */
		public function SignalDispatcher(author:Object) {
			this._author = author;
			reset();
		}
		
		/**
		 * Hold a listener
		 * @param	name
		 * @param	handler
		 */
		public function hold(handler:Function):void {
			if (_signals.indexOf(handler) == -1) {
				_signals[_signals.length] = handler;
			}
		}
		
		/**
		 *
		 * @param	... rest
		 */
		public function push(... rest:Array):void {
			for each (var entry:Array in rest) {
				hold.apply(this, entry);
			}
		}
		
		/**
		 * Release a listener
		 * @param	name
		 * @param	handler
		 */
		public function release(handler:Function):void {
			var from:int = _signals.indexOf(handler);
			if (from !== -1) {
				_signals.splice(from, 1);
			}
		}
		
		/**
		 * Send a Signal
		 * @param	signal
		 */
		public function send(Type:Class, recyclable:Boolean = true, ... props:Array):void {
			
			var signal:Signal = Recycler.GATE.collect(Type).content;
			signal._dispatcher = this;
			signal._contructor.apply(signal, props);
			signal._live = true;
			signal._calls = 0;
			
			var ticket:SignalTicket = Recycler.GATE.collect(SignalTicket).content as SignalTicket;
			ticket._signal = signal as ISignal;
			ticket._arguments = props;
			
			for each (var signalHandler:Function in _signals) {
				++signal._calls;
				signalHandler(signal);
				if (!signal._live) {
					break;
				}
			}
			
			SignalReport.GATE._send(ticket);
			
			ticket.dispose();
			ticket = null;
			
			signal.dispose(recyclable);
			signal._dispatcher = null;
		
		}
		
		/**
		 * Remove all Signals
		 */
		public function reset():void {
			_signals = new Vector.<Function>();
		}
		
		/**
		 * Sender Object
		 */
		public function get author():Object {
			return _author;
		}
		
		/**
		 * Destroy instance from memory
		 */
		public function dispose():void {
			_signals = null;
			_author = null;
		}
	
	}

}