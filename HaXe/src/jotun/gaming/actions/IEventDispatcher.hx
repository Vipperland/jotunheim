package jotun.gaming.actions;
/**
 * @author Rim Project
 */
interface IEventDispatcher implements Dynamic {
	/**
	 * Available event collection
	 */
	public var events:Dynamic;
	
	public function setDebug(mode:Bool):Void;
	
	public function call(name:String, ?data:Dynamic):Bool;
	
}