package sirius.dom;
import js.Browser;
import js.html.VideoElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.dom.Video")
class Video extends Display {
	
	public var object:VideoElement;
	
	public static function get(q:String, ?h:IDisplay->Void):Video {
		return cast Sirius.one(q,null,h);
	}
	
	public function new(?q:Dynamic, ?d:String = null) {
		if (q == null) q = Browser.document.createVideoElement();
		super(q, null, d);
		object = cast element;
	}
	
	public function play():Void {
		object.play();
	}
	
	public function pause():Void {
		object.pause();
	}
	
	public function togglePause():Void {
		if (object.paused)	play();
		else 				pause();
	}
	
}