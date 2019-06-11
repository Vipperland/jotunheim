package jotun.tools;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IAgent {
	// Version of Internet Explorer
	public var ie:Bool;
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
	
	public var cookies:Bool;
	// Is JQuery available?
	public var jQuery:Bool;
	// Is any tween framework (GSAP like) active?
	public var animator:Bool;
	// Display info
	public var display:String;
	// Is eXtra Small resolution
	public var xs:Bool;
	// Is SMall resolution
	public var sm:Bool;
	// Is MeDium resolution
	public var md:Bool;
	// Is LarGe resolution
	public var lg:Bool;
	// Screen size level (0 to 4)
	public var screen:Int;
	// User Operating System name
	public var os:String;
	// Update all definitions
	public function update():IAgent;
	
	public function value():String;
	
}