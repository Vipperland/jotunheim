package jotun.events;
import jotun.dom.Displayable;
import jotun.events.Dispatcher;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_Event")
class Event implements Activation {
	
	/** Current Dispatcher */
	public var from:Dispatcher;
	
	/** Current Ticket */
	public var ticket:EventGroup;
	
	/** Current Target */
	public var target:Displayable;
	
	/** Original object Event */
	public var event:js.html.Event;
	
	private var _current:Displayable;
	
	/**
	 * Create a custom EVT constroller
	 * @param	from
	 * @param	ticket
	 * @param	event
	 */
	public function new(from:Dispatcher, ticket:EventGroup, event:js.html.Event) {
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
	
	public function current():Displayable {
		if (_current == null){
			_current = Utils.displayFrom(cast event.currentTarget);
		}
		return _current;
	}
	
}