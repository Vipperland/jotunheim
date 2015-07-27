package sirius.dom;

import haxe.Log;
import js.Browser;
import js.html.DOMRect;
import js.html.Element;
import js.html.Node;
import sirius.dom.IDisplay;
import sirius.events.Dispatcher;
import sirius.events.IDispatcher;
import sirius.Sirius;
import sirius.tools.Ticker;
import sirius.tools.Utils;
import sirius.transitions.Tween;
import sirius.utils.Dice;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.dom.Display")
class Display implements IDisplay {
	
	public static function ofKind(q:String):IDisplay {
		return new Display(Browser.document.createElement(q));
	}
	
	public static function create(q:Dynamic):IDisplay {
		return new Display(q);
	}
	
	public var data:Dynamic;
	
	private var _data:Dynamic;
	
	/** Default target element */
	public var Self:Element;
	
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
		Self = q;
		data = { };
		_data = { };
		dispatcher = new Dispatcher(this);
		if (d != null) css(d);
		body = Sirius.body;
		buildParent();
	}
	
	public function exists(q:String):Bool {
		return Self != null && Self.querySelector(q) != null;
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
		return Sirius.all(q, Self);
	}
	
	
	public function one(q:String):IDisplay {
		return Sirius.select(q, Self);
	}
	
	
	public function all():ITable {
		return Sirius.all("*", Self);
	}
	
	public function getScroll(?o:Dynamic = null):Dynamic {
		if (o == null) o = { };
		o.scrollX = Self.scrollLeft;
		o.scrollY = Self.scrollTop;
		o.x = Self.offsetLeft;
		o.y = Self.offsetTop;
		o.viewX = o.x - Browser.window.scrollX;
		o.viewY = o.y - Browser.window.scrollY;
		return o;
	}
	
	public function getChild(i:Int, ?update:Bool):IDisplay {
		if (children == null || update == true) children = all();
		return cast children.obj(i);
	}
	
	public function length():Int {
		return Self.children.length;
	}
	
	public function index():Int {
		return parent != null ? parent.indexOf(this) : null;
	}
	
	public function indexOf(q:IDisplay):Int {
		var r:Int = -1;
		Dice.Children(Self, function(c:Node, i:Int) {
			return c == q.Self;
		}, function(i:Int, f:Bool) {
			r = f ? i : -1;
		});
		return r;
	}
	
	public function addChild(q:IDisplay, ?at:Int = -1):IDisplay {
		q.dispatcher.apply();
		q.parent = this;
		if (at != -1 && at < length()) {
			var sw:Node = Self.childNodes.item(at);
			Self.insertBefore(q.Self, sw);
		}else {
			Self.appendChild(q.Self);	
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
		if (Self.parentElement != null) Self.parentElement.removeChild(Self);
		return this;
	}
	
	public function css(styles:String):IDisplay {
		var s:Array<String> = styles.split(" ");
		Dice.Values(s, function(v:String) {
			if (v != null && v.length > 0) {
				if (v.substr(0, 1) == "/") {
					v = v.substr(1, v.length - 1);
					if (Self.classList.contains(v)) {
						Self.classList.remove(v);
					}
				}else {
					if (!Self.classList.contains(v)) {
						Self.classList.add(v);
					}
				}
			}
		});
		return this;
	}
	
	public function cursor(?value:String):String {
		if (value != null) Self.style.cursor = value;
		return Self.style.cursor;
	}
	
	public function detach():Void {
		Self.style.position = "absolute";
	}
	
	public function attach():Void {
		Self.style.position = "relative";
	}
	
	public function show():Void {
		Self.hidden = false;
	}
	
	public function hide():Void {
		Self.hidden = true;
	}
	
	public function attribute(name:String, ?value:String):String {
		if (Reflect.getProperty(Self, name) != null) {
			if (value != null) Reflect.setProperty(Self, name, value);
			return Reflect.getProperty(Self, name);
		}
		if (value != null) Self.setAttribute(name, value);
		return Self.getAttribute(name);
		
	}
	
	public function build(q:String, ?plainText:Bool = false):IDisplay {
		if (plainText) Self.innerText = q;
		else Self.innerHTML = q;
		return this;
	}
	
	public function style(write:Dynamic):IDisplay {
		Dice.All(write, function(p:String, v:String) {
			Reflect.setField(Self.style, p, "" + v);
		});
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
			Self.innerHTML = "";
		}else{
			var i:Int = Self.children.length;
			while (i-- > 0) Self.removeChild(Self.childNodes.item(i));
		}
		return this;
	}
	
	public function on(type:String, handler:Dynamic, ?capture:Bool):IDisplay {
		dispatcher.event(type).add(handler, capture);
		return this;
	}
	
	public function fadeTo(value:Float, time:Float = 1):IDisplay {
		tweenTo(time, { opacity:value } );
		return this;
	}
	
	public function tweenTo(time:Float = 1, target:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay {
		if (complete != null) target.onComplete = complete;
		if (ease != null) target.ease = ease;
		if(Self != null){
			Tween.stop(Self);
			Tween.to(Self, time, target);
		}
		return this;
	}
	
	public function tweenFrom(time:Float = 1, target:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay {
		if (complete != null) target.onComplete = complete;
		if (ease != null) target.ease = ease;
		if(Self != null){
			Tween.stop(Self);
			Tween.from(Self, time, target);
		}
		return this;
	}
	
	public function tweenFromTo(time:Float = 1, from:Dynamic, to:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay {
		if (complete != null) from.onComplete = complete;
		if (ease != null) from.ease = ease;
		if(Self != null){
			Tween.stop(Self);
			Tween.fromTo(Self, time, from, to);
		}
		return this;
	}
	
	public function buildParent():IDisplay {
		if (Self.parentElement != null && parent == null) {
			parent = Utils.displayFrom(Self.parentElement);
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
			Self.style.width = value + (pct ? "%" : "px");
		return Self.clientWidth;
	}
	
	public function height(?value:Float, ?pct:Bool):Float {
		if (value != null)
			Self.style.height = value + (pct ? "%" : "px");
		return Self.clientHeight;
	}
	
	public function fit(width:Float, height:Float, ?pct:Bool):IDisplay {
		this.width(width, pct);
		this.height(height, pct);
		return this;
	}
	
	public function overflow(?mode:String):String {
		if (mode != null)
			Self.style.overflow = mode;
		return Self.style.overflow;
	}
	
	public function isFullyVisible():Bool {
		var rect:DOMRect = this.Self.getBoundingClientRect();
		return rect.top >= 0 && rect.left >= 0 && rect.bottom <= Utils.viewportHeight() && rect.right <= Utils.viewportWidth();
	}
	
	public function isVisible():Bool {
		var rect:DOMRect = this.Self.getBoundingClientRect();
		return rect.bottom >= 0 && rect.right >= 0 && rect.top <= Utils.viewportHeight() && rect.left <= Utils.viewportWidth();
	}
	
	public function isHidden():Bool {
		return Self.hidden;
	}
	
}