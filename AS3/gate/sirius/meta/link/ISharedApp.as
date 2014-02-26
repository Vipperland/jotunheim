package gate.sirius.meta.link {
	import gate.sirius.meta.link.controller.ISharedBridge;
	import gate.sirius.meta.link.controller.LinkResult;
	
	/**
	 * ...
	 * @author Rafael Moreira (GateOfSirius)
	 */
	public interface ISharedApp {
		
		function checkApplication():LinkResult;
		
		function unloadApplication():void;
		
		function get bridge():ISharedBridge;
		
		function get appid():String;
		
		function get version():int;
	
	}

}