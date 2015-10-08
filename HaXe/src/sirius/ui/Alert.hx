package sirius.ui;
import haxe.ds.Either;
import sirius.dom.Div;
import sirius.dom.Span;
import sirius.dom.Sprite;
import sirius.events.IEvent;
import sirius.math.ARGB;
import sirius.math.IARGB;
import sirius.tools.Utils;
import sirius.transitions.Animator;
import sirius.transitions.Ease;

/**
 * ...
 * @author Rafael Moreira
 */
class Alert {
	
	public var dom:Sprite;
	
	public var content:Div;
	
	private var _a:Bool;
	
	public function new(?bg:Either<String,IARGB>, ?wind:Either<String,IARGB>) {
		
		if (bg == null) bg = cast ARGB.from(0, 0, 0, 0xF0);
		
		dom = new Sprite();
		
		dom.background(bg);
		dom.pin();
		
		dom.content.alignCenter();
		dom.css('padd-10');
		
		content = new Div();
		content.style( {
			minHeight: '200px',
			margin: 'auto 0',
			opacity: 0.0 ,
		});
		
		if (wind != null) content.background(wind);
		
		content.addTo(dom.content);
		dom.events.click(_close);
		
	}
	
	private function _close(?e:IEvent) {
		if (e != null || (cast e.event.target) == dom) {
			hide();
		}
	}
	
	private function _window(?e:IEvent) {
		dom.goFullSize();
	}
	
	public function show():Void {
		if (!_a) {
			Sirius.document.body.events.resize(_window, 1);
			_a = true;
		}
		_window();
		dom.addToBody();
		if (Animator.available()) {
			content.tweenTo(1, { opacity:1 }, Ease.CIRC.IO);
		}else {
			content.style({opacity:1});
		}
	}
	
	public function hide():Void {
		if (_a) {
			Sirius.document.events.resize(_window, 'remove');
			_a = false;
		}
		if (Animator.available()) {
			content.tweenTo(1, { opacity:0 }, Ease.CIRC.IO, dom.remove);
		}
	}
	
}