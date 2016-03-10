package gate.sirius.meta.link.errors {
	import gate.sirius.meta.link.ISharedApp;
	/**
	 * ...
	 * @author Rafael Moreira (GateOfSirius)
	 */
	public class SharedAppError extends Error {
		
		private var _app:ISharedApp;
		
		public function SharedAppError(app:ISharedApp, message:String, id:int) {
			super(message, id);
			_app = app;
		}
		
		public function get app():ISharedApp {
			return _app;
		}
		
	}

}