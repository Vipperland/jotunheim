package jotun.gaming.actions;

/**
 * @author Rim Project
 */
interface IEventContext implements Dynamic {
	public var log:Array<String>;
	public var ident:Int;
	public var ticks:Int;
	public var origin:Dynamic;
}