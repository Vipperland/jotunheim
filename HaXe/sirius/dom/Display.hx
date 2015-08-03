package sirius.dom;

import haxe.Log;
import js.Browser;
import js.html.DOMRect;
import js.html.Element;
import js.html.Node;
import sirius.dom.IDisplay;
import sirius.events.Dispatcher;
import sirius.events.IDispatcher;
import sirius.math.ARGB;
import sirius.Sirius;
import sirius.tools.Key;
import sirius.tools.Ticker;
import sirius.tools.Utils;
import sirius.transitions.Animator;
import sirius.utils.Dice;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Display")
class Display implements IDisplay {
	
	public static var DATA:Dynamic = { };
	
	public static function ofKind(q:String):IDisplay {
		return new Display(Browser.document.createElement(q));
	}
	
	public static function create(q:Dynamic):IDisplay {
		return new Display(q);
	}
	
	private var _uid:String;
	
	public var data:Dynamic;
	
	/** INNER data 
	 * @private
	 **/
	private var _data:Dynamic;
	
	/** Default target element */
	public var element:Element;
	
	/** Custom Event Dispatcher */
	public var dispatcher:IDispatcher;
	
	public var parent:IDisplay;
	
	public var body:Body;
	
	public var children:ITable;
	
	
	public function new(?q:Dynamic = null, ?t:Element = null, ?d:String = null) {
		if (Std.is(q, String)) q = Sirius.select(q, t);
		if (q == null) {
			q = Browser.document.createDivElement();
		}
		element = q;
		dispatcher = new Dispatcher(this);
		if (d != null) css(d);
		body = Sirius.body;
		buildParent();
		
		if (hasAttribute("sirius-uid")) {
			_uid = attribute("sirius-uid");
			data = Reflect.field(DATA, _uid);
			_data = data.__data__;
		}else {
			_uid = attribute("sirius-uid", Key.GEN());
			data = { __data__: { }};
			_data = data.__data__;
			Reflect.setField(DATA, _uid, data);
		}
		
		
	}
	
	public function exists(q:String):Bool {
		return element != null && element.querySelector(q) != null;
	}
	
	public function enable(q:Array<Dynamic>):IDisplay {
		var d:IDispatcher = this.dispatcher;
		Dice.Values(q, function(v:Dynamic) {
			if (!Std.is(v, Array))	v = [v, false];
			var o:Dynamic = v[0];
			var c:Dynamic = v[1];
			untyped __js__("new o(d, c)");
		});
		return this;
	}
	
	
	public function select(q:String):ITable {
		return Sirius.all(q, element);
	}
	
	
	public function one(q:String):IDisplay {
		return Sirius.select(q, element);
	}
	
	
	public function all():ITable {
		return Sirius.all("*", element);
	}
	
	public function getScroll(?o:Dynamic = null):Dynamic {
		if (o == null) o = { };
		o.scrollX = element.scrollLeft;
		o.scrollY = element.scrollTop;
		o.x = element.offsetLeft;
		o.y = element.offsetTop;
		o.viewX = o.x - Browser.window.scrollX;
		o.viewY = o.y - Browser.window.scrollY;
		return o;
	}
	
	public function getChild(i:Int, ?update:Bool):IDisplay {
		if (children == null || update == true) children = all();
		return cast children.obj(i);
	}
	
	public function length():Int {
		return element.children.length;
	}
	
	public function index():Int {
		return parent != null ? parent.indexOf(this) : null;
	}
	
	public function indexOf(q:IDisplay):Int {
		var r:Int = -1;
		Dice.Children(element, function(c:Node, i:Int) {
			return c == q.element;
		}, function(i:Int, f:Bool) {
			r = f ? i : -1;
		});
		return r;
	}
	
	public function addChild(q:IDisplay, ?at:Int = -1):IDisplay {
		q.dispatcher.apply();
		q.parent = this;
		if (at != -1 && at < length()) {
			var sw:Node = element.childNodes.item(at);
			element.insertBefore(q.element, sw);
		}else {
			element.appendChild(q.element);	
		}
		return this;
	}
	
	public function addChildren(q:ITable):IDisplay {
		q.each(addChild);
		return this;
	}
	
	public function addText(q:String):IDisplay {
		addChild(new Text(q));
		return this;
	}
	
	public function removeChild(q:IDisplay):IDisplay {
		q.remove();
		return this;
	}
	
	public function remove():IDisplay {
		this.parent = null;
		if (element.parentElement != null) element.parentElement.removeChild(element);
		return this;
	}
	
	public function css(styles:String):IDisplay {
		var s:Array<String> = styles.split(" ");
		Dice.Values(s, function(v:String) {
			if (v != null && v.length > 0) {
				if (v.substr(0, 1) == "/") {
					v = v.substr(1, v.length - 1);
					if (element.classList.contains(v)) {
						element.classList.remove(v);
					}
				}else {
					if (!element.classList.contains(v)) {
						element.classList.add(v);
					}
				}
			}
		});
		return this;
	}
	
	public function cursor(?value:String):String {
		if (value != null) element.style.cursor = value;
		return element.style.cursor;
	}
	
	public function detach():Void {
		element.style.position = "absolute";
	}
	
	public function attach():Void {
		element.style.position = "relative";
	}
	
	public function show():Void {
		element.hidden = false;
	}
	
	public function hide():Void {
		element.hidden = true;
	}
	
	public function hasAttribute(name:String):Bool {
		return Reflect.getProperty(element, name) != null || (element.getAttribute != null && element.getAttribute(name) != null);
	}
	
	public function attribute(name:String, ?value:String):String {
		if (Reflect.getProperty(element, name) != null) {
			if (value != null) Reflect.setProperty(element, name, value);
			return Reflect.getProperty(element, name);
		}
		if(element.setAttribute != null){
			if (value != null) element.setAttribute(name, value);
			return element.getAttribute(name);
		}
		return null;
	}
	
	public function build(q:String, ?plainText:Bool = false):IDisplay {
		if (plainText) element.innerText = q;
		else element.innerHTML = q;
		return this;
	}
	
	public function style(?p:Dynamic,?v:Dynamic):Dynamic {
		if (p != null) {
			if (Std.is(p, String)) {
				if (v != null) {
					Reflect.setField(element.style, p, Std.string(v));
				}
				v = Reflect.field(element.style, p);
				if (p.toLowerCase().indexOf("color") > 0) v = new ARGB(v);
				return v;
			}else {
				Dice.All(p, function(p:String, v:String) {
					Reflect.setField(element.style, p, Std.string(v));
				});
			}
		}
		return this;
	}
	
	public function prepare():IDisplay {
		this.dispatcher.apply();
		return this;
	}
	
	public function write(q:String):IDisplay {
		var i:IDisplay = new Display().build(q);
		i.all().each(addChild);
		return this;
	}
	
	public function clear(?fast:Bool):IDisplay {
		if (fast) {
			element.innerHTML = "";
		}else{
			var i:Int = element.children.length;
			while (i-- > 0) element.removeChild(element.childNodes.item(i));
		}
		return this;
	}
	
	public function on(type:String, handler:Dynamic, ?mode:Dynamic):IDisplay {
		dispatcher.auto(type, handler, mode);
		return this;
	}
	
	public function fadeTo(value:Float, time:Float = 1):IDisplay {
		tweenTo(time, { opacity:value } );
		return this;
	}
	
	public function tweenTo(time:Float = 1, target:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay {
		if (complete != null) target.onComplete = complete;
		if (ease != null) target.ease = ease;
		if(element != null){
			Animator.stop(element);
			Animator.to(element, time, target);
		}
		return this;
	}
	
	public function tweenFrom(time:Float = 1, target:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay {
		if (complete != null) target.onComplete = complete;
		if (ease != null) target.ease = ease;
		if(element != null){
			Animator.stop(element);
			Animator.from(element, time, target);
		}
		return this;
	}
	
	public function tweenFromTo(time:Float = 1, from:Dynamic, to:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay {
		if (complete != null) from.onComplete = complete;
		if (ease != null) from.ease = ease;
		if(element != null){
			Animator.stop(element);
			Animator.fromTo(element, time, from, to);
		}
		return this;
	}
	
	public function buildParent():IDisplay {
		if (element.parentElement != null && parent == null) {
			parent = Utils.displayFrom(element.parentElement);
		}
		return this;
	}
	
	public function activate(handler:Dynamic):IDisplay {
		Ticker.add(handler);
		return this;
	}
	
	public function deactivate(handler:Dynamic):IDisplay {
		Ticker.remove(handler);
		return this;
	}
	
	public function width(?value:Float, ?pct:Bool):Float {
		if (value != null)
			element.style.width = value + (pct ? "%" : "px");
		return element.clientWidth;
	}
	
	public function height(?value:Float, ?pct:Bool):Float {
		if (value != null)
			element.style.height = value + (pct ? "%" : "px");
		return element.clientHeight;
	}
	
	public function fit(width:Float, height:Float, ?pct:Bool):IDisplay {
		this.width(width, pct);
		this.height(height, pct);
		return this;
	}
	
	public function overflow(?mode:String):String {
		if (mode != null)
			element.style.overflow = mode;
		return element.style.overflow;
	}
	
	public function isFullyVisible():Bool {
		var rect:DOMRect = this.element.getBoundingClientRect();
		return rect.top >= 0 && rect.left >= 0 && rect.bottom <= Utils.viewportHeight() && rect.right <= Utils.viewportWidth();
	}
	
	public function isVisible():Bool {
		var rect:DOMRect = this.element.getBoundingClientRect();
		return rect.bottom >= 0 && rect.right >= 0 && rect.top <= Utils.viewportHeight() && rect.left <= Utils.viewportWidth();
	}
	
	public function isHidden():Bool {
		return element == null || element.hidden;
	}
	
}