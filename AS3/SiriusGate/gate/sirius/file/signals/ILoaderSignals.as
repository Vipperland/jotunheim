package gate.sirius.file.signals {
	import gate.sirius.signals.ISignalDispatcher;
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface ILoaderSignals {
		
		function get LOAD_ERROR():ISignalDispatcher;
		
		function get LOAD_COMPLETE():ISignalDispatcher;
		
		function get LOAD_PROGRESS():ISignalDispatcher;
		
		function get LOAD_START():ISignalDispatcher;
		
		function get FILE_LOADED():ISignalDispatcher;
		
		function dispose():void;
		
	}

}