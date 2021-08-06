package gate.sirius.signals {
	/**
	 * ...
	 * @author Rafael Moreira
	 */
	public class DynamicSignals {
		
		private var _author:Object;
		
		public function DynamicSignals(author:Object) {
			_author = author;
		}
		
		public function custom(name:String):ISignalDispatcher {
			return (this[name] ||= new SignalDispatcher(_author));
		}
		
	}

}