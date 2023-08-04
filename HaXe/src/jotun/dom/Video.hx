package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.Blob;
import js.html.VideoElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Video")
class Video extends Display {
	
	static public function get(q:String):Video {
		return cast Jotun.one(q);
	}
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createVideoElement();
		super(q, null);
	}
	
	public function play():Void {
		cast(element, VideoElement).play();
	}
	
	public function pause():Void {
		cast(element, VideoElement).pause();
	}
	
	public function togglePause():Void {
		if (cast(element, VideoElement).paused){
			play();
		} else {
			pause();
		}
	}
	
}