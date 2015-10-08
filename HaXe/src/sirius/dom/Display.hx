package sirius.dom;

import haxe.ds.Either;
import haxe.Log;
import js.Browser;
import js.html.CSSStyleDeclaration;
import js.html.DOMRect;
import js.html.DOMTokenList;
import js.html.Element;
import js.html.Node;
import js.JQuery;
import sirius.css.Automator;
import sirius.data.DataSet;
import sirius.data.DisplayData;
import sirius.data.IDataSet;
import sirius.dom.IDisplay;
import sirius.events.Dispatcher;
import sirius.events.IDispatcher;
import sirius.math.ARGB;
import sirius.math.IARGB;
import sirius.math.IPoint;
import sirius.math.Point;
import sirius.Sirius;
import sirius.tools.Key;
import sirius.tools.Ticker;
import sirius.tools.Utils;
import sirius.transitions.Animator;
import sirius.utils.Dice;
import sirius.utils.IDiceRoll;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Display")
class Display implements IDisplay {
	
	private static var _DATA:IDataSet = new DataSet();
	
	public static function ofKind(q:String):IDisplay {
		return new Display(Browser.document.createElement(q));
	}
	
	public static function create(q:Dynamic):IDisplay {
		return new Display(q);
	}
	
	static public function getPosition(target:Element):IPoint {
		//var isNotFirefox = (navigator.userAgent.toLowerCase().indexOf('firefox') == -1);
		var x:Int = 0;
		var y:Int = 0;
		while (target != null) {
			x += target.offsetLeft - target.scrollLeft + target.clientLeft;
			y += target.offsetTop - target.scrollTop + target.clientTop;
			target = target.offsetParent;
		}
		return new Point(x + window.scrollX, y + window.scrollY);
	}
	
	private var _uid:String;
	
	public var data:DisplayData;
	
	public var element:Element;
	
	public var events:IDispatcher;
	
	private var _parent:IDisplay;
	
	private var _children:ITable;
	
	private var _visibility:Int;
	
	public function new(?q:Dynamic = null, ?t:Element = null, ?d:String = null) {
		
		if (Std.is(q, String)) q = Sirius.one(q, t);
		else if (Std.is(q, IDisplay)) q = q.element;
		if (q == null) {
			q = Browser.document.createDivElement();
		}
		element = q;
		events = new Dispatcher(this);
		if (d != null) css(d);
		
		if (element != cast Browser.document) {
			_uid = hasAttribute("sru-id") ? attribute("sru-id") : attribute("sru-id", Key.GEN());
			if (!_DATA.exists(_uid)) _DATA.set(_uid, new DisplayData());
			data = _DATA.get(_uid);
		}
		
	}
	
	public function exists(q:String):Bool {
		return element != null && element.querySelector(q) != null;
	}
	
	public function enable(q:Array<Dynamic>):IDisplay {
		var d:IDispatcher = this.events;
		Dice.Values(q, function(v:Dynamic) {
			if (!Std.is(v, Array))	v = [v, false];
			var o:Dynamic = v[0];
			var c:Dynamic = v[1];
			untyped __js__("new o(d, c)");
		});
		return this;
	}
	
	public function alignCenter():Void {
		css("marg-a vert-m /float-l /float-r txt-c");
	}
	
	public function alignLeft():Void {
		css("/marg-a /vert-m float-l /float-r /txt-c");
	}
	
	public function alignRight():Void {
		css("/marg-a /vert-m /float-l float-r /txt-c");
	}
	
	public function background(?data:Either<String,IARGB>, ?repeat:String, ?position:String, ?attachment:String):String {
		
		if (data != null) {
			var value:Dynamic = cast data;
			if (Std.is(value, IARGB)) value = value.css();
			if (value.indexOf("#") == 0) {
				element.style.background = value;
			}else if (value.indexOf("rgb") == 0) {
				element.style.backgroundColor = value;
			}else{
				var c:String = (value.indexOf("#") == 0) ? value : "url(" + value + ")";
				var r:String = repeat != null && repeat.length > 0 ? repeat : "center center";
				var p:String = position != null && repeat.length > 0 ? position : "no-repeat";
				element.style.background = c + " " + r + " " + p;
				if (attachment != null && attachment.length > 0) element.style.backgroundAttachment = attachment;
			}
		}
		return element.style.background;
	}
	
	
	public function all(q:String):ITable {
		return Sirius.all(q, element);
	}
	
	
	public function one(q:String):IDisplay {
		return Sirius.one(q, element);
	}
	
	
	public function children():ITable {
		if (_children == null) _children = Sirius.all("*", element);
		return _children;
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
		if (_children == null || update == true) _children = children();
		return cast _children.obj(i);
	}
	
	public function length():Int {
		return element.children.length;
	}
	
	public function index():Int {
		return _parent != null ? _parent.indexOf(this) : -1;
	}
	
	public function indexOf(q:IDisplay):Int {
		var r:Int = -1;
		Dice.Children(element, function(c:Node, i:Int) {
			return c == q.element;
		}, function(o:IDiceRoll) {
			r = o.completed ? o.value : -1;
		});
		return r;
	}
	
	public function addChild(q:IDisplay, ?at:Int = -1):IDisplay {
		q.events.apply();
		Reflect.setField(q, '_parent', this);
		if (at != -1 && at < length()) {
			var sw:Node = element.childNodes.item(at);
			element.insertBefore(q.element, sw);
		}else {
			element.appendChild(q.element);	
		}
		_children = null;
		return this;
	}
	
	public function addChildren(q:ITable):IDisplay {
		q.each(cast addChild);
		_children = null;
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
		this._parent = null;
		if (element.parentElement != null) element.parentElement.removeChild(element);
		return this;
	}
	
	public function css(?styles:String):String {
		if(styles != null){
			var s:Array<String> = styles.split(" ");
			var cl:DOMTokenList = element.classList;
			Dice.Values(s, function(v:String) {
				if (v != null && v.length > 0) {
					if (v.substr(0, 1) == "/") {
						v = v.substr(1, v.length - 1);
						if (cl.contains(v)) cl.remove(v);
					}else {
						if (!cl.contains(v)) cl.add(v);
					}
				}
			});
		}
		return element.className;
	}
	
	public function cursor(?value:String):String {
		if (value != null) element.style.cursor = value;
		return element.style.cursor;
	}
	
	public function detach():Void {
		Automator.build('pos-abs');
		css('pos-abs /pos-rel /pos-fix');
	}
	
	public function attach():Void {
		Automator.build('pos-rel');
		css('/pos-abs pos-rel /pos-fix');
	}
	
	public function pin():Void {
		Automator.build('pos-fix');
		css('/pos-abs /pos-rel pos-fix');
	}
	
	public function show():Void {
		element.hidden = false;
	}
	
	public function hide():Void {
		element.hidden = true;
	}
	
	public function hasAttribute(name:String):Bool {
		return (element.hasAttribute != null && element.hasAttribute(name)) || Reflect.getProperty(element, name) != null;
	}
	
	public function attribute(name:String, ?value:String):String {
		if(name != null){
			if (value != null) {
				if (element.setAttribute != null) 	element.setAttribute(name, value);
				else								Reflect.setProperty(element, name, value);
			}
			if (element.getAttribute != null) 		return element.getAttribute(name);
			else 									Reflect.getProperty(element, name);
		}
		return null;
	}
	
	public function attributes(values:Dynamic):IDisplay {
		Dice.All(values, attribute);
		return this;
	}
	
	public function build(q:String, ?plainText:Bool = false):IDisplay {
		if (plainText) element.innerText = q;
		else element.innerHTML = q;
		return this;
	}
	
	public function style(?p:Dynamic,?v:Dynamic):Dynamic {
		if (p != null) {
			if (Std.is(p, String)) {
				if (v != null) Reflect.setField(element.style, p, Std.is(v, IARGB) ? v.css() : Std.string(v));
				v = Reflect.field(trueStyle(), p);
				if (p.toLowerCase().indexOf("color") > 0) v = new ARGB(v);
				return v;
			}else {
				Dice.All(p, function(p:String, v:Dynamic) {
					Reflect.setField(element.style, p, Std.is(v, IARGB) ? v.css() : Std.string(v));
				});
			}
		}
		return trueStyle();
	}
	
	public function trueStyle():CSSStyleDeclaration {
		if (element.ownerDocument.defaultView.opener) 	return element.ownerDocument.defaultView.getComputedStyle(element);
		else											return Browser.window.getComputedStyle(element);
	}
	
	public function write(q:String):IDisplay {
		var i:IDisplay = new Display().build(q,false);
		i.children().each(cast addChild);
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
		events.auto(type, handler, mode);
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
	
	public function parent(levels:UInt=0):IDisplay {
		if (element.parentElement != null && _parent == null) _parent = Utils.displayFrom(element.parentElement);
		if (levels > 0 && _parent != null)	return _parent.parent(--levels);
		else 								return _parent;
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
		return _visibility == 2;
	}
	
	public function isVisible():Bool {
		return _visibility > 0;
	}
	
	public function checkVisibility(?view:Bool, ?offsetY:Int = 0, ?offsetX:Int = 0):UInt {
		
		var rect:DOMRect = this.element.getBoundingClientRect();
		var current:Int = 0;
		// IS FULLY VISIBLE
		if (rect.top + offsetY >= 0 && rect.left + offsetX >= 0 && rect.bottom - offsetY <= Utils.viewportHeight() && rect.right - offsetX <= Utils.viewportWidth()) current = 2;
		// IS VISIBLE
		else if (rect.bottom >= 0 && rect.right >= 0 && rect.top <= Utils.viewportHeight() && rect.left <= Utils.viewportWidth()) current = 1;
		
		if (current != _visibility) {
			_visibility = current;
			events.visibility().call();
		}
		
		return _visibility;
	}
	
	public function getBounds():DOMRect {
		return this.element.getBoundingClientRect();
	}
	
	public function jQuery():JQuery {
		return Sirius.jQuery(element);
	}
	
	public function typeOf():String {
		return "[" + Utils.getClassName(this) + "{element:" + element.tagName + ", length:" + length() + "}]";
	}
	
	public function is(tag:String):Bool {
		tag = tag.toLowerCase();
		var segment:String = Utils.getClassName(this).toLowerCase();
		if (tag.indexOf(".") == -1) segment = segment.split(".").pop();
		return tag == segment || tag == element.tagName;
	}
	
	public function addTo(?target:IDisplay):IDisplay {
		if (target != null) target.addChild(this);
		else if (Sirius.document != null) Sirius.document.body.addChild(this);
		return this;
	}
	
	public function addToBody():IDisplay {
		if (Sirius.document != null) Sirius.document.body.addChild(this);
		return this;
	}
	
	public function goFullSize():Void {
		style( {
			width:Utils.viewportWidth() + 'px',
			height:Utils.viewportHeight() + 'px',
		});
	}
	
	public function position():IPoint {
		return getPosition(element);
	}
	
}