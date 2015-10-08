package sirius.utils;
import js.html.Element;
import sirius.dom.IDisplay;
import sirius.events.IEvent;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface ITable {
	
	/**
	 * List of Sirius Display object
	 */
	public var content:Array<IDisplay>;
	
	/**
	 * List of DOM elements
	 */
	public var elements:Array<Element>;
	
	/**
	 * Return all elements with contains a specific value
	 * @param	q
	 * @return
	 */
	public function contains(q:String) : ITable;
	
	/**
	 * Run a method on each element with Dice.Values(h,c)
	 * @param	h
	 * @param	c
	 * @return
	 */
	public function flush(handler:IDisplay->Void, ?complete:IDiceRoll->Void) : ITable;
	
	/**
	 * Get the first element
	 * @return
	 */
	public function first() : IDisplay;
	
	/**
	 * Get the last element
	 * @return
	 */
	public function last() : IDisplay;
	
	/**
	 * Get an element by index
	 * @param	i
	 * @return
	 */
	public function obj(i:Int) : IDisplay;
	
	/**
	 * Add a selector to each element
	 * @param	styles
	 * @return
	 */
	public function css(styles:String) : ITable;
	
	/**
	 * Set the attribute value to all children
	 * @param	name
	 * @param	value
	 * @return
	 */
	public function attribute(name:String, value:String) : ITable;
	
	/**
	 * Set attributes values to all children
	 * @param	name
	 * @param	value
	 * @return
	 */
	public function attributes(value:Dynamic) : ITable;
	
	/**
	 * Set hidden attribute to false in all elements
	 * @return
	 */
	public function show () : ITable;
	
	/**
	 * Set hidden attribute to true in all elements
	 * @return
	 */
	public function hide () : ITable;
	
	/**
	 * Remove all elements from parent element
	 * @return
	 */
	public function remove () : ITable;

	/**
	 * Set the cursor of all elements
	 * @param	value
	 * @return
	 */
	public function cursor (value:String) : ITable;
	
	/**
	 * Set position to relative in all elements
	 * @return
	 */
	public function detach () : ITable;

	/**
	 * Set position to absolute in all elements
	 * @return
	 */
	public function attach () : ITable;
	
	/**
	 * Set position to fixed in all elements
	 * @return
	 */
	public function pin () : ITable;

	/**
	 * Remove all children from all elements in table
	 * @param	fast
	 * @return
	 */
	public function clear (?fast:Bool) : ITable;

	/**
	 * Append elements to a target
	 * @param	target
	 * @return
	 */
	public function addTo (?target:IDisplay) : ITable;
	
	/**
	 * Append all elements to body
	 * @return
	 */
	public function addToBody () : ITable;
	
	/**
	 * Run a method to each element Dice.Values(h)
	 * @param	handler
	 * @return
	 */
	public function each(handler:IDisplay->Void) : ITable;
	
	/**
	 * Current content count
	 * @return
	 */
	public function length () : Int;
	
	/**
	 * Call a method in each content element
	 * @param	method
	 * @param	args
	 * @return
	 */
	public function call(method:String, ?args:Array<Dynamic>) : ITable;
	
	/**
	 * Add event to all table elements
	 * @param	name
	 * @param	handler
	 * @param	capture
	 * @return
	 */
	public function on(name:String, handler:IEvent->Void, ?mode:String) : ITable;
	
	/**
	 * Join one or more Tables in one or clone current Table
	 * @param	tables
	 * @return
	 */
	public function merge (?tables:Array<Table>) : ITable;
	
	/// Event
	public function onWheel (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onCopy (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onCut (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPaste (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onAbort (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onBlur (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onFocusIn (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onFocusOut (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onCanPlay (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onCanPlayThrough (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onChange (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onClick (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onContextMenu (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDblClick (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDrag (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragEnd (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragEnter (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragLeave (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragOver (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragStart (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDrop (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDurationChange (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onEmptied (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onEnded (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onInput (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onInvalid (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onKeyDown (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onKeyPress (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onKeyUp (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onLoad (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onLoadedData (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onLoadedMetadata (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onLoadStart (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseDown (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseEnter (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseLeave (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseMove (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseOut (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseOver (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseUp (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPause (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPlay (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPlaying (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onProgress (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onRateChange (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onReset (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onScroll (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onSeeked (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onSeeking (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onSelect (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onShow (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onStalled (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onSubmit (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onSuspend (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onTimeUpdate (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onVolumeChange (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onWaiting (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerCancel (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerDown (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerUp (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerMove (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerOut (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerOver (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerEnter (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerLeave (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onGotPointerCapture (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onLostPointerCapture (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerLockChange (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerLockError (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onError (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchStart (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchEnd (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchMove (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchCancel (?handler:IEvent->Void, ?mode:Dynamic) : ITable;
	
	/// Event
	public function onVisibility(?handler:IEvent->Void, ?mode:Dynamic):ITable;
	
}