package gate.sirius.timer {
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public interface IActiveController {
		
		function get fps():uint;
		
		function get timeFactor():Number;
		function set timeFactor(value:Number):void;
		
		function start():IActiveController;
		
		function stop():IActiveController;
		
		function register(object:IActiveObject, fps:uint):IActiveController;
		
		function unregister(object:IActiveObject):IActiveController;
		
		function delayedCall(handler:Function, time:int, repeats:int = 0, ... paramaters:Array):void;
		
		function cancelDelayedCall(handler:Function):void;
		
		function cancellAllCalls():void;
	
	}

}