package jotun.events;
import jotun.dom.IDisplay;
import jotun.events.IEventGroup;

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
	public function on (type:String, ?hanlder:Dynamic, ?mode:Int, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Mouse OVER, OUT and DOWN Events
	public function focusOverall(hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : Dynamic;
	
	/// Event
	public function added (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;
	
	/// Event
	public function removed (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;
	
	/// Event
	public function wheel (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function copy (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function cut (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function paste (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function abort (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function blur (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function focusIn (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;
	
	/// Event
	public function focusOut (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function canPlay (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function canPlayThrough (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function change (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function click (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function contextMenu (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function dblClick (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function drag (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function dragEnd (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function dragEnter (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function dragLeave (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function dragOver (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function dragStart (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function drop (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function durationChange (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function emptied (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function ended (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function input (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function invalid (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function keyDown (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function keyPress (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function keyUp (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function load (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function loadedData (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function loadedMetadata (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function loadStart (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function mouseDown (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function mouseEnter (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function mouseLeave (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function mouseMove (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function mouseOut (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function mouseOver (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function mouseUp (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pause (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function play (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function playing (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function progress (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function rateChange (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function reset (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function scroll (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function seeked (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function seeking (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function select (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function show (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function stalled (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function submit (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function suspEnd (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function timeUpdate (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function volumeChange (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function waiting (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerCancel (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerDown (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerUp (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerMove (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerOut (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerOver (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerEnter (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerLeave (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function gotPointerCapture (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function lostPointerCapture (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerLockChange (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function pointerLockError (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function error (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function touchStart (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function touchEnd (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function touchMove (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;

	/// Event
	public function touchCancel (?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;
	
	/// Event
	public function readyState(?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;
	
	/// Event
	public function visibility(?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;
	
	/// Event
	public function resize(?hanlder:Dynamic, ?mode:Dynamic, ?noDefault:Bool, ?capture:Bool) : IEventGroup;
	
	/// Remove all events
	public function dispose():Void;
		
}
