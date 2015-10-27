package sirius.modules;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IMod {
	public var id:String;
	public var name:String;
	public var target:String;
	public var require:String;
	public var filler:String;
	public var repeat:String;
	public var type:String;
	public var version:String;
}