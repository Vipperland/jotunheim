package jotun.gaming.actions;
import haxe.DynamicAccess;
/**
 * @author Rim Project
 */
interface IEventDispatcher {
	/**
	 * Available event collection
	 */
	public var events:DynamicAccess<Events>;
	
	public function setDebug(mode:Bool):Void;
	
	public function call(name:String, ?data:Dynamic):Bool;
	
}