package jotun.utils;
import js.html.Element;
import jotun.dom.IDisplay;
import jotun.events.IEvent;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface ITable {
	
	/**
	 * List of Jotun Display object
	 */
	public var content:Array<IDisplay>;
	
	/**
	 * Do a query selector
	 * @param	q
	 * @param	t
	 * @param	h
	 * @return
	 */
	public function scan(q:String, ?t:Element):ITable;
	
	/**
	 * Add a display to the list
	 * @param	obj
	 * @return
	 */
	public function add(obj:IDisplay):ITable;
	
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
	 * Causes all children a reaction for data
	 * @param	data
	 * @return
	 */
	public function react(data:Dynamic):ITable;
	
	/**
	 * Set the style value to all children
	 * @param	p
	 * @param	v
	 * @return
	 */
	public function style(p:Dynamic, v:Dynamic):ITable;
	
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
	public function each(handler:IDisplay->Void, ?onnull:Void->Void) : ITable;
	
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
	public function on(name:String, handler:IEvent->Void, ?mode:Int) : ITable;
	
	/**
	 * Clear all table data
	 * @return
	 */
	public function reset():ITable;
	
	/**
	 * Enable fast Table construction
	 * @return
	 */
	public function dispose():Void;
	
	/**
	 * Join one or more Tables in one or clone current Table
	 * @param	tables
	 * @return
	 */
	public function merge (?tables:Array<Table>) : ITable;
	
	/// Event
	public function onBlur (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onFocusIn (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onFocusOut (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onChange (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onClick (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onDblClick (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onError (?handler:IEvent->Void, ?mode:Dynamic) : ITable;
	
	/// Event
	public function onKeyDown (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onKeyPress (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onKeyUp (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onLoad (?handler:IEvent->Void, ?mode:Dynamic) : ITable;
	
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
	public function onScroll (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchStart (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchEnd (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchMove (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchCancel (?handler:IEvent->Void, ?mode:Dynamic) : ITable;
	
	/// Event
	public function onWheel (?handler:IEvent->Void, ?mode:Dynamic) : ITable;

	/// Event
	public function onVisibility(?handler:IEvent->Void, ?mode:Dynamic) : ITable;
	
}