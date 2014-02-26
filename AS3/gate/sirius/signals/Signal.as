package gate.sirius.signals
{
	
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class Signal
	{
		
		internal var _from:SignalDispatcher;
		
		private var _name:String;
		
		public function Signal(name:String)
		{
			_name = name;
		}
		
		/**
		 * The signal name
		 */
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * The current dispatcher
		 */
		public function get from():SignalDispatcher
		{
			return _from;
		}
	
	}

}