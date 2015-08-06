package sirius.utils;
import js.html.Element;
import sirius.dom.IDisplay;

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
	public function contains(q:String):ITable;
	
	/**
	 * Run a method on each element with Dice.Values(h,c)
	 * @param	h
	 * @param	c
	 * @return
	 */
	public function flush(handler:Dynamic, ?complete:Dynamic):ITable;
	
	/**
	 * Get the first element
	 * @return
	 */
	public function first():IDisplay;
	
	/**
	 * Get the last element
	 * @return
	 */
	public function last():IDisplay;
	
	/**
	 * Get an element by index
	 * @param	i
	 * @return
	 */
	public function obj(i:Int):IDisplay;
	
	/**
	 * Add a selector to each element
	 * @param	styles
	 * @return
	 */
	public function css(styles:String):ITable;
	
	/**
	 * Run a method to each element Dice.Values(h)
	 * @param	handler
	 * @return
	 */
	public function each(handler:Dynamic):ITable;
	
	/**
	 * Current content count
	 * @return
	 */
	public function length ():Int;
	
	/**
	 * Call a method in each content element
	 * @param	method
	 * @param	args
	 * @return
	 */
	public function call(method:String, ?args:Array<Dynamic>):ITable;
	
	/**
	 * Add event to all table elements
	 * @param	name
	 * @param	handler
	 * @param	capture
	 * @return
	 */
	public function on(name:String, handler:Dynamic, ?mode:String):ITable;
	
	/**
	 * Join one or more Tables in one or clone current Table
	 * @param	tables
	 * @return
	 */
	public function merge(?tables:Array<Table>):Table;
	
	/// Event
	public function onWheel (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onCopy (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onCut (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPaste (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onAbort (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onBlur (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onFocusIn (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onFocusOut (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onCanPlay (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onCanPlayThrough (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onChange (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onClick (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onContextMenu (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onDblClick (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onDrag (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragEnd (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragEnter (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragLeave (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragOver (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onDragStart (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onDrop (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onDurationChange (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onEmptied (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onEnded (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onInput (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onInvalid (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onKeyDown (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onKeyPress (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onKeyUp (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onLoad (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onLoadedData (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onLoadedMetadata (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onLoadStart (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseDown (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseEnter (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseLeave (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseMove (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseOut (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseOver (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onMouseUp (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPause (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPlay (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPlaying (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onProgress (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onRateChange (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onReset (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onScroll (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onSeeked (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onSeeking (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onSelect (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onShow (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onStalled (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onSubmit (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onSuspend (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onTimeUpdate (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onVolumeChange (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onWaiting (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerCancel (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerDown (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerUp (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerMove (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerOut (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerOver (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerEnter (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerLeave (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onGotPointerCapture (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onLostPointerCapture (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerLockChange (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onPointerLockError (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onError (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchStart (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchEnd (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchMove (?handler:Dynamic, ?mode:Dynamic) : ITable;

	/// Event
	public function onTouchCancel (?handler:Dynamic, ?mode:Dynamic) : ITable;
	
}