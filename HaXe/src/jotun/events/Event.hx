package jotun.events;
import jotun.dom.IDisplay;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_Event")
class Event implements IEvent {
	
	/** Current Dispatcher */
	public var from:IDispatcher;
	
	/** Current Ticket */
	public var ticket:IEventGroup;
	
	/** Current Target */
	public var target:IDisplay;
	
	/** Original object Event */
	public var event:js.html.Event;
	
	private var _current:IDisplay;
	
	/**
	 * Create a custom EVT constroller
	 * @param	from
	 * @param	ticket
	 * @param	event
	 */
	public function new(from:IDispatcher, ticket:IEventGroup, event:js.html.Event) {
		this.event = event;
		this.ticket = ticket;
		this.from = from;
		this.target = from.target;
	}
	
	public function cancel():Void {
		if (event != null) {
			event.stopPropagation();
			event.stopImmediatePropagation();
			event.preventDefault();
		}
	}
	
	public function description():String {
		return "[Event{name:" + ticket.name + ",target:" + from.target.typeOf() + "}]";
	}
	
	public function current():IDisplay {
		if (_current == null){
			_current = Utils.displayFrom(cast event.currentTarget);
		}
		return _current;
	}
	
}