package jotun.tools;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IAgent {
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
	// Display info
	public var display:String;
	// User Operating System name
	public var os:String;
	
	public function isXS():Bool;
	
	public function isSM():Bool;
	
	public function isMD():Bool;
	
	public function isLG():Bool;
	
	public function isXL():Bool;
	
	// Update all definitions
	public function update():IAgent;
	
	public function value():String;
	
}