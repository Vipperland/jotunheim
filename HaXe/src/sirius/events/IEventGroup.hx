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
	
	public var data:Dynamic;
	
	public function add (handler:IEvent->Void, ?capture:Bool) : IEventGroup;
	
	public function remove (handler:IEvent->Void) : IEventGroup;
	
	public function prepare (t:IDisplay) : IEventGroup;
	
	public function dispose(t:IDisplay):Void;
	
	public function cancel () : IEventGroup;
	
	public function noDefault():IEventGroup;
	
	public function reset():IEventGroup;
	
	public function call(?bubbles:Bool = false, ?cancelable:Bool = true, ?data:Dynamic = null):IEventGroup;
	
}