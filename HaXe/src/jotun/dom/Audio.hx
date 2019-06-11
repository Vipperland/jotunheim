package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.AudioElement;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.dom.Audio")
class Audio extends Display{

	static public function get(q:String):Audio {
		return cast Jotun.one(q);
	}
	
	public var object:AudioElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createAudioElement();
		super(q, null);
		object = cast element;
	}
	
	public function src(value:String):Void {
		attribute('src', value);
	}
	
	public function play(?reset:Bool):Void {
		if (reset == true){
			object.currentTime = 0;
		}
		object.play();
	}
	
	public function pause():Void {
		object.pause();
	}
	
	public function stop():Void {
		object.pause();
		object.currentTime = 0;
	}
	
	public function volume(?ammount:Float):Float {
		if (ammount != null){
			object.volume = ammount;
		}
		return object.volume;
	}
	
	public function loop(?value:Bool):Bool {
		if (value != null){
			object.loop = value;
		}
		return object.loop;
	}
	
}