package jotun.dom;

import haxe.Json;
import haxe.Rest;
import haxe.extern.EitherType;
import jotun.Jotun;
import jotun.css.XCode;
import jotun.data.Logger;
import jotun.dom.Displayable;
import jotun.events.EventDispatcher;
import jotun.events.EventGroup;
import jotun.math.Matrix3D;
import jotun.math.Point;
import jotun.objects.Query;
import jotun.timer.DelayedCall;
import jotun.timer.MotionStep;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.utils.Filler;
import jotun.utils.IDiceRoll;
import jotun.utils.ITable;
import jotun.utils.Reactor;
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
@:expose("Jtn.Display")
class Display extends Query implements Displayable {
	
	private static var _CNT:UInt = 0;
	
	private static var _DATA:Dynamic = {};
	
	/**
	 * Create a display by element type 
	 * @param	q
	 * @return
	 */
	public static function ofKind(q:String):Displayable {
		return Utils.displayFrom(Browser.document.createElement(q));
	}
	
	/**
	 * Prevent a cretion of a new Display instance for same element
	 * @param	id
	 * @return
	 */
	public static function fromGC(id:UInt):Displayable {
		return Reflect.field(_DATA, ''+id);
	}
	
	/**
	 * Remove all display from cache if not connected
	 * @param	secure
	 */
	static public function clearCache():Void {
		var count:Int = 0;
		Dice.Values(_DATA, function(v:Displayable) {
			if (v.element == null || !v.element.isConnected) {
				v.dispose();
				++count;
			}
		});
		if(count > 0){
			Jotun.log('CACHE: ' + count + ' removed', Logger.SYSTEM);
		}
	}
	
	/**
	 * Remove all idle elements from cache if not connected
	 */
	static public function clearIdles():Void {
		var time:Int = (cast Date.now().getTime()) >> 0;
		var count:Int = 0;
		var idle:Int = 0;
		var awake:Int = 0;
		Dice.Values(_DATA, function(v:Displayable):Void {
			if(v.element != null){
				if (!v.element.isConnected){
					if(v.data.idleTime == null){
						v.data.idleTime = time;
						++idle;
					}else{
						if((time - v.data.idleTime) > 900000){
							v.dispose();
							++count;
						}else{
							++idle;
						}
					}
				}else if(v.data.idleTime != null){
					Reflect.deleteField(v.data, 'idleTime');
					++awake;
				}
			}
		});
		if(count > 0 || idle > 0 || awake > 0){
			Jotun.log('CACHE: ' + count + ' removed, ' + idle + ' idle, ' + awake + ' awake', Logger.SYSTEM);
		}
	}
	
	private var _uid:UInt;
	
	private var _parent:Displayable;
	
	private var _children:ITable;
	
	private var _visibility:Int;
	
	private var _getattr:Bool;
	
	private var _setattr:Bool;
	
	public var data:Dynamic;
	
	public var element:Element;
	
	public var events:EventDispatcher;
	
	private function _tickMotion(timeline:Rest<MotionStep>):Void {
		var steps:Array<MotionStep> = timeline.toArray();
		if (steps.length > 0){
			var step:MotionStep = steps.shift();
			if (step.css != null){
				css(step.css);
			}
			if (step.delay != null && step.delay > 0){
				data._timeline = Jotun.timer.delayed(_tickMotion, step.delay, 0, steps);
			}else{
				Reflect.callMethod(null, _tickMotion, steps);
			}
			if(step.callback != null){
				step.callback(this);
			}
		}else{
			Reflect.deleteField(data, '_timeline');
		}
	}
	
	private function _style_set(p:Dynamic, v:Dynamic):Void {
		if (Std.isOfType(p, String) && v != null) {
			Reflect.setField(element.style, p, Std.string(v));
		}
	}
	
	private function _style_get(p:Dynamic):Dynamic {
		return Reflect.field(trueStyle(), p);
	}
	
	public function new(?q:Dynamic = null, ?t:Element = null) {
		if (q == null){
			q = Browser.document.createDivElement();
		}
		if (Reflect.hasField(q, 'element')){
			element = q.element;
		} else {
			element = q;
		}
		if (element != cast Browser.document) {
			_getattr = element.getAttribute != null;
			_setattr = element.setAttribute != null;
			_uid = (cast element)._uid != null ? (cast element)._uid : Std.int(attribute("jtn-id", _CNT++));
			_DATA[_uid] = this;
		}
		(cast element)._uid = _uid;
		data = (cast element).data = {};
		events = new EventDispatcher(this);
		super();
	}
	
	public function perspective(value:String='1000px', origin:String='50% 50% 0'):Void {
		style({
			perspective: value,
			transformOrigin: origin,
		});
	}
	
	public function exists(q:String):Bool {
		return element.querySelector(q) != null;
	}
	
	public function click():Displayable {
		element.click();
		return this;
	}

	public function all(q:String):ITable {
		return Jotun.all(q, element);
	}
	
	public function one(q:String):Displayable {
		return Jotun.one(q, element);
	}
	
	public function children():ITable {
		_children = Jotun.all('*', this.element);
		return _children;
	}
	
	public function getScrollBounds(?o:Point = null):Point {
		if (o == null){
			o = new Point(element.scrollWidth, element.scrollHeight);
		}else{
			o.x = element.scrollWidth;
			o.y = element.scrollHeight;
		}
		return o;
	}
	
	public function getScroll(?o:Point = null):Point {
		if (o == null){
			o = new Point(element.scrollLeft, element.scrollTop);
		}else{
			o.x = element.scrollLeft;
			o.y = element.scrollTop;
		}
		return o;
	}
	
	public function isEditable():Bool {
		return element.isContentEditable;
	}
	
	
	public function addScroll(x:Int, y:Int, ease:Bool = true):Void {
		element.scrollBy(cast {
			top:y,
			left:x,
			behavior: ease ? 'smooth' : 'auto',
		});
	}
	
	
	public function setScroll(x:Int, y:Int):Void {
		element.scroll(cast {
			top:y,
			left:x,
			behavior:'smooth',
		});
	}
	
	public function focus():Displayable {
		element.focus();
		return this;
	}
	
	public function getChild(i:Int, ?update:Bool):Displayable {
		if (_children == null || update == true){
			_children = children();
		}
		return cast _children.obj(i);
	}
	
	public function length():Int {
		return element.childNodes.length;
	}
	
	public function index():Int {
		if (parent() != null){
			return _parent.indexOf(this);
		} else{
			return -1;
		}
	}
	
	public function setIndex(i:UInt):Displayable {
		if (parent() != null){
			_parent.addChild(this, i);
		}
		return this;
	}
	
	public function indexOf(q:Displayable):Int {
		var chd = element.childNodes;
		var len = chd.length;
		var cnt = 0;
		while (cnt < len) {
			if (cast chd.item(cnt) == q.element){
				break;
			}
			++cnt;
		}
		return cnt == len ? -1 : cnt;
	}
	
	public function addChild(q:Displayable, ?at:Int = -1):Displayable {
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
	
	public function addChildren(q:ITable, ?at:Int = -1):Displayable {
		var l:Displayable = null;
		if (at == -1){
			q.each(cast addChild);
		} else {
			q.each(function(o:Displayable) {
				addChild(o, at++);
			});
		}
		return q.obj(q.length()-1);
	}
	
	public function addTextElement(q:String):Displayable {
		var t:Displayable = new Text(q);
		addChild(t);
		return t;
	}
	
	public function removeChild(q:Displayable):Displayable {
		if(q.element.parentElement == element){
			_children = null;
			q.remove();
		}
		return q;
	}
	
	public function removeChildAt(index:Int):Displayable {
		var child:Displayable = getChild(index, true);
		return child != null ? child.remove() : null;
	}
	
	public function removeFirstChild():Displayable {
		return removeChildAt(0);
	}
	
	public function removeLastChild():Displayable {
		return removeChildAt(length());
	}
	
	public function removeChildren(min:UInt = 0):Displayable {
		var t:UInt = children().length();
		while (t > min){
			removeChild(getChild(--t));
		}
		return this;
	}
	
	public function remove():Displayable {
		this._parent = null;
		if (element.parentElement != null) element.parentElement.removeChild(element);
		return this;
	}
	
	public function rotateX(x:Float):Displayable {
		data.__changed = true;
		data.__rotationX = Matrix3D.rotateX(x);
		return this;
	}
	
	public function rotateY(x:Float):Displayable {
		data.__changed = true;
		data.__rotationY = Matrix3D.rotateY(x);
		return this;
	}
	
	public function rotateZ(x:Float):Displayable {
		data.__changed = true;
		data.__rotationZ = Matrix3D.rotateZ(x);
		return this;
	}
	
	public function rotate(x:Float, y:Float, z:Float):Displayable {
		if (x != null) {
			rotateX(x);
		}
		if (y != null) {
			rotateY(y);
		}
		if (z != null) {
			rotateZ(z);
		}
		return this;
	}
	
	public function translate(x:Float, y:Float, z:Float):Displayable {
		data.__changed = true;
		data.__translation = Matrix3D.translate(x, y, z);
		return this;
	}
	
	public function scale(x:Float, y:Float, z:Float):Displayable {
		data.__changed = true;
		data.__scale = Matrix3D.scale(x, y, z);
		return this;
	}
	
	public function transform():Displayable {
		if (data.__changed){
			var t:Array<Array<Float>> = data.__transform;
			if (t == null) {
				t = [];
				data.__transform = t;
				style('transformStyle', 'preserve-3d');
				style('transformOrigin', '50% 50% 0');
				css('element3d');
			}
			data.__changed = false;
			t[0] = data.__rotationX;
			t[1] = data.__rotationZ;
			t[2] = data.__scale;
			t[3] = data.__rotationY;
			t[4] = data.__translation;
			style('transform', 'matrix3d(' + Matrix3D.multiply(t).join(',') + ')');
		}
		return this;
	}
	
	public function enable():Void {
		style('pointerEvents', 'all');
		Reflect.deleteField(data, '__disabled');
		events.each(function(v:EventGroup):Bool {
			v.enabled = true;
			return false;
		});
	}
	
	public function disable():Void {
		style('pointerEvents', 'none');
		Reflect.setField(data, '__disabled', true);
		events.each(function(v:EventGroup):Bool {
			v.enabled = false;
			return false;
		});
	}
	
	public function isEnabled():Bool {
		return data.__disabled == true;
	}
	
	public function cursor(q:EitherType<String,Bool>):Void {
		style('cursor', q == true ? 'pointer' : q == null ? 'none' : q);
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
						if (cl.contains(v)) {
							cl.remove(v);
						}
						else if (!cl.contains(v)) {
							cl.add(v);
						}
					}else if (c == "/") {
						v = v.substr(1, v.length - 1);
						if (cl.contains(v)) {
							cl.remove(v);
						}
					}else {
						if (!cl.contains(v)) {
							cl.add(v);
						}
					}
				}
			});
		}
		return element.className;
	}
	
	public function hasCss(name:String):Bool {
		return element.classList.contains(name);
	}
	
	public function toggle(styles:String):Displayable {
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
				if (value != null){
					Reflect.setField(element, name, value);
				}
				return Reflect.field(element, name);
			}
			if (value != null) {
				if (_setattr){
					element.setAttribute(name, value);
				}
				return value;
			}
			if (_getattr){
				return element.getAttribute(name);
			}
		}
		return null;
	}
	
	public function incremental(name:String, ammount:Float):Float {
		var current:Float = hasAttribute(name) ? Std.parseFloat(attribute(name)) : 0;
		return attribute(name, current + ammount) * 1;
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
			Dice.All(values, function(p:String, v:Dynamic){
				attribute(p, v);
			});
			return null;
		}else{
			return Utils.getAttributes(this);
		}
	}
	
	@:overload(function(?q:Int):File{})
	@:overload(function():FileList{})
	@:overload(function(?q:String):String{})
	public function value(?q:Dynamic):Dynamic {
		if(element.isContentEditable){
			if (q != null){
				element.innerHTML = q;
			}
			return element.innerHTML;
		}
		if (q != null){
			attribute('value', q);
		}
		return attribute('value');
	}
	
	public function writeText(q:Dynamic):Displayable {
		empty(false);
		element.innerText = q;
		return this;
	}
	
	public function appendText(q:Dynamic):Displayable {
		element.innerText += q;
		return this;
	}
	
	public function writeHtml(q:Dynamic):Displayable {
		empty(false);
		element.innerHTML = q;
		return this;
	}
	
	public function appendHtml(q:Dynamic):Displayable {
		element.innerHTML = element.innerHTML + q;
		return this;
	}
	
	public function colorTransform(r:Float, g:Float, b:Float, ?a:Float = 1):Displayable {
		var name:String = 'svgColor_' + _uid;
		XCode.filter(name, a, r, g, b, true);
		filters(name);
		return this;
	}
	
	public function displacement(freq:Float, octaves:Int, scale:Int, ?seed:Int = 0):Displayable {
		var name:String = 'svgDisp_' + _uid;
		XCode.displacement(name, freq, octaves, scale, seed, true);
		filters(name);
		return this;
	}
	
	public function imageFilter(id:String, data:String, width:String, height:String, x:String, y:String):Displayable {
		var name:String = 'imgFtr_' + _uid;
		XCode.imageFilter(name, data, width, height, x, y, true);
		filters(name);
		return this;
	}
	
	public function filters(name:Dynamic):Void {
		style('filter', 'url(#' + name + ')');
	}
	
	public function style(?p:Dynamic,?v:Dynamic):Dynamic {
		if (p != null) {
			if (Std.isOfType(p, String)) {
				if (v == null){
					return _style_get(p);
				}else{
					_style_set(p, v);
				}
			}else {
				Dice.All(p, function(p:Dynamic, v:Dynamic):Void {
					_style_set(p, v);
				});
				return null;
			}
		}
		return trueStyle();
	}
	
	public function trueStyle():CSSStyleDeclaration {
		if (Browser.document.defaultView.opener != null) {
			return Browser.document.defaultView.getComputedStyle(element);
		} else{
			return Browser.window.getComputedStyle(element);
		}
	}
	
	public function mount(q:String, ?data:Dynamic, ?at:Int = -1):Displayable {
		if (Std.isOfType(data, Int) && at == -1){
			at = data >> 0;
		}
		if (Jotun.resources.exists(q)){
			return addChildren(Jotun.resources.build(q, data).children(), at);
		} else {
			if (data != null){
				q = Filler.to(q, data);
			}
			return addChildren(new Display().writeHtml(q).children(), at);
		}
	}
	
	public function empty(?fast:Bool):Displayable {
		if (fast) {
			element.innerHTML = "";
		}else{
			var i:Int = element.childNodes.length;
			while (i-- > 0){
				element.removeChild(element.childNodes.item(i));
			}
		}
		return this;
	}
	
	public function on(type:String, handler:Dynamic, ?mode:Dynamic):Displayable {
		events.on(type, handler, mode);
		return this;
	}
	
	public function parent(levels:UInt=0):Displayable {
		if (_parent == null && element.parentElement != null){
			_parent = Utils.displayFrom(element.parentElement);
		}
		if (levels > 0){
			return _parent.parent(--levels);
		} else {
			return _parent;
		}
	}
	
	public function parentQuery(q:String):Displayable {
		if (!is('html')){
			if (parent().matches(q)){
				return parent();
			}else{
				return parent().parentQuery(q);
			}
		}
		return null;
	}
	
	public function matches(q:String):Bool {
		return element != null && element.matches(q);
	}
	
	public function x(?value:Dynamic):Int {
		if (value != null)
			element.style.left = Std.isOfType(value, String) ? value : value + "px";
		return Std.parseInt(element.style.left);
	}
	
	public function y(?value:Dynamic):Int {
		if (value != null)
			element.style.top = Std.isOfType(value, String) ? value : value + "px";
		return Std.parseInt(element.style.top);
	}
	
	public function width(?value:Dynamic):Int {
		if (value != null)
			element.style.width = Std.isOfType(value, String) ? value : value + "px";
		return element.clientWidth;
	}
	
	public function height(?value:Dynamic):Int {
		if (value != null)
			element.style.height = Std.isOfType(value, String) ? value : value + "px";
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
		var rect:DOMRect = getBounds();
		var current:Int = 0;
		// IS FULLY VISIBLE
		if (rect.top + offsetY >= 0 && rect.left + offsetX >= 0 && rect.bottom - offsetY <= Utils.viewportHeight() && rect.right - offsetX <= Utils.viewportWidth()){
			current = 2;
		} else if (rect.bottom >= 0 && rect.right >= 0 && rect.top <= Utils.viewportHeight() && rect.left <= Utils.viewportWidth()){ 
			// IS VISIBLE
			current = 1;
		}
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
		return hasAttribute('jtn-dom') ? attribute('jtn-dom') : element.tagName;
	}
	
	public function is(tag:Dynamic):Bool {
		if (!Std.isOfType(tag, Array)) tag = [tag];
		var r:IDiceRoll = Dice.Values(tag, function(v:String) {
			v = v.toUpperCase();
			return v == element.tagName || v == attribute('jtn-dom');
		});
		return !r.completed;
	}
	
	public function addTo(?target:Displayable):Displayable {
		if (target != null){
			target.addChild(this);
		} else if (Jotun.document != null){
			Jotun.document.body.addChild(this);
		} else{
			Jotun.run(function() {
				addTo(target);
			});
		}
		return this;
	}
	
	public function addToBody():Displayable {
		if (Jotun.document != null){
			Jotun.document.body.addChild(this);
		}
		return this;
	}
	
	public function position():Point {
		return Utils.getPosition(element);
	}
	
	public function fit(width:Dynamic, height:Dynamic):Displayable {
		this.width(width == null ? this.width() : width);
		this.height(height == null ? this.height() : height);
		return this;
	}
	
	public function id():UInt {
		return _uid;
	}
	
	public function ref(?value:String):String {
		if (value != null){
			element.id = value;
		}
		return element.id;
	}
	
	public function lookAt(?y:Int, ?x:Int):Displayable {
		Jotun.document.scrollTo(this, y, x);
		return this;
	}
	
	public function reloadScripts():Displayable {
		all('script').each(cast function(o:Script){
			o.remove();
			var u:String = o.attribute('src');
			if (Utils.isValid(u)){
				all('script[src="' + u + '"]' ).remove();
				var s:Script = new Script();
				s.src(u);
				addChild(s);
			}
		});
		return this;
	}
	
	public function react(data:Dynamic):Void {
		if (Std.isOfType(data, String)){
			data = Json.parse(data);
		}
		Reactor.apply(this, data);
	}
	
	public function rectangle():Dynamic {
		var r:DOMRect = getBounds();
		return {
			width:r.width,
			height:r.height,
			x1:r.left,
			y1:r.top,
			x2:r.right,
			y2:r.bottom,
		};
	}
	
	public function location():Dynamic {
		return {
			left: element.scrollLeft,
			top: element.scrollTop,
			offsetX: element.offsetLeft,
			offsetY: element.offsetTop,
			x: element.offsetLeft - Browser.window.scrollX,
			y: element.offsetTop - Browser.window.scrollY,
		};
	}
	
	public function previous():Displayable {
		return Utils.displayFrom(element.previousElementSibling);
	}
	
	public function next():Displayable {
		return Utils.displayFrom(element.nextElementSibling);
	}
	
	public function run(method:Displayable->Void):Displayable {
		method(this);
		return this;
	}
	
	public function stopMotion():Void {
		var current:DelayedCall = data._timeline;
		if(current != null){
			current.cancel();
			data._timeline = null;
		}
	}
	
	public function motion(timeline:Array<MotionStep>):Void {
		stopMotion();
		Reflect.callMethod(this, _tickMotion, timeline);
	}
	
	public function dispose():Void {
		if (_uid != -1 && element != null){
			stopMotion();
			Reflect.deleteField(_DATA, ''+_uid);
			if (_children != null){
				_children.dispose();
			}
			if (events != null){
				events.dispose();
			}
			all('[jtn-id]').dispose();
			remove();
			element = null;
			_uid = -1;
		}
	}
	
	public function clone(?deep:Bool):Displayable {
		clearAttribute('jtn-id');
		var copy:Displayable = new Display().writeHtml(element.outerHTML).getChild(0);
		copy.attribute('jtn-copy-of', _uid);
		attribute('jtn-id', _uid);
		if (deep){
			copy.events.cloneFrom(events);
		}
		return copy;
	}
	
	public function isClone():Bool {
		return hasAttribute('jtn-copy-of');
	}
	
	public function getOriginal():Displayable {
		return fromGC(Std.int(attribute('jtn-copy-of')));
	}
	
	public function toString():String {
		var v:Bool = element.getBoundingClientRect != null;
		var data:Dynamic = {
			id:element.id, 
			'jtn-id': (cast element)._uid,
			'class':element.className,
			index:index(),
			length:length(),
			attributes:Utils.getAttributes(this),
		};
		if (v){
			data.visibility = getVisibility();
			data.rect = rectangle();
		}
		return Json.stringify(data);
	}
	
}