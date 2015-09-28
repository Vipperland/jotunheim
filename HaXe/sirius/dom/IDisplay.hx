package sirius.dom;

import haxe.Constraints.Function;
import js.html.CSSStyleDeclaration;
import js.html.Element;
import js.JQuery;
import sirius.data.DisplayData;
import sirius.dom.IDisplay;
import sirius.events.IDispatcher;
import sirius.utils.ITable;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface IDisplay {
	
	/**
	 * Uniq data carrier
	 */
	public var data : DisplayData;
	
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
	 * Enable Specifiq events shortcuts
	 * @param	q
	 * @return
	 */
	public function enable(q:Array<Dynamic>):IDisplay;
	
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
	public function addChildren(q:ITable):IDisplay;
	
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
	 * Set position style to absolute
	 */
	public function detach():Void;
	
	/**
	 * Set position style to relative
	 */
	public function attach():Void;
	
	/**
	 * Set position style to fixed
	 */
	public function pin():Void;
	
	/**
	 * Remove hidden attribute from element
	 */
	public function show():Void;
	
	/**
	 * Add hidden attribute to element
	 */
	public function hide():Void;
	
	
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
	public function attribute(name:String, ?value:String):String;
	
	/**
	 * Write a list of attributes to object
	 * @param	values
	 * @return
	 */
	public function attributes(values:Dynamic):IDisplay;
	
	/**
	 * Write InnerText or InnerHTML properties
	 * @param	q
	 * @param	plainText
	 */
	public function build(q:String, ?plainText:Bool = false):IDisplay;
	
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
	 * Append a value to innerHTML value
	 * @param	module
	 * @return
	 */
	public function write(q:String):IDisplay;
	
	
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
	 * Change WIDTH of Element
	 * @param		value
	 * @param		pct
	 * @return		Client width
	 */
	public function width(?value:Float, ?pct:Bool):Float;
	
	/**
	 * Change HEIGHT of Element
	 * @param		value
	 * @param		pct
	 * @return		Client height
	 */
	public function height(?value:Float, ?pct:Bool):Float;
	
	/**
	 * Set width & height
	 * @param	width
	 * @param	height
	 * @param	pct
	 * @return
	 */
	public function fit(width:Float, height:Float, ?pct:Bool):IDisplay;
	
	/**
	 * Set overflow mode
	 * @param	mode
	 * @return	Current overflow
	 */
	public function overflow(?mode:String):String;
	
	/**
	 * Check if all element bounds fit into viewport
	 * @return
	 */
	public function isFullyVisible():Bool;
	
	/**
	 * Check if element is partially visible into viewport
	 * @return
	 */
	public function isVisible():Bool;
	
	/**
	 * Hidden attribute value
	 * @return
	 */
	public function isHidden():Bool;
	
	/**
	 * Return Element as JQuery object structure
	 * @return
	 */
	public function jQuery():JQuery;
	
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
	public function is(tag:String):Bool;
	
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
	 * Align center
	 */
	public function alignCenter():Void;
	
	/**
	 * Float left
	 */
	public function alignLeft():Void;
	
	/**
	 * Float right
	 */
	public function alignRight():Void;
	
	/**
	 * Change display backgroud
	 * @param	value
	 * @param	repeat
	 * @param	position
	 * @param	attachment
	 * @return
	 */
	public function background(?value:Dynamic, ?repeat:String, ?position:String, ?attachment:String):String;
	
}