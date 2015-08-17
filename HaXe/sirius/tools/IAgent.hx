package sirius.tools;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IAgent {
	// Version of Internet Explorer
	public var ie:Dynamic;
	// Is Edge?
	public var edge:Bool;
	// Is Opera?
	public var opera:Bool;
	// Is Firefox?
	public var firefox:Bool;
	// Is Safari?
	public var safari:Bool;
	// Is Chrome?
	public var chrome:Bool;
	// Is a mobile version?
	public var mobile:Bool;
	// Is JQuery available?
	public var jQuery:Bool;
	// Is any tween framework (GSAP like) active?
	public var animator:Bool;
	// Display info
	public var display:String;
	
}