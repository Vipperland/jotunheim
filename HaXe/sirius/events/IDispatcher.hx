package sirius.events;
import sirius.dom.IDisplay;

/**
 * @author Rafael Moreira
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
	public function auto (type:String, ?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function wheel (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function copy (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function cut (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function paste (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function abort (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function blur (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function focusIn (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;
	
	/// Event
	public function focusOut (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function canPlay (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function canPlayThrough (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function change (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function click (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function contextMenu (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dblClick (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function drag (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragEnd (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragEnter (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragLeave (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragOver (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function dragStart (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function drop (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function durationChange (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function emptied (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function ended (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function input (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function invalid (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function keyDown (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function keyPress (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function keyUp (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function load (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function loadedData (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function loadedMetadata (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function loadStart (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseDown (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseEnter (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseLeave (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseMove (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseOut (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseOver (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function mouseUp (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pause (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function play (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function playing (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function progress (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function rateChange (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function reset (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function scroll (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function seeked (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function seeking (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function select (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function show (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function stalled (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function submit (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function suspEnd (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function timeUpdate (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function volumeChange (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function waiting (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerCancel (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerDown (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerUp (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerMove (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerOut (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerOver (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerEnter (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerLeave (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function gotPointerCapture (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function lostPointerCapture (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerLockChange (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function pointerLockError (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function error (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function touchStart (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function touchEnd (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function touchMove (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;

	/// Event
	public function touchCancel (?handler:Dynamic, ?mode:Dynamic) : IEventGroup;
	
}
