package jotun.gaming.actions;
import haxe.DynamicAccess;
import jotun.gaming.actions.IDataProvider;
/**
 * @author Rim Project
 */
interface IEventDispatcher {
	/**
	 * Available event collection
	 */
	public var events:DynamicAccess<Spells>;
	
	public function setDebug(mode:Bool):Void;
	
	public function call(name:String, ?data:Dynamic, ?provider:IDataProvider):Bool;
	
}