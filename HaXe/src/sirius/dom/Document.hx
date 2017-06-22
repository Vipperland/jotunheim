package sirius.dom;
import haxe.Json;
import haxe.Log;
import js.Browser;
import js.Error;
import js.html.AnimationEvent;
import js.html.DOMRect;
import js.html.Element;
import js.html.Event;
import js.html.MouseEvent;
import sirius.css.Automator;
import sirius.events.Dispatcher;
import sirius.events.IDispatcher;
import sirius.events.IEvent;
import sirius.math.IPoint;
import sirius.math.Point;
import sirius.tools.Utils;
import sirius.transitions.Animator;
import sirius.utils.ITable;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Document")
class Document extends Display {
	
	static private var __doc__:Document;
	
	static public function ME():Document {
		return __doc__ == null ? new Document() : __doc__;
	}
	
	public var body:Body;
	
	public var head:Head;
	
	private var __scroll__:Dynamic = { x:0, y:0 };
	
	private var __cursor__:Dynamic = { x:0, y:0 };
	
	private function _applyScroll():Void {
		Browser.window.scroll(__scroll__.x, __scroll__.y);
	}
	
	public function new() {
		if(__doc__ == null){
			super(cast Browser.document);
			element = Browser.document.documentElement;
			
			head = new Head(Browser.document.head);
			events = new Dispatcher(this);
			__doc__ = this;
			__init__();
		}else {
			throw new Error("Document is a singleton, use Document.ME() instead of new");
		}
	}
	
	function __init__() {
		events.wheel(stopScroll, true);
		Browser.window.addEventListener('scroll', _hookScroll);
	}
	
	public function checkBody():Void {
		if(body == null)
			body = new Body(untyped __js__("document.body"));
	}
	
	private function _hookScroll(e:Event):Void {
		events.scroll().call();
	}
	
	public function scroll(x:Float, y:Float):Void {
		Browser.window.scroll(x, y);
	}
	
	public function addScroll(x:Float, y:Float):Void {
		var current:IPoint = getScroll();
		Browser.window.scroll(current.x + x, current.y + y);
	}
	
	public function getScrollRange(?o:IPoint = null, ?pct:Bool = false):IPoint {
		var current:IPoint = getScroll(o);
		if (body != null) {
			current.x /= body.maxScrollX();
			current.y /= body.maxScrollY();
			if (pct) {
				current.x *= 100;
				current.y *= 100;
			}
		}else {
			current.reset();
		}
		return current;
	}
	
	override public function getScroll(?o:Dynamic = null):Dynamic {
		if (o == null) o = {x:0,y:0};
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
	
	public function easeScroll(x:Float, y:Float, time:Float = 1, ease:Dynamic = null):Void {
		stopScroll();
		getScroll(__scroll__);
		Animator.to(__scroll__, time, { x:x, y:y, ease:ease, onUpdate:_applyScroll } );
	}
	
	public function stopScroll(?e:IEvent) {
		Animator.stop(__scroll__);
	}
	
	public function scrollTo(target:Dynamic, time:Float = 1, ease:Dynamic = null, offX:Int = 0, offY:Int = 0):Void {
		if (Std.is(target, String)) 	target = Sirius.one(target).element;
		if (Std.is(target, IDisplay)) 	target = target.element;
		var pos:IPoint = Display.getPosition(target);
		if (Animator.available()) {
			easeScroll(pos.x - offX, pos.y - offY, time, ease);
		}else {
			scroll(pos.x - offX, pos.y - offY);
		}
	}
	
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
	
	public function cursorX():Int {
		return __cursor__.x;
	}
	
	public function cursorY():Int {
		return __cursor__.y;
	}
	
	public function focus(?target:IDisplay):IDisplay {
		if (target != null) target.element.focus();
		return Utils.displayFrom(Browser.document.activeElement);
	}
	
	public function print(selector:String, ?exclude:String = "button, img, .no-print"):Bool {
		var i:ITable = body.children();
		var success:Bool = false;
		if (i.length() > 0) {
			i.hide();
			var content:String = "";
			i.each(function(d:IDisplay) {
				if (!d.is(cast ['script','style'])) {
					content += d.element.outerHTML;
					d.hide();
				}
			});
			if (content.length > 0) {
				var r:IDisplay = new Div();
				r.mount(content);
				r.all(exclude).remove();
				//r.children().each(function(v:IDisplay) {
					//Log.trace(v.trueStyle());
				//});
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