package jotun.dom;
import haxe.DynamicAccess;
import jotun.Jotun;
import jotun.css.XCode;
import jotun.events.EventDispatcher;
import jotun.events.Activation;
import jotun.math.Point;
import jotun.tools.Key;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.utils.ITable;
import js.Browser;
import js.html.BeforeUnloadEvent;
import js.html.Element;
import js.html.Event;
import js.html.KeyboardEvent;
import js.html.MouseEvent;
import js.lib.Error;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Document extends Display {
	
	static private var __doc__:Document;
	
	/**
	 * Singleton Document
	 * @return
	 */
	static public function ME():Document {
		return __doc__ == null ? new Document() : __doc__;
	}
	
	private var __scroll__:Dynamic = { x:0, y:0 };
	
	private var __cursor__:Dynamic = { x:0, y:0 };
	
	private var __keys:DynamicAccess<Dynamic> = { };
	
	/**
	 * Document body
	 */
	public var body:Body;
	
	/**
	 * Document head
	 */
	public var head:Head;
	
	private function _applyScroll():Void {
		Browser.window.scroll(__scroll__.x, __scroll__.y);
	}
	
	private function __init__() {
		Browser.window.addEventListener('scroll', _hookScroll);
	}
	
	private function _hookKeyUp(e:Activation):Void {
		var event:KeyboardEvent = cast e.event;
		__keys.remove(event.key);
		__keys.remove(event.code);
	}
	
	private function _hookKeyDown(e:Activation):Void {
		var event:KeyboardEvent = cast e.event;
		__keys.set(event.key, true);
		__keys.set(event.code, true);
	}
	
	private function _hookScroll(e:Event):Void {
		events.scroll().call();
	}
	
	private function _onCloseWindow(e:BeforeUnloadEvent):Bool {
		if (e == null) {
			e = js.Syntax.code("window.event");
		}
		e.returnValue = true;
		if (e.stopPropagation != null) {
			e.stopPropagation();
			e.preventDefault();
		}
		return e.returnValue;
	}
	
	public function new() {
		if(__doc__ == null){
			super(cast Browser.document);
			element = cast Browser.document;
			head = new Head(Browser.document.head);
			__doc__ = this;
			__init__();
		}else {
			throw new js.lib.Error("Document is a singleton, use Document.ME() instead of new");
		}
	}
	
	public function isKeyPressed(key:Dynamic):Bool {
		return __keys.get(key) == true;
	}
	
	/**
	 * Show window/tab exit confirmation dialog
	 * @param	mode
	 */
	public function preventClose(mode:Bool):Void {
		if (mode){
			Browser.window.addEventListener('beforeunload', _onCloseWindow);
		}else{
			Browser.window.removeEventListener('beforeunload', _onCloseWindow);
		}
	}
	
	/**
	 * Update body reference
	 */
	public function checkBody():Void {
		body = new Body(js.Syntax.code("document.body"));
		if (body.hasAttribute('xcode')){
			XCode.reset();
		}
		if (body.hasAttribute('xcache')){
			Jotun.cache.enable(Std.parseInt(body.attribute('xcache')));
		}
		Jotun.all("[jtn-module]").each(function(o:Displayable){
			var n:String = o.attribute('module-name');
			if (n == null){
				n = 'Root';
			}
			Jotun.resources.register(n, o.element.innerHTML);
			o.dispose();
		});
	}
	
	/**
	 * Set current scroll point on Window element
	 * @param	x
	 * @param	y
	 */
	public function scroll(x:Int, y:Int, ease:Bool = true):Void {
		Browser.window.scroll(cast {
			top:y,
			left:x,
			behavior: ease ? 'smooth' : 'auto',
		});
	}
	
	/**
	 * Change current scroll by ammount
	 * @param	x
	 * @param	y
	 */
	override public function addScroll(x:Int, y:Int, ease:Bool = true):Void {
		Browser.window.scrollBy(cast {
			top:y,
			left:x,
			behavior: ease ? 'smooth' : 'auto',
		});
	}
	
	/**
	 * Return current scroll range value (from 0 to 1)
	 * @param	o
	 * @return
	 */
	public function getScrollRange(?o:Point = null):Point {
		var current:Point = getScroll(o);
		if (body != null) {
			current.x /= body.maxScrollX();
			current.y /= body.maxScrollY();
		}else {
			current.reset();
		}
		return current;
	}
	
	override public function getScroll(?o:Point = null):Point {
		if (o == null) {
			o = new Point(0, 0);
		}
		if (Browser.window.pageXOffset != null) {
			o.x = Browser.window.pageXOffset;
			o.y = Browser.window.pageYOffset;
		}else if(body != null){
			o.x = body.element.scrollLeft;
			o.y = body.element.scrollTop;
		}else {
			o.x = element.scrollLeft;
			o.y = element.scrollTop;	
		}
		return o;
	}
	
	/**
	 * Scroll to element position
	 * @param	target
	 * @param	time
	 * @param	offY
	 * @param	offX
	 */
	public function scrollTo(target:Dynamic, offY:Int = 100, offX:Int = 0, ease:Bool = true):Void {
		if (Std.isOfType(target, String)){
			target = Jotun.one(target).element;
		}
		if (Std.isOfType(target, Displayable)){
			target = target.element;
		}
		var pos:Point = Utils.getPosition(target);
		scroll(cast pos.x - offX, cast pos.y - offY, ease);
	}
	
	public function trackKeyboard():Void {
		if(__keys.get('_enabled') == false){
			events.keyDown(_hookKeyDown);
			events.keyUp(_hookKeyUp);
			__keys.set('_enabled', true);
		}
	}
	
	/**
	 * Track the mouse/touch position
	 */
	public function trackCursor():Void {
		if (__cursor__.enabled) {
			return;
		}
		__cursor__.enabled = true;
		Browser.window.addEventListener('mousemove', function(e:js.html.MouseEvent) {
			__cursor__.x = e.clientX;
			__cursor__.y = e.clientY;
		});
	}
	
	/**
	 * Current clientX
	 * @return
	 */
	public function cursorX():Int {
		return __cursor__.x;
	}
	
	/**
	 * Current clientY
	 * @return
	 */
	public function cursorY():Int {
		return __cursor__.y;
	}
	
	/**
	 * Current selected element
	 * @return
	 */
	public function hasFocusedInput():Bool {
		var disp:Displayable = getFocused();
		return Std.isOfType(disp, Input) || Std.isOfType(disp, TextArea) || disp.isEditable();
	}
	
	/**
	 * Current selected element
	 * @return
	 */
	public function getFocused():Displayable {
		var el:Element = Browser.document.activeElement;
		return el != null ? Utils.displayFrom(el) : null;
	}
	
	/**
	 * Print a custom element content
	 * @param	selector
	 * @param	exclude
	 * @return
	 */
	public function print(selector:String, ?exclude:String):Bool {
		var i:ITable = body.children();
		var success:Bool = false;
		if (i.length() > 0) {
			i.hide();
			var content:String = "";
			i.each(function(d:Displayable) {
				if (!d.is(cast ['script','style'])) {
					content += d.element.outerHTML;
					d.hide();
				}
			});
			if (content.length > 0) {
				var r:Displayable = new Div();
				r.mount(content);
				if (Utils.isValid(exclude)){
					r.all(exclude).remove();
				}
				body.addChild(r);
				try {
					Browser.window.print();
					success = true;
				}catch (e:Error) {
					success = false;
				}
				body.removeChild(r);
				
			}
			i.show();
		}
		return success;
	}
	
}