package jotun.dom;

import haxe.Json;
import jotun.Jotun;
import jotun.css.XCode;
import jotun.dom.IDisplay;
import jotun.events.Dispatcher;
import jotun.events.IDispatcher;
import jotun.objects.Query;
import jotun.math.ARGB;
import jotun.math.IARGB;
import jotun.math.IPoint;
import jotun.math.Point;
import jotun.net.IProgress;
import jotun.net.IRequest;
import jotun.tools.Ticker;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.utils.IDiceRoll;
import jotun.utils.ITable;
import js.Browser;
import js.html.CSSStyleDeclaration;
import js.html.DOMRect;
import js.html.DOMTokenList;
import js.html.Element;
import js.html.File;
import js.html.FileList;
import js.html.Node;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.dom.Display")
class Display extends Query implements IDisplay {
	
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
	static public function gc(?force:Bool):Void {
		if (force) {
			_DATA = [];
		}else{
			Dice.Values(_DATA, function(v:IDisplay) {
				var id:UInt = v.id();
				if (Jotun.one('[jotun-id=' + id + ']') == null) {
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
		var a:DOMRect = Jotun.document.body.getBounds();
		var b:DOMRect = target.getBoundingClientRect();
		return new Point(b.left - a.left, b.top - a.top);
	}
	
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
			_uid = hasAttribute("jotun-id") ? attribute("jotun-id") : attribute("jotun-id", _CNT++);
			_DATA[_uid] = this;
		}
		events = new Dispatcher(this);
		super();
	}
	
	public function enablePerspective():Void {
		style({
			perspective: '1000px',
			transformOrigin: '50% 50% 0',
		});
	}
	
	public function dispose():Void {
		if(_uid != -1 && element != null){
			Reflect.deleteField(_DATA, _uid + '');
			if(_children != null)
				_children.dispose();
			if(events != null)
				events.dispose();
			all('[jotun-id]').dispose();
			remove();
			element = null;
			_uid = -1;
		}
	}
	
	public function exists(q:String):Bool {
		return element != null && element.querySelector(q) != null;
	}
	
	public function click():IDisplay {
		element.click();
		return this;
	}

	public function all(q:String):ITable {
		return Jotun.all(q, element);
	}
	
	public function one(q:String):IDisplay {
		return Jotun.one(q, element);
	}
	
	public function children():ITable {
		_children = Jotun.all('*', this.element);
		return _children;
	}
	
	public function getScroll(?o:IPoint = null):IPoint {
		if (o == null){
			o = new Point(element.scrollWidth, element.scrollHeight);
		}else{
			o.x = element.scrollWidth;
			o.y = element.scrollHeight;
		}
		return o;
	}
	
	public function setScroll(y:UInt = null, x:UInt = null):Void {
		if (y != null){
			element.scrollTop = y < 0 ? 0 : element.scrollHeight;
		}
		if (x != null){
			element.scrollLeft = x < 0 ? 0 : element.scrollWidth;
		}
	}
	
	public function rect():Dynamic {
		return {
			left: element.scrollLeft,
			top: element.scrollTop,
			offsetX: element.offsetLeft,
			offsetY: element.offsetTop,
			x: element.offsetLeft - Browser.window.scrollX,
			y: element.offsetTop - Browser.window.scrollY,
		};
	}
	
	public function focus():IDisplay {
		if (element != null){
			element.focus();
		}
		return this;
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
		if(parent() != null)
			return _parent.indexOf(this);
		else
			return -1;
	}
	
	public function setIndex(i:UInt):IDisplay {
		if(parent() != null)
			_parent.addChild(this, i);
		return this;
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
		_children = null;
		if (at != -1) {
			var sw:Node = element.childNodes.item(at);
			element.insertBefore(q.element, sw);
		}else {
			element.appendChild(q.element);
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
	
	public function addTextElement(q:String):IDisplay {
		var t:IDisplay = new Text(q);
		addChild(t);
		return t;
	}
	
	public function removeChild(q:IDisplay):IDisplay {
		if(q.element.parentElement == element){
			_children = null;
			q.remove();
		}
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
		if (element != null && element.parentElement != null) element.parentElement.removeChild(element);
		return this;
	}
	
	public function css(?styles:String):String {
		if(styles != null){
			var s:Array<String> = styles.split(" ");
			var cl:DOMTokenList = element.classList;
			Dice.Values(s, function(v:String) {
				if (v != null && v.length > 0) {
					var c:String = v.substr(0, 1);
					if (c == "*") {
						v = v.substr(1, v.length - 1);
						if (cl.contains(v)) 
							cl.remove(v);
						else if (!cl.contains(v)) 
							cl.add(v);
					}else if (c == "/") {
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
	
	public function hasCss(name:String):Bool {
		return (' ' + css() + ' ').indexOf(' ' + name + ' ') != -1;
	}
	
	public function toggle(styles:String):IDisplay {
		Dice.Values(styles.split(' '), function(v:String){
			css((hasCss(v) ? '/' : '') + v); 
		});
		return this;
	}
	
	public function show():Void {
		element.hidden = false;
		element.style.display = null;
		css('/hidden');
	}
	
	public function hide():Void {
		element.hidden = true;
		element.style.display = 'none';
		css('hidden');
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
		if (values != null){
			Dice.All(values, attribute);
			return null;
		}else{
			return Utils.getAttributes(this);
		}
	}
	
	@:overload(function(?q:Int):File{})
	@:overload(function():FileList{})
	@:overload(function(?q:String):String{})
	public function value(?q:Dynamic):Dynamic {
		if (q != null){
			attribute('value', q);
		}
		return attribute('value');
	}
	
	public function writeText(q:Dynamic):IDisplay {
		empty(false);
		element.innerText = q;
		return this;
	}
	
	public function appendText(q:Dynamic):IDisplay {
		element.innerText += q;
		return this;
	}
	
	public function writeHtml(q:Dynamic):IDisplay {
		empty(false);
		element.innerHTML = q;
		return this;
	}
	
	public function appendHtml(q:Dynamic):IDisplay {
		element.innerHTML = element.innerHTML + q;
		return this;
	}
	
	public function colorTransform(r:UInt, g:UInt, b:UInt, ?a:UInt = 255):IDisplay {
		var name:String = 'auto-' + r + 'x' + g + 'x' + b + 'x' + a;
		XCode.createFilter(name, r / 255, g / 255, b / 255, a / 255);
		style('filter', 'url(#' + name + ')');
		return this;
	}
	
	public function displacement(freq:Float, octaves:Int, scale:Int, ?seed:Int = 0):IDisplay {
		var name:String = 'auto-' + Std.int(freq * 10000) + 'x' + octaves + 'x' + scale + 'x' + seed;
		XCode.createDisplacement(name, freq, octaves, scale, seed);
		style('filter', 'url(#' + name + ')');
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
					style(p, v);
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
		if (Jotun.resources.exists(q))
			return addChildren(Jotun.resources.build(q, data).children(), at);
		else
			return addChildren(new Display().writeHtml(q).children(), at);
	}
	
	public function empty(?fast:Bool):IDisplay {
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
	
	public function x(?value:Dynamic):Int {
		if (value != null)
			element.style.left = Std.is(value, String) ? value : value + "px";
		return Std.parseInt(element.style.left);
	}
	
	public function y(?value:Dynamic):Int {
		if (value != null)
			element.style.top = Std.is(value, String) ? value : value + "px";
		return Std.parseInt(element.style.top);
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
	
	public function alpha(?value:Float):Float {
		if (value != null){
			value = (1 - value);
			element.style.opacity = '' + (1 - value);
			return value;
		}else{
			return 1-Std.parseFloat(element.style.opacity);
		}
	}
	
	public function isFullyVisible():Bool {
		return _visibility == 2;
	}
	
	public function isVisible():Bool {
		return _visibility > 0;
	}
	
	public function getVisibility(?offsetY:Int = 0, ?offsetX:Int = 0):UInt {
		
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
		return hasAttribute('sru-dom') ? attribute('sru-dom') : element.tagName;
	}
	
	public function is(tag:Dynamic):Bool {
		if (!Std.is(tag, Array)) tag = [tag];
		var r:IDiceRoll = Dice.Values(tag, function(v:String) {
			v = v.toUpperCase();
			return v == element.tagName || v == attribute('sru-dom');
		});
		return !r.completed;
	}
	
	public function addTo(?target:IDisplay):IDisplay {
		if (target != null)
			target.addChild(this);
		else if (Jotun.document != null)
			Jotun.document.body.addChild(this);
		else
			Jotun.run(function() {
				addTo(target);
			});
		return this;
	}
	
	public function addToBody():IDisplay {
		if (Jotun.document != null)
			Jotun.document.body.addChild(this);
		return this;
	}
	
	public function position():IPoint {
		return getPosition(element);
	}
	
	public function pin(?align:String):IDisplay {
		var v:Int = null;
		var h:Int = null;
		switch(align){
			case 't' : 			{ v = -1; h = 0; };
			case 'tl','lt' : 	{ v = -1; h = -1; }
			case 'l' : 			{ v = 0; h = -1; }
			case 'bl','lb' : 	{ v = 1; h = -1; }
			case 'b' : 			{ v = 1; h = 0; }
			case 'br','rb' : 	{ v = 1; h = 1; }
			case 'r' : 			{ v = 0; h = 1; }
			case 'tr','rt' :	{ v = -1; h = 1; }
			case 'c' :			{ v = 0; h = 0; }
		}
		var o:Dynamic = {position:'fixed'};
		if(v != null){
			if (v < 0){
				o.top = 0;
			}else if (v > 0){
				o.bottom = 0;
			}else{
				o.top = 'calc(50vh - ' + (height()>>1) + 'px)';
			}
		}
		if(v != null){
			if (v < 0){
				o.left = 0;
			}else if (v > 0){
				o.right = 0;
			}else{
				o.left = 'calc(50vw - ' + (width()>>1) + 'px)';
			}
		}
		style(o);
		return this;
	}
	
	public function unpin():IDisplay {
		style({
			position:'',
			left:'',
			right:'',
			bottom:'',
			top:'',
		});
		return this;
	}
	
	public function fit(width:Dynamic, height:Dynamic):IDisplay {
		this.width(width);
		this.height(height);
		return this;
	}
	
	public function id():UInt {
		return _uid;
	}
	
	public function load(url:String, module:String, ?data:Dynamic, ?handler:IRequest->Void, ?headers:Dynamic, ?progress:IProgress->Void):Void {
		if (module != null){
			if (Jotun.resources.exists(module)){
				mount(module, data);
				return;
			}
		}
		Jotun.request(url, data, function(r:IRequest) {
			if (r.success)
				mount(module, data);
			if (handler != null)
				handler(r);
		}, headers, progress);
	}
	
	public function lookAt(?time:Float, ?ease:Dynamic, ?x:Int, ?y:Int):IDisplay {
		Jotun.document.scrollTo(this, time, ease, x, y);
		return this;
	}
	
	public function redoScripts():IDisplay {
		all('script').each(cast function(o:Script){
			o.remove();
			var u:String = o.attribute('src');
			if (u != ''){
				all('script[src="' + u + '"]' ).remove();
				var s:Script = new Script();
				s.src(u);
				addChild(s);
			}
		});
		return this;
	}
	
	public function autoLoad(?progress:IProgress->Void):Void {
		all("[sru-load]").each(function(o:IDisplay){
			var f:String = o.attribute('sru-load');
			var d:Array<String> = f.split('#');
			o.clearAttribute('sru-load');
			o.load(d[0], d.length == 1 ? d[0] : d[1], null, null, null, progress);
		});
	}
	
	public function toString():String {
		var v:Bool = element != null && element.getBoundingClientRect != null;
		var data:Dynamic = {
			id:element.id, 
			'jotun-id': id,
			'class':element.className,
			index:index(),
			length:length(),
			attributes:Utils.getAttributes(this),
		};
		if (v){
			var r:DOMRect = element.getBoundingClientRect();
			data.visibility = getVisibility();
			data.rect = {
				width:r.width,
				height:r.height,
				x1:r.left,
				y1:r.top,
				x2:r.right,
				y2:r.bottom,
			};
		}
		return Json.stringify(data);
	}
	
}