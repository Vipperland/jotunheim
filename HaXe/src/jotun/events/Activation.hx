package jotun.events;
import jotun.dom.Displayable;
import jotun.events.Dispatcher;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface Activation {
	
	/// Current Dispatcher (DISP)
	public var from : Dispatcher;

	/// Current Ticket (IDISPg)
	public var ticket : EventGroup;
	
	// Current Target
	public var target : Displayable;

	/// Original object Event
	public var event : js.html.Event;
	
	/// Cancel original Event propagation and default behaviour
	public function cancel():Void;
	
	/// Event description
	public function description():String;
	
	/// 
	public function current():Displayable;
}