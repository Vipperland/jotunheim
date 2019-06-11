package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.VideoElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.dom.Video")
class Video extends Display {
	
	static public function get(q:String):Video {
		return cast Jotun.one(q);
	}
	
	public var object:VideoElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createVideoElement();
		super(q, null);
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