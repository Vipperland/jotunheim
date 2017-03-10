package sirius.dom;

import haxe.Constraints.Function;
import haxe.ds.Either;
import js.html.CSSStyleDeclaration;
import js.html.DOMRect;
import js.html.Element;
import js.JQuery;
import sirius.data.IDataSet;
import sirius.dom.IDisplay;
import sirius.events.IDispatcher;
import sirius.math.IARGB;
import sirius.math.IPoint;
import sirius.net.IProgress;
import sirius.net.IRequest;
import sirius.utils.ITable;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IDisplay {
	
	/**
	 * Uniq data carrier
	 */
	public var data : IDataSet;
	
	/**
	 * Default target element
	 */
	public var element : Element;
	
	/**
	 * Custom Event Dispatcher
	 */
	public var events : IDispatcher;
	
	/**
	 * Check if a selector exists
	 * @return
	 */
	public function exists(q:String):Bool;
	
	/**
	 * Enable pointer events
	 * @return
	 */
	public function enable(?button:Bool):IDisplay;
	
	/**
	 * Disable pointer events
	 * @return
	 */
	public function disable():IDisplay;
	
	/**
	 * Query select on children
	 * @param	q
	 * @return
	 */
	public function all(q:String):ITable;
	
	/**
	 * Get first child element
	 * @param	q
	 * @return
	 */
	public function one(q:String):IDisplay;
	
	/**
	 * Get all child elements
	 * @return
	 */
	public function children():ITable;
	
	/**
	 * Add custom classes from string
	 * @param	styles
	 * @return
	 */
	public function css(?styles:String):String;
	
	/**
	 * 
	 * @param	name
	 * @return
	 */
	public function hasCss(name:String):Bool;
	
	/**
	 * Mirror element view
	 * @return
	 */
	public function mirror(x:Bool, y:Bool):IDisplay;
	
	/**
	 * Current child index or -1 if not added
	 * @return
	 */
	public function index():Int;
	
	/**
	 * Get the element index in DOM
	 * @param	q
	 * @return
	 */
	public function indexOf(q:IDisplay):Int;
	
	/**
	 * Append a child to display list
	 * @param	q
	 * @return
	 */
	public function addChild(q:IDisplay, ?at:Int = -1):IDisplay;
	
	/**
	 * Append a list of children
	 */
	public function addChildren(q:ITable, ?at:Int = -1):IDisplay;
	
	/**
	 * Add a text content to element
	 * @param	q
	 * @return
	 */
	public function addText(q:String):IDisplay;
	
	/**
	 * Remove child from container
	 * @param	q
	 * @return
	 */
	public function removeChild(q:IDisplay):IDisplay;
	
	/**
	 * Remove from parent container
	 * @return
	 */
	public function remove():IDisplay;
	
	/**
	 * Parent container, can go up to any available level until reach document element
	 * @param	levels
	 * @return
	 */
	public function parent(levels:UInt=0):IDisplay;
	
	/**
	 * Get child by index
	 * @param	i
	 * @param	update
	 * @return
	 */
	public function getChild(i:Int, ?update:Bool):IDisplay;
	
	/**
	 * Current element scroll offset
	 * @param	o
	 * @return
	 */
	public function getScroll(?o:Dynamic = null):Dynamic;
	
	/**
	 * Children count
	 * @return
	 */
	public function length():Int;
	
	/**
	 * Set cursor style to pointer
	 */
	public function cursor(?value:String):String;
	
	/**
	 * Remove hidden attribute from element
	 */
	public function show():Void;
	
	/**
	 * Add hidden attribute to element
	 */
	public function hide():Void;
	
	/**
	 * Sirius DOM id
	 */
	public function id():UInt;
	
	/**
	 * Shared component data
	 * @return
	 */
	public function initData():IDataSet;
	
	/**
	 * Check if element have an attribute
	 * @param	name
	 * @return
	 */
	public function hasAttribute(name:String):Bool;
	
	/**
	 * Get and/or set an element attribute
	 * @param	name
	 * @param	value
	 * @return
	 */
	public function attribute(name:String, ?value:Dynamic):Dynamic;
	
	/**
	 * Write a list of attributes to object and return a data copy
	 * @param	values
	 * @return
	 */
	public function attributes(?values:Dynamic):Dynamic;
	
	/**
	 * Crop an attribute from element and return it
	 * @param	name
	 * @return
	 */
	public function clearAttribute(name:String):Dynamic;
	
	/**
	 * Write InnerText or InnerHTML properties
	 * @param	q
	 * @param	plainText
	 */
	public function write(q:Dynamic, ?plainText:Bool = false):IDisplay;
	
	/**
	 * Fit element in current viewport width and height
	 */
	public function enlarge():IDisplay;
	
	/**
	 * Write or get style of the element
	 * @param	p
	 * @param	v	Can accept ARGB
	 * @return	Return IARGB if is a color property
	 */
	public function style(?p:Dynamic, ?v:Dynamic):Dynamic;
	
	/**
	 * Get computed style
	 * @return
	 */
	public function trueStyle():CSSStyleDeclaration;
	
	/**
	 * Write a html content or a module
	 * @param	q
	 * @return
	 */
	public function mount(q:String, ?data:Dynamic, ?at:Int = -1):IDisplay;
	
	
	/**
	 * Remove all elements or set innerHTML to empty
	 * @param	fast		Use innerHtml='' instead of remove each element
	 * @return
	 */
	public function clear(?fast:Bool):IDisplay;
	
	/**
	 * Add an Event type
	 * @param	type
	 * @param	handler
	 * @param	mode
	 * @return
	 */
	public function on(type:String, handler:Dynamic, ?mode:Dynamic):IDisplay;
	
	/**
	 * Applies a fade tween
	 * @param	value
	 * @param	time
	 * @return
	 */
	public function fadeTo(value:Float, time:Float = 1):IDisplay;
	
	/**
	 * Transiction to target
	 * @param	time
	 * @param	target
	 * @param	ease
	 * @param	complete
	 */
	public function tweenTo(time:Float = 1, target:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay;
	
	/**
	 * Transiction from target
	 * @param	time
	 * @param	target
	 * @param	ease
	 * @param	complete
	 */
	public function tweenFrom(time:Float = 1, target:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay;
	
	/**
	 * Transiction from target to target
	 * @param	time
	 * @param	from
	 * @param	to
	 * @param	ease
	 * @param	complete
	 */
	public function tweenFromTo(time:Float = 1, from:Dynamic, to:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay;
	
	/**
	 * Add a 30FPS call handler
	 * @param	handler
	 * @return
	 */
	public function activate(handler:Dynamic):IDisplay;
	
	/**
	 * Remove a 30FPS call handler
	 * @param	handler
	 * @return
	 */
	public function deactivate(handler:Dynamic):IDisplay;
	
	/**
	 * 
	 * @param	value
	 * @return
	 */
	public function x(?value:Dynamic):Int;
	
	/**
	 * 
	 * @param	value
	 * @return
	 */
	public function y(?value:Dynamic):Int;
	
	/**
	 * Change WIDTH of Element
	 * @param		value
	 * @return		Client width
	 */
	public function width(?value:Dynamic):Int;
	
	/**
	 * Change HEIGHT of Element
	 * @param		value
	 * @return		Client height
	 */
	public function height(?value:Dynamic):Int;
	
	/**
	 * Set width & height
	 * @param	width
	 * @param	height
	 * @return
	 */
	public function fit(width:Dynamic, height:Dynamic):IDisplay;
	
	/**
	 * Set overflow mode
	 * @param	mode
	 * @return	Current overflow
	 */
	public function overflow(?mode:String):String;
	
	/**
	 * Set opacity
	 * @param	value
	 * @return
	 */
	public function alpha(?value:Float):Float;
	
	/**
	 * Check if all element bounds fit into viewport
	 * @return
	 */
	public function isFullyVisible():Bool;
	
	/**
	 * Check if element is partially visible into viewport
	 * @return
	 */
	public function getVisibility(?offsetY:Int = 0, ?offsetX:Int = 0):UInt;
	
	/**
	 * Type of element
	 * @return
	 */
	public function typeOf():String;
	
	/**
	 * If Type match a Tag Name or Class Name
	 * @param	tag
	 * @return
	 */
	public function is(tag:Either<String,Array<String>>):Bool;
	
	/**
	 * Add this to a target element or Body if target is null
	 * @param	target
	 * @return
	 */
	public function addTo(?target:IDisplay):IDisplay;
	
	/**
	 * Add this to Body element
	 * @return
	 */
	public function addToBody():IDisplay;
	
	/**
	 * True position in DOM
	 * @return
	 */
	public function position():IPoint;
	
	public function getBounds():DOMRect;
	
	/**
	 * Enable or Disable pointer interaction
	 * @param	value
	 * @return
	 */
	public function mouse(?value:Bool):Bool;
	
	/**
	 * Change display backgroud
	 * @param	value
	 * @param	repeat
	 * @param	position
	 * @param	attachment
	 * @return
	 */
	public function bg(?data:Either<String,IARGB>, ?repeat:String, ?position:String, ?attachment:String, ?size:String):String;
	
	/**
	 * Clear all object data
	 */
	public function dispose():Void;
	
	/**
	 * Load and write a module in target
	 * @param	url
	 * @param	module
	 * @param	data
	 * @param	handler
	 */
	public function load(url:String, module:String, ?data:Dynamic, ?handler:IRequest->Void, ?headers:Dynamic, ?progress:IProgress->Void):Void;
	
	/**
	 * Scroll document for display visibility
	 * @param	time
	 * @param	ease
	 * @param	x
	 * @param	y
	 * @return
	 */
	public function lookFor(?time:Float, ?ease:Dynamic, ?x:Int, ?y:Int):IDisplay;
	
	/**
	 * Re-run all external loaded scripts
	 */
	public function rebuild():Void;
	
	/**
	 * Display info in Sirius style
	 * @return
	 */
	public function toString():String;
	
}