package sirius.tools;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IAgent {
	// Version of Internet Explorer
	public var ie:UInt;
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
	// Is eXtra Small resolution
	public var xs:Bool;
	// Is SMall resolution
	public var sm:Bool;
	// Is MeDium resolution
	public var md:Bool;
	// Is LarGe resolution
	public var lg:Bool;
	// Update all definitions
	public function update(?handler:Dynamic):IAgent;
	
}