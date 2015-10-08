package sirius.events;
import sirius.dom.IDisplay;
import sirius.events.IEventGroup;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IDispatcher {
	
	/**
	 * Main Event target
	 */
	public var target : IDisplay;

	/**
	 * Get an Event by Type, create a new one if not exists
	 * @param	name
	 * @param	capture
	 * @return
	 */
	public function event (name:String) : IEventGroup;

	/**
	 * Check if an event type exists
	 * @param	name
	 * @return
	 */
	public function hasEvent (name:String) : Bool;

	/**
	 * Rebuild Element events
	 */
	public function apply () : Void;

	/**
	 * Versatile Init and assign or remove events
	 * @param	type		Type of the event
	 * @param	handler		Handler of event
	 * @param	mode		1 | true | "capture" to Add (capture=true), 0 | false to Add (capture=false), -1 | 'remove' to remove event if exists
	 * @return
	 */
	public function auto (type:String, ?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function wheel (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function copy (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function cut (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function paste (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function abort (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function blur (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function focusIn (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;
	
	/// Event
	public function focusOut (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function canPlay (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function canPlayThrough (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function change (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function click (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function contextMenu (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dblClick (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function drag (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragEnd (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragEnter (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragLeave (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragOver (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragStart (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function drop (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function durationChange (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function emptied (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function ended (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function input (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function invalid (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function keyDown (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function keyPress (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function keyUp (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function load (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function loadedData (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function loadedMetadata (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function loadStart (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseDown (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseEnter (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseLeave (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseMove (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseOut (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseOver (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseUp (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pause (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function play (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function playing (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function progress (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function rateChange (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function reset (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function scroll (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function seeked (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function seeking (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function select (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function show (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function stalled (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function submit (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function suspEnd (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function timeUpdate (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function volumeChange (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function waiting (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerCancel (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerDown (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerUp (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerMove (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerOut (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerOver (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerEnter (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerLeave (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function gotPointerCapture (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function lostPointerCapture (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerLockChange (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerLockError (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function error (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function touchStart (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function touchEnd (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function touchMove (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function touchCancel (?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;
	
	/// Event
	public function readyState(?handler:IEvent->Void, ?mode:Dynamic) : IEventGroup;
	
	/// Event
	public function visibility(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup;
	
	/// Event
	public function resize(?handler:IEvent->Void, ?mode:Dynamic):IEventGroup;
	
	
}
