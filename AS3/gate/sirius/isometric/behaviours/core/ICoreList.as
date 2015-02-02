package gate.sirius.isometric.behaviours.core {
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface ICoreList {
		
		function help(type:String):String;
		
		function register(id:String, type:Class, help:String):void;
		
		function create(id:String, type:String, ... args:Array):ICoreElement;
	
	}

}