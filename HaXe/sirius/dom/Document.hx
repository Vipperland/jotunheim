package sirius.dom;
import js.Browser;
import js.html.Element;
import js.html.MouseEvent;
import sirius.events.IEvent;
import sirius.transitions.Animator;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Document")
class Document extends Display {
	
	static private var __scroll__:Dynamic = { x:0, y:0 };
	
	static private var __cursor__:Dynamic = { x:0, y:0 };
	
	static private function _applyScroll():Void {
		Browser.window.scroll(__scroll__.x, __scroll__.y);
	}
	
	public function new() {
		super(cast Browser.document);
		element = Browser.document.documentElement;
		events.wheel(stopScroll, true);
		prepare();
	}
	
	public function scroll(x:Float, y:Float):Void {
		Browser.window.scroll(x, y);
	}
	
	override public function getScroll(?o:Dynamic=null):Dynamic {
		if (o == null) o = { x:0, y:0 };
		if (Browser.window.pageXOffset != null) {
			o.x = Browser.window.pageXOffset;
			o.y = Browser.window.pageYOffset;
		}else if(Sirius.body.element.scrollTop != 0){
			o.x = Sirius.body.element.scrollLeft;
			o.y = Sirius.body.element.scrollTop;
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
	
	public function stopScroll() {
		Animator.stop(__scroll__);
	}
	
	public function scrollTo(target:Dynamic, time:Float = 1, ease:Dynamic = null, offX:Int = 0, offY:Int = 0):Void {
		if (Std.is(target, String)) {
			target = Sirius.select(target);
		}
		if (Reflect.hasField(target, "element")) {
			target = target.Self;
		}
		easeScroll(target.offsetLeft - offX, target.offsetTop - offY, time, ease);
	}
	
	public function trackCursor():Void {
		if (__cursor__.enabled) {
			return;
		}
		__cursor__.enabled = true;
		events.mouseMove(function(e:IEvent) {
			var me:MouseEvent = cast e.event;
			__cursor__.x = me.clientX;
			__cursor__.y = me.clientY;
		}, true);
	}
	
	public function cursorX():Int {
		return __cursor__.x;
	}
	
	public function cursorY():Int {
		return __cursor__.y;
	}
	
}