package jotun.gaming.actions;

/**
 * @author Rim Project
 */
interface IEventContext {
	public var debug:Bool;
	public var name:String;
	public var log:Array<String>;
	public var ident:Int;
	public var chain:Int;
	public var ticks:Int;
	public var origin:Dynamic;
	public var parent:IEventContext;
	public var action:String;
	public var requirement:String;
	public var history:Array<Action>;
}