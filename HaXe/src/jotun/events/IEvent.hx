package jotun.events;
import jotun.dom.IDisplay;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IEvent {
	
	/// Current Dispatcher (DISP)
	public var from : IDispatcher;

	/// Current Ticket (IDISPg)
	public var ticket : IEventGroup;
	
	// Current Target
	public var target : IDisplay;

	/// Original object Event
	public var event : js.html.Event;
	
	/// Cancel original Event propagation and default behaviour
	public function cancel():Void;
	
	/// Event description
	public function description():String;
	
	/// 
	public function current():IDisplay;
}