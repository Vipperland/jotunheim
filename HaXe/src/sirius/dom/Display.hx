package sirius.dom;

import haxe.ds.Either;
import js.Browser;
import js.html.CSSStyleDeclaration;
import js.html.DOMRect;
import js.html.DOMTokenList;
import js.html.Element;
import js.html.Node;
import js.JQuery;
import sirius.data.DataSet;
import sirius.data.DisplayData;
import sirius.data.IDataSet;
import sirius.dom.IDisplay;
import sirius.events.IDispatcher;
import sirius.math.ARGB;
import sirius.math.IARGB;
import sirius.math.IPoint;
import sirius.math.Point;
import sirius.modules.IRequest;
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
	
	static public function gc(?secure:Bool):Void {
		if (secure) {
			_DATA.clear();
		}else{
			Dice.All(_DATA.structure, function(p:String, v:DisplayData) {
				if (Sirius.one('[sru-id=' + v.__id__ + ']') == null) {
					_DATA.get(p).dispose();
					_DATA.unset(p);
				}
			});
		}
	}
	
	static public function getPosition(target:Element) {
		var a:DOMRect = Sirius.document.body.getBounds();
		var b:DOMRect = target.getBoundingClientRect();
		return new Point(b.left - a.left, b.top - a.top);
	}
	
	private var _uid:String;
	
	public var data:DisplayData;
	
	public var element:Element;
	
	public var events:IDispatcher;
	
	private var _parent:IDisplay;
	
	private var _children:ITable;
	
	private var _visibility:Int;
	
	public function new(?q:Dynamic = null, ?t:Element = null) {
		
		if (q == null) 	q = Browser.document.createDivElement();
		if (Std.is(q, IDisplay))	element = q.element;
		else 						element = q;
		
		if (element != cast Browser.document) {
			_uid = hasAttribute("sru-id") ? attribute("sru-id") : attribute("sru-id", Key.GEN());
			if (!_DATA.exists(_uid)) {
				_DATA.set(_uid, new DisplayData(_uid, this));
			}
			data = _DATA.get(_uid);
			events = data.__events__;
		}
		
	}
	
	public function dispose():Void {
		_DATA.unset(_uid);
		events.dispose();
		remove();
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
	
	public function bg(?data:Either<String,IARGB>, ?repeat:String, ?position:String, ?attachment:String):String {
		
		if (data != null) {
			var value:Dynamic = cast data;
			if (Std.is(value, IARGB)) value = value.css();
			if (value.indexOf("#") == 0) {
				element.style.background = value;
			}else if (value.indexOf("rgb") == 0) {
				element.style.backgroundColor = value;
			}else{
				var c:String = "url('" + value + "')";
				var r:String = repeat != null ? repeat : "no-repeat";
				var p:String = position != null ? position : "center center";
				element.style.backgroundImage = c;
				element.style.backgroundRepeat = r;
				element.style.backgroundPosition = p;
				if (attachment != null) element.style.backgroundAttachment = attachment;
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
		if (_children == null) _children = Sirius.all('*', element);
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
		return element.childNodes.length;
	}
	
	public function index():Int {
		return parent().indexOf(this);
	}
	
	public function indexOf(q:IDisplay):Int {
		var chd = element.childNodes;
		var len = chd.length;
		var cnt = 0;
		while (cnt < len) {
			if (cast chd.item(cnt) == q.element) break;
			++cnt;
		}
		return cnt == len ? -1 : cnt;
	}
	
	public function addChild(q:IDisplay, ?at:Int = -1):IDisplay {
		Reflect.setField(q, '_parent', this);
		if (at != -1) {
			var sw:Node = element.childNodes.item(at);
			element.insertBefore(q.element, sw);
		}else {
			element.appendChild(q.element);
		}
		_children = null;
		return q;
	}
	
	public function addChildren(q:ITable):IDisplay {
		var l:IDisplay = null;
		q.each(cast addChild);
		_children = null;
		return q.last();
	}
	
	public function addText(q:String):IDisplay {
		var t:IDisplay = new Text(q);
		addChild(t);
		return t;
	}
	
	public function removeChild(q:IDisplay):IDisplay {
		_children = null;
		q.remove();
		return q;
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
		if (name != null) {
			var t:String = Reflect.field(element, name);
			if (t != null) {
				if (value != null)					Reflect.setField(element, name, value);
				value =	Reflect.field(element, name);
				return value;
			}
			if (value != null) {
				if (element.setAttribute != null) 	element.setAttribute(name, value);
				else								Reflect.setProperty(element, name, value);
			}
			if (element.getAttribute != null) 		return element.getAttribute(name);
			else 									return Reflect.getProperty(element, name);
		}
		return null;
	}
	
	public function attributes(values:Dynamic):IDisplay {
		Dice.All(values, attribute);
		return this;
	}
	
	public function write(q:String, ?plainText:Bool = false):IDisplay {
		if (plainText) element.innerText += q;
		else element.innerHTML = element.innerHTML + q;
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
		if (Browser.document.defaultView.opener != null) 	
					return Browser.document.defaultView.getComputedStyle(element);
		else		return Browser.window.getComputedStyle(element);
	}
	
	public function mount(q:String, ?data:Dynamic):IDisplay {
		if (Sirius.resources.exists(q)) {
			return addChildren(Sirius.resources.build(q, data).children());
		}else {
			return addChildren(new Display().write(q,false).children());
		}
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
		if (_parent == null && element.parentElement != null) _parent = Utils.displayFrom(element.parentElement);
		if (levels > 0)		return _parent.parent(--levels);
		else 				return _parent;
	}
	
	public function activate(handler:Dynamic):IDisplay {
		Ticker.add(handler);
		return this;
	}
	
	public function deactivate(handler:Dynamic):IDisplay {
		Ticker.remove(handler);
		return this;
	}
	
	public function width(?value:Dynamic):Int {
		if (value != null)
			element.style.width = Std.is(value, String) ? value : value + "px";
		return element.clientWidth;
	}
	
	public function height(?value:Dynamic):Int {
		if (value != null)
			element.style.height = Std.is(value, String) ? value : value + "px";
		return element.clientHeight;
	}
	
	public function fit(width:Dynamic, height:Dynamic):IDisplay {
		this.width(width);
		this.height(height);
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
		return "[" + Utils.typeof(this) + "{element:" + element.tagName + ", length:" + length() + "}]";
	}
	
	public function is(tag:Either<String,Array<String>>):Bool {
		var name:String = Utils.typeof(this).toLowerCase();
		var pre:String = name.split(".").pop();
		if (Std.is(tag, String)) tag = cast [tag];
		var r:IDiceRoll = Dice.Values(tag, function(v:String) {
			v = v.toLowerCase();
			var c:String = (v.indexOf(".") == -1) ? pre : name;
			return v == c || v == element.tagName;
		});
		return !r.completed;
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
	
	public function mouse(?value:Bool):Bool {
		if (value != null) {
			if (value)	css('mouse-none');
			else 		css('/mouse-none');
		}
		return element.classList.contains('mouse-none');
	}
	
	public function load(url:String, module:String, ?data:Dynamic, ?handler:IRequest->Void):Void {
		Sirius.request(url, data, function(r:IRequest) {
			if (r.success) mount(module);
			if (handler != null) handler(r);
		});
	}
	
}