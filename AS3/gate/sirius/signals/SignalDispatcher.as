package gate.sirius.signals
{
	
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class SignalDispatcher implements ISignalizer
	{
		
		protected var _author:Object;
		
		private var _signals:Dictionary;
		
		private function _getHolder(name:String):Vector.<Function>
		{
			return _signals[name] ||= new Vector.<Function>();
		}
		
		public function SignalDispatcher(author:Object)
		{
			this._author = author;
			reset();
		}
		
		/**
		 * Hold a listener
		 * @param	name
		 * @param	handler
		 */
		public function hold(name:String, handler:Function):void
		{
			_getHolder(name).push(handler);
		}
		
		public function push(... rest:Array):void
		{
			for each (var entry:Array in rest)
			{
				hold(entry[0], entry[1]);
			}
		}
		
		/**
		 * Release a listener
		 * @param	name
		 * @param	handler
		 */
		public function release(name:String, handler:Function):void
		{
			var signals:Vector.<Function> = _getHolder(name);
			var iof:int = signals.indexOf(handler);
			if (iof !== -1)
			{
				signals.splice(iof, 1);
			}
		}
		
		/**
		 * Send a Signal
		 * @param	signal
		 */
		public function send(signal:Signal):void
		{
			signal._from = this;
			var signals:Vector.<Function> = _signals[signal.name];
			for each (var signalHandler:Function in signals)
			{
				signalHandler(signal);
			}
			signal._from = null;
		}
		
		/**
		 * Remove all Signals
		 */
		public function reset():void
		{
			_signals = new Dictionary(true);
		}
		
		/**
		 * Sender Object
		 */
		public function get author():Object
		{
			return _author;
		}
		
		public function dispose():void
		{
			_signals = null;
			_author = null;
		}
	
	}

}