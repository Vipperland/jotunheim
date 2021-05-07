package jotun.modules;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IMod {
	public var id:String;
	public var name:String;
	public var target:String;
	public var require:Array<String>;
	public var inject:String;
	public var type:String;
	public var wrap:String;
	public var data:Dynamic;
	public var index:Int;
}