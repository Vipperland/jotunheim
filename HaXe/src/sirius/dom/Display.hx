package sirius.dom;

import haxe.Json;
import haxe.ds.Either;
import js.Browser;
import js.html.CSSStyleDeclaration;
import js.html.DOMRect;
import js.html.DOMTokenList;
import js.html.Element;
import js.html.Node;
import sirius.Sirius;
import sirius.data.DataSet;
import sirius.data.IDataSet;
import sirius.dom.IDisplay;
import sirius.events.Dispatcher;
import sirius.events.IDispatcher;
import sirius.math.ARGB;
import sirius.math.IARGB;
import sirius.math.IPoint;
import sirius.math.Point;
import sirius.modules.IRequest;
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
	
	private static var _CNT:UInt = 0;
	
	private static var _DATA:Array<IDisplay> = [];
	
	/**
	 * Create a display by element type 
	 * @param	q
	 * @return
	 */
	public static function ofKind(q:String):IDisplay {
		return Utils.displayFrom(Browser.document.createElement(q));
	}
	
	/**
	 * Prevent a cretion of a new Display instance for same element
	 * @param	id
	 * @return
	 */
	public static function fromGC(id:UInt):IDisplay {
		if (_DATA[id] != null)
			return _DATA[id];
		return null;
	}
	
	/**
	 * Remove all display from cache if not in dom
	 * @param	secure
	 */
	static public function gc(?secure:Bool):Void {
		if (secure) {
			_DATA = [];
		}else{
			Dice.Values(_DATA, function(v:IDisplay) {
				var id:UInt = v.id();
				if (Sirius.one('[sru-id=' + id + ']') == null) {
					Reflect.deleteField(_DATA, id + '');
				}
			});
		}
	}
	
	/**
	 * Get a real position of a element
	 * @param	target
	 */
	static public function getPosition(target:Element) {
		var a:DOMRect = Sirius.document.body.getBounds();
		var b:DOMRect = target.getBoundingClientRect();
		return new Point(b.left - a.left, b.top - a.top);
	}
	
	public var data:IDataSet;
	
	public var element:Element;
	
	public var events:IDispatcher;
	
	private var _uid:UInt;
	
	private var _parent:IDisplay;
	
	private var _children:ITable;
	
	private var _visibility:Int;
	
	private var _getattr:Bool;
	
	private var _setattr:Bool;
	
	public function new(?q:Dynamic = null, ?t:Element = null) {
		
		if (q == null)
			q = Browser.document.createDivElement();
		if (Reflect.hasField(q, 'element'))
			element = q.element;
		else
			element = q;
		
		if (element != cast Browser.document) {
			_getattr = element.getAttribute != null;
			_setattr = element.setAttribute != null;
			_uid = hasAttribute("sru-id") ? attribute("sru-id") : attribute("sru-id", _CNT++);
			_DATA[_uid] = this;
		}
		events = new Dispatcher(this);
		
	}
	
	public function initData():IDataSet {
		if (data == null)
			data = new DataSet();
		return data;
	}
	
	public function dispose():Void {
		Reflect.deleteField(_DATA, _uid + '');
		events.dispose();
		remove();
	}
	
	public function exists(q:String):Bool {
		return element != null && element.querySelector(q) != null;
	}
	
	public function enable(?button:Bool):IDisplay {
		this.style( { pointerEvents:'auto' } );
		if (button == true) cursor('pointer');
		return this;
	}
	
	public function disable():IDisplay {
		this.style({pointerEvents:'none'});
		return this;
	}
	
	public function bg(?data:Either<String,IARGB>, ?repeat:String, ?position:String, ?attachment:String, ?size:String):String {
		if (data != null) {
			var value:Dynamic = cast data;
			if (Std.is(value, IARGB))
				value = value.css();
			if (value.indexOf("#") == 0)
				element.style.background = value;
			else if (value.indexOf("rgb") == 0)
				element.style.backgroundColor = value;
			else{
				style({
					backgroundImage : "url('" + value + "')",
					backgroundRepeat :  repeat != null ? repeat : "no-repeat",
					backgroundPosition : position != null ? position : "center center",
				});
				if (attachment != null)
					style( { backgroundAttachment:attachment } );
				if (size != null)
					style( { backgroundSize:size } );
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
		if (_children == null)
			_children = Sirius.all('*', element);
		return
			_children;
	}
	
	public function getScroll(?o:Dynamic = null):Dynamic {
		if (o == null)
			o = { };
		o.scrollX = element.scrollLeft;
		o.scrollY = element.scrollTop;
		o.x = element.offsetLeft;
		o.y = element.offsetTop;
		o.viewX = o.x - Browser.window.scrollX;
		o.viewY = o.y - Browser.window.scrollY;
		return o;
	}
	
	public function getChild(i:Int, ?update:Bool):IDisplay {
		if (_children == null || update == true)
			_children = children();
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
			if (cast chd.item(cnt) == q.element)
				break;
			++cnt;
		}
		return cnt == len ? -1 : cnt;
	}
	
	public function addChild(q:IDisplay, ?at:Int = -1):IDisplay {
		Reflect.setField(q, '_parent', this);
		if (at != -1) {
			var sw:Node = element.childNodes.item(at);
			element.insertBefore(q.element, sw);
			_children = null;
		}else {
			element.appendChild(q.element);
			if(_children != null){
				_children.elements.push(q.element);
				_children.content.push(q);
			}
		}
		return q;
	}
	
	public function addChildren(q:ITable, ?at:Int = -1):IDisplay {
		var l:IDisplay = null;
		if (at == -1)
			q.each(cast addChild);
		else {
			q.each(function(o:IDisplay) {
				addChild(o, at++);
			});
		}
		return q.obj(q.length()-1);
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
	
	public function removeChildren(min:UInt = 0):IDisplay {
		var t:UInt = children().length();
		while (t > min)
			removeChild(getChild(--t));
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
						if (cl.contains(v)) 
							cl.remove(v);
					}else {
						if (!cl.contains(v)) 
							cl.add(v);
					}
				}
			});
		}
		return element.className;
	}
	
	public function cursor(?value:String):String {
		if (value != null)
			element.style.cursor = value;
		return element.style.cursor;
	}
	
	public function show():Void {
		element.hidden = false;
	}
	
	public function hide():Void {
		element.hidden = true;
	}
	
	public function hasAttribute(name:String):Bool {
		return (_getattr && element.hasAttribute(name)) || Reflect.hasField(element, name);
	}
	
	public function attribute(name:String, ?value:Dynamic):Dynamic {
		if (name != null) {
			var t:String = Reflect.field(element, name);
			if (t != null) {
				if (value != null)
					Reflect.setField(element, name, value);
				return Reflect.field(element, name);
			}
			if (value != null) {
				if (_setattr)
					element.setAttribute(name, value);
				return value;
			}
			if(_getattr)
				return element.getAttribute(name);
		}
		return null;
	}
	
	public function clearAttribute(name:String):Dynamic {
		var value:Dynamic = null;
		if (hasAttribute(name)) {
			if (Reflect.hasField(element, name)) {
				Reflect.deleteField(element, name);
			}else{
				value = attribute(name);
				element.removeAttribute(name);
			}
		}
		return value;
	}
	
	public function attributes(?values:Dynamic):Dynamic {
		if (values != null)
			Dice.All(values, attribute);
		return Utils.getAttributes(this);
	}
	
	public function write(q:Dynamic, ?plainText:Bool = false):IDisplay {
		if (plainText)
			element.innerText += q;
		else element.innerHTML = element.innerHTML + q;
		return this;
	}
	
	public function style(?p:Dynamic,?v:Dynamic):Dynamic {
		if (p != null) {
			if (Std.is(p, String)) {
				if (v != null) 
					Reflect.setField(element.style, p, Std.is(v, IARGB) ? v.css() : Std.string(v));
				v = Reflect.field(trueStyle(), p);
				if (p.toLowerCase().indexOf("color") > 0)
					v = new ARGB(v);
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
		else
			return Browser.window.getComputedStyle(element);
	}
	
	public function mount(q:String, ?data:Dynamic, ?at:Int = -1):IDisplay {
		if (Sirius.resources.exists(q))
			return addChildren(Sirius.resources.build(q, data).children(), at);
		else
			return addChildren(new Display().write(q,false).children(), at);
	}
	
	public function clear(?fast:Bool):IDisplay {
		if (fast) {
			element.innerHTML = "";
		}else{
			var i:Int = element.childNodes.length;
			while (i-- > 0)
				element.removeChild(element.childNodes.item(i));
		}
		return this;
	}
	
	public function on(type:String, handler:Dynamic, ?mode:Dynamic):IDisplay {
		events.on(type, handler, mode);
		return this;
	}
	
	public function fadeTo(value:Float, time:Float = 1):IDisplay {
		tweenTo(time, { opacity:value } );
		return this;
	}
	
	public function tweenTo(time:Float = 1, target:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay {
		if (complete != null)
			target.onComplete = complete;
		if (ease != null)
			target.ease = ease;
		if(element != null){
			Animator.stop(element);
			Animator.to(element, time, target);
		}
		return this;
	}
	
	public function tweenFrom(time:Float = 1, target:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay {
		if (complete != null)
			target.onComplete = complete;
		if (ease != null)
			target.ease = ease;
		if(element != null){
			Animator.stop(element);
			Animator.from(element, time, target);
		}
		return this;
	}
	
	public function tweenFromTo(time:Float = 1, from:Dynamic, to:Dynamic, ?ease:Dynamic, ?complete:Dynamic):IDisplay {
		if (complete != null)
			from.onComplete = complete;
		if (ease != null)
			from.ease = ease;
		if(element != null){
			Animator.stop(element);
			Animator.fromTo(element, time, from, to);
		}
		return this;
	}
	
	public function parent(levels:UInt=0):IDisplay {
		if (_parent == null && element.parentElement != null)
			_parent = Utils.displayFrom(element.parentElement);
		if (levels > 0)
			return _parent.parent(--levels);
		else
			return _parent;
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
		if (rect.top + offsetY >= 0 && rect.left + offsetX >= 0 && rect.bottom - offsetY <= Utils.viewportHeight() && rect.right - offsetX <= Utils.viewportWidth())
			current = 2;
		// IS VISIBLE
		else if (rect.bottom >= 0 && rect.right >= 0 && rect.top <= Utils.viewportHeight() && rect.left <= Utils.viewportWidth())
			current = 1;
		
		// Dispatch visibility change event
		if (current != _visibility) {
			_visibility = current;
			events.visibility().call();
		}
		
		return _visibility;
	}
	
	public function getBounds():DOMRect {
		return this.element.getBoundingClientRect();
	}
	
	public function typeOf():String {
		return "[" + Utils.typeof(this) + "{id:" + _uid + ", element:" + element.tagName + "}]";
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
		if (target != null)
			target.addChild(this);
		else if (Sirius.document != null)
			Sirius.document.body.addChild(this);
		else
			Sirius.run(function() {
				addTo(target);
			});
		return this;
	}
	
	public function addToBody():IDisplay {
		if (Sirius.document != null)
			Sirius.document.body.addChild(this);
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
	
	public function id():UInt {
		return _uid;
	}
	
	public function mouse(?value:Bool):Bool {
		if (value != null) {
			if (value)
				style({pointerEvents:null});
			else
				style({pointerEvents:'none'});
			return value;
		}else {
			return style().pointerEvents;
		}
	}
	
	public function load(url:String, module:String, ?data:Dynamic, ?handler:IRequest->Void):Void {
		Sirius.request(url, data, function(r:IRequest) {
			if (r.success)
				mount(module);
			if (handler != null)
				handler(r);
		});
	}
	
	public function toString():String {
		var data:Dynamic = {
			id:element.id, 
			'sru-id': id,
			'class':element.className,
			index:index(),
			length:length(),
			attributes:Utils.getAttributes(this),
			data:this.data,
		};
		return Json.stringify(data);
	}
	
}