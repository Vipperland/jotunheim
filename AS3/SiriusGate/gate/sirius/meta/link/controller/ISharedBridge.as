package gate.sirius.meta.link.controller {
	import gate.sirius.meta.link.errors.SharedAppError;
	
	/**
	 * ...
	 * @author Rafael Moreira (GateOfSirius)
	 */
	public interface ISharedBridge {
		
		function get classNames():Array;
		
		function getClass(name:String):Class;
		
		function unloadMemory():void;
		
		function loadMemory():Vector.<SharedAppError>;
	
	}

}