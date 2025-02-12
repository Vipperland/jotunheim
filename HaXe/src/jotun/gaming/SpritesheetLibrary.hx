package jotun.gaming;
import haxe.DynamicAccess;
import jotun.dom.Img;
import jotun.utils.Dice;
import js.html.Blob;
import jotun.dom.Sprite;
import jotun.signals.Signals;
import jotun.gaming.Spritesheet;
import jotun.gaming.Spritesheet.FrameData;

typedef EachCursor = {
	var label:String;
	var get:Spritesheet->Void;
	var getSprite:Sprite->Void;
	var getImage:Img->Void;
	var getBlob:Blob->Void;
	var cancel:Void->Void;
}
/**
 * ...
 * @author Rafael Moreira
 */
@:expose('SpritesheetLibrary')
class SpritesheetLibrary {

	public static var EVENT_COMPLETED:String = "completed";
	
	public static var EVENT_PROGRESS:String = "progress";
	
	private var _cached:DynamicAccess<Spritesheet>;
	
	private var _labels:DynamicAccess<Spritesheet>;
	
	public var signals:Signals;
	
	private var _count:Int;
	
	private var _pending:Int;
	
	public function new() {
		_cached = { };
		_labels = { };
		_pending = 0;
		_count = 0;
		signals = new Signals(this);
	}
	
	public function add(name:String, image:Blob, data:Array<FrameData>):Void {
		++_pending;
		++_count;
		_cached.set(name, new Spritesheet(image, data, _onLoad, _onLabel, _onProgress));
	}
	
	private function _onLoad(sprite:Spritesheet):Void {
		if(--_pending == 0){
			signals.call(EVENT_COMPLETED);
		}
	}
	
	private function _onLabel(sprite:Spritesheet, label:String):Void {
		_labels.set(label, sprite);
	}
	
	private function _onProgress(sprite:Spritesheet, cropped:Int, total:Int):Void {
		signals.call(EVENT_PROGRESS, { sprite:sprite, progress: (cropped / total * .5) + (_count - _pending) / _count });
	}
	
	public function get(name:String):Spritesheet {
		return _cached.get(name);
	}
	
	public function getBlob(name:String):Blob {
		return _labels.get(name).getAsBlob(name);
	}
	
	public function getImage(name:String):Img {
		return _labels.get(name).getAsImage(name);
	}
	
	public function getSprite(name:String, ?filter:String, ?loop:Bool, ?optimal:Bool):Sprite {
		return get(name).getAsSprite(filter, loop, optimal);
	}
	
	public function isLoaded():Bool {
		return  _pending <= 0;
	}
	
	public function dispose():Void {
		Dice.Values(_cached, function(sprite:Spritesheet){
			sprite.dispose();
		});
		_cached = { };
	}
	
	public function each(handler:EachCursor->Bool):Void {
		var cur_label:String = null;
		var stop:Bool = false;
		var cursor:Dynamic = {
			label:null,
			get: function(){
				return get(cur_label);
			},
			getSprite: function(){
				return getSprite(cur_label);
			},
			getImage: function(){
				return getImage(cur_label);
			},
			getBlob: function(){
				return getBlob(cur_label);
			},
			cancel: function(){
				stop = true;
			}
		}
		Dice.All(_labels, function(label:String, value:Spritesheet){
			cur_label = cursor.label = label;
			handler(cursor);
			return stop;
		});
	}
	
}