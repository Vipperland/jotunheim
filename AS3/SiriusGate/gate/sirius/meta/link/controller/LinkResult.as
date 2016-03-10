package gate.sirius.meta.link.controller {
	import gate.sirius.meta.link.errors.SharedAppError;
	
	/**
	 * ...
	 * @author Rafael Moreira (GateOfSirius)
	 */
	public class LinkResult {
		
		private var _errors:Vector.<SharedAppError>;
		private var _loaded:Boolean;
		
		
		public function LinkResult(errors:Vector.<SharedAppError>) {
			_errors = errors;
			_loaded = errors.length == 0;
		}
		
		
		public function get errors():Vector.<SharedAppError> {
			return _errors;
		}
		
		
		public function get isLoaded():Boolean {
			return _loaded;
		}
	
	}

}