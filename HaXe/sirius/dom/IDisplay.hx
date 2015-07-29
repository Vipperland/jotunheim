package sirius.dom;

import haxe.Constraints.Function;
import js.html.Element;
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
	public var data : Dynamic;
	
	/**
	 * Default target element
	 */
	public var Self : Element;
	
	/**
	 * The parent container
	 */
	public var parent:IDisplay;
	
	/**
	 * Document Body
	 */
	public var body:Body;
	
	/**
	 * Custom Event Dispatcher
	 */
	public var dispatcher : IDispatcher;
	
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
	 * .class								.intro							Selects all elements with class="intro"
	 *	#id									#firstname						Selects the element with id="firstname"
	 *	*									*								Selects all elements
	 *	element								p								Selects all <p> elements
	 *	element,element						div, p							Selects all <div> elements and all <p> elements
	 *	element element						div p							Selects all <p> elements inside <div> elements
	 *	element>element						div > p							Selects all <p> elements where the parent is a <div> element
	 *	element+element						div + p							Selects all <p> elements that are placed immediately after <div> elements
	 *	element1~element2					p ~ ul							Selects every <ul> element that are preceded by a <p> element
	 *	[attribute]							[target]						Selects all elements with a target attribute
	 *	[attribute=value]					[target=_blank]					Selects all elements with target="_blank"
	 *	[attribute~=value]					[title~=flower]					Selects all elements with a title attribute containing the word "flower"
	 *	[attribute|=value]					[lang|=en]						Selects all elements with a lang attribute value starting with "en"
	 *	[attribute^=value]					a[href^="https"]				Selects every <a> element whose href attribute value begins with "https"
	 *	[attribute$=value]					a[href$=".pdf"]					Selects every <a> element whose href attribute value ends with ".pdf"
	 *	[attribute*=value]					a[href*="w3schools"]			Selects every <a> element whose href attribute value contains the substring "w3schools"
	 *	:active								a:active						Selects the active link
	 *	::after								p::after						Insert content after every <p> element
	 *	::before							p::before						Insert content before the content of every <p> element
	 *	:checked							input:checked					Selects every checked <input> element
	 *	:disabled							input:disabled					Selects every disabled <input> element
	 *	:empty								p:empty							Selects every <p> element that has no children (including text nodes)
	 *	:enabled							input:enabled					Selects every enabled <input> element
	 *	:first-child						p:first-child					Selects every <p> element that is the first child of its parent
	 *	::first-letter						p::first-letter					Selects the first letter of every <p> element
	 *	::first-line						p::first-line					Selects the first line of every <p> element
	 *	:first-of-type						p:first-of-type					Selects every <p> element that is the first <p> element of its parent
	 *	:focus								input:focus						Selects the input element which has focus
	 *	:hover								a:hover							Selects links on mouse over
	 *	:in-range							input:in-range					Selects input elements with a value within a specified range
	 *	:invalid							input:invalid					Selects all input elements with an invalid value
	 *	:lang(language)						p:lang(it)						Selects every <p> element with a lang attribute equal to "it" (Italian)
	 *	:last-child							p:last-child					Selects every <p> element that is the last child of its parent
	 *	:last-of-type						p:last-of-type					Selects every <p> element that is the last <p> element of its parent
	 *	:link								p:link							Selects all unvisited links
	 *	:not(selector)						:not(p)							Selects every element that is not a <p> element
	 *	:nth-child(n)						p:nth-child(2)					Selects every <p> element that is the second child of its parent
	 *	:nth-last-child(n)					p:nth-last-child(2)				Selects every <p> element that is the second child of its parent, counting from the last child
	 *	:nth-last-of-type(n)				p:nth-last-of-type(2)			Selects every <p> element that is the second <p> element of its parent, counting from the last child
	 *	:nth-of-type(n)						p:nth-of-type(2)				Selects every <p> element that is the second <p> element of its parent
	 *	:only-of-type						p:only-of-type					Selects every <p> element that is the only <p> element of its parent
	 *	:only-child							p:only-child					Selects every <p> element that is the only child of its parent
	 *	:optional							input:optional					Selects input elements with no "required" attribute
	 *	:out-of-range						input:out-of-range				Selects input elements with a value outside a specified range
	 *	:read-only							input:read-only					Selects input elements with the "readonly" attribute specified
	 *	:read-write							input:read-write				Selects input elements with the "readonly" attribute NOT specified
	 *	:required							input:required					Selects input elements with the "required" attribute specified
	 *	:root								:root							Selects the document's root element
	 *	::selection							::selection						Selects the portion of an element that is selected by a user					 
	 *	:target								#news:target					Selects the current active #news element (clicked on a URL containing that anchor name)
	 *	:valid								input:valid						Selects all input elements with a valid value
	 *	:visited							a:visited						Selects all visited links
	 * @param	q
	 * @return
	 */
	public function select(q:String):ITable;
	
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
	public function all():ITable;
	
	/**
	 * Add custom classes from string
	 * @param	styles
	 * @return
	 */
	public function css(styles:String):IDisplay;
	
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
	 * Add hidden attribute to element
	 */
	public function show():Void;
	
	/**
	 * Remove hidden attribute from element
	 */
	public function hide():Void;
	
	/**
	 * Get and/or set an element attribute
	 * @param	name
	 * @param	value
	 * @return
	 */
	public function attribute(name:String, ?value:String):String;
	
	/**
	 * Write InnerText or InnerHTML properties
	 * @param	q
	 * @param	plainText
	 */
	public function build(q:String, ?plainText:Bool = false):IDisplay;
	
	/**
	 * Write properties in element style
	 * @param	write
	 * @return
	 */
	public function style(write:Dynamic):IDisplay;
	
	/**
	 * Apply all dispatcher events
	 * @return
	 */
	public function prepare():IDisplay;
	
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
	 * @param	capture
	 * @return
	 */
	public function on(type:String, handler:Dynamic, ?capture:Bool):IDisplay;
	
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
	
	
	
}