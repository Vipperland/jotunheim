package sirius.events;
import sirius.dom.IDisplay;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IEventGroup {
	
	public var dispatcher : IDispatcher;
	
	public var name : String;
	
	public var events : Array<Dynamic>;
	
	public var enabled : Bool;
	
	public var propagation : Bool;
	
	function add (handler:Dynamic, ?capture:Bool) : IEventGroup;
	
	function remove (handler:Dynamic) : IEventGroup;
	
	function prepare (t:IDisplay) : IEventGroup;
	
	function cancel () : IEventGroup;
	
	function preventDefault():Void;
	
	function reset():IEventGroup;
	
	function call():IEventGroup;
	
}