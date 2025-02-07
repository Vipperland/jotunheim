package jotun.gaming;
import haxe.DynamicAccess;
import jotun.utils.Dice;
import js.html.Blob;
import jotun.dom.Sprite;
import jotun.signals.Signals;
import jotun.gaming.Spritesheet;
import jotun.gaming.Spritesheet.FrameData;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('SpritesheetLibrary')
class SpritesheetLibrary {

	private static var EVENT_COMPLETED:String = "completed";
	
	private static var EVENT_PROGRESS:String = "progress";
	
	private var _cached:DynamicAccess<Spritesheet>;
	
	public var signals:Signals;
	
	private var _pending:Int;
	
	public function new() {
		_cached = { };
		signals = new Signals(this);
	}
	
	public function add(name:String, image:Blob, data:Array<FrameData>):Void {
		++_pending;
		_cached.set(name, new Spritesheet(name, image, data, _onStatus));
	}
	
	public function getDefinition(name:String):Spritesheet {
		return _cached.get(name);
	}
	
	public function getSprite(name:String, loop:Bool = false, optimal:Bool = true):Sprite {
		return getDefinition(name).getSprite(loop, optimal);
	}
	
	private function _onStatus(sprite:Spritesheet):Void {
		if(--_pending == 0){
			signals.call(EVENT_COMPLETED);
		}else{
			signals.call(EVENT_PROGRESS, { queued: _pending });
		}
	}
	
	public function dispose():Void {
		Dice.Values(_cached, function(sprite:Spritesheet){
			sprite.dispose();
		});
		_cached = { };
	}
	
}