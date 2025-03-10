package jotun.utils;

/**
 * @author Rafael Moreira
 */

interface IDiceRoll {
	// Current object
	public var object:Dynamic;
	// Last param
	public var param:Dynamic;
	// Last Value
	public var value:Dynamic;
	// Loop Completed
	public var completed:Bool;
	// Looping count
	public var keys:Int;
	// Count start
	public var from:Int;
	// Count target
	public var to:Int;
	// Count last value
	public var end:Dynamic;
	// Found children
	public var children:Array<Dynamic>;
}