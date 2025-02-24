package jotun.gaming.actions;
import haxe.DynamicAccess;
import jotun.gaming.actions.IDataProvider;
/**
 * @author Rim Project
 */
interface ISpellInvocation {
	/**
	 * Available event collection
	 */
	public var events:DynamicAccess<SpellGroup>;
	
	public function setDebug(mode:Bool):Void;
	
	public function invoke(name:String, ?data:Dynamic, ?provider:IDataProvider):Bool;
	
}