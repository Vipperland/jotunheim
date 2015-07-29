package sirius.dom;
import js.Browser;
import js.html.Element;
import js.html.MouseEvent;
import sirius.events.IEvent;
import sirius.transitions.Tween;

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
	
	public var element:Element;
	
	public function new() {
		element = Browser.document.documentElement;
		super(cast Browser.document);
		dispatcher.wheel(stopScroll, true);
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
		}else if(Sirius.body.Self.scrollTop != 0){
			o.x = Sirius.body.Self.scrollLeft;
			o.y = Sirius.body.Self.scrollTop;
		}else {
			o.x = element.scrollLeft;
			o.y = element.scrollTop;	
		}
		return o;
	}
	
	public function easeScroll(x:Float, y:Float, time:Float = 1, ease:Dynamic = null):Void {
		stopScroll();
		getScroll(__scroll__);
		Tween.to(__scroll__, time, { x:x, y:y, ease:ease, onUpdate:_applyScroll } );
	}
	
	public function stopScroll() {
		Tween.stop(__scroll__);
	}
	
	public function scrollTo(target:Dynamic, time:Float = 1, ease:Dynamic = null, offX:Int = 0, offY:Int = 0):Void {
		if (Std.is(target, String)) {
			target = Sirius.select(target);
		}
		if (Reflect.hasField(target, "Self")) {
			target = target.Self;
		}
		easeScroll(target.offsetLeft - offX, target.offsetTop - offY, time, ease);
	}
	
	public function trackCursor():Void {
		if (__cursor__.enabled) {
			return;
		}
		__cursor__.enabled = true;
		dispatcher.mouseMove(function(e:IEvent) {
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