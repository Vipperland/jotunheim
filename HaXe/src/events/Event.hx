package sirius.events;
import sirius.dom.IDisplay;
import sirius.dom.IDisplay3D;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.events.Event")
class Event implements IEvent {
	
	/** Current Dispatcher */
	public var from:IDispatcher;
	
	/** Current Ticket */
	public var ticket:IEventGroup;
	
	/** Current Target */
	public var target:IDisplay;
	
	/** Current Target */
	public var target3d:IDisplay3D;
	
	/** Original object Event */
	public var event:js.html.Event;
	
	
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
		this.target3d = cast from.target;
	}
	
}