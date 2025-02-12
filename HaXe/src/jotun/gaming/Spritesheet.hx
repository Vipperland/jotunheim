package jotun.gaming;
import haxe.DynamicAccess;
import jotun.dom.Img;
import jotun.utils.Dice;
import js.Browser;
import js.Syntax;
import js.html.Blob;
import js.html.ImageData;
import js.html.Window;
import jotun.dom.Sprite;
import jotun.signals.Signals;

typedef FrameData = {
	var filename:String;
	var frame:FramePosition;
}

typedef FramePosition = {
	var x:Int;
	var y:Int;
	var w:Int;
	var h:Int;
}

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('Spritesheet')
class Spritesheet {

	static private var _type:Dynamic = { type: 'image/png' };
	
	private var _frames:Array<Blob>;
	
	private var _onload:Null<Spritesheet->Void>;
	
	private var _onlabel:Null<Spritesheet->String->Void>;
	
	private var _onprogress:Null<Spritesheet->Int->Int->Void>;
	
	private var _image:Blob;
	
	private var _slices:Array<FrameData>;
	
	private var _current:FrameData;
	
	private var _labels:DynamicAccess<Dynamic>;
	
	private var _progress:Int = 0;
	
	public function new(image:Blob, data:Array<FrameData>, ?onload:Spritesheet->Void, ?onlabel:Spritesheet->String->Void, ?onprogress:Spritesheet->Int->Int->Void) {
		_onload = onload;
		_onlabel = onlabel;
		_onprogress = onprogress;
		_frames = [];
		_progress = 0;
		_labels = { };
		_image = image;
		_slices = data;
		_cropNext();
	}
	
	private function _cropNext():Void {
		if (_progress < _slices.length){
			_current = _slices[_progress];
			++_progress;
			Syntax.code("window.createImageBitmap({0},{1},{2},{3},{4}).then({5})", _image, _current.frame.x, _current.frame.y, _current.frame.w, _current.frame.h, _createBlob);
		}else{
			if(_onload != null){
				_onload(this);
				_onload = null;
			}
			_image = null;
			_slices = null;
		}
	}
	
	private function _createBlob(frame:ImageData):Void {
		var canvas:Dynamic = Syntax.code('new OffscreenCanvas({0},{1})', frame.width, frame.height);
		canvas.getContext('bitmaprenderer').transferFromImageBitmap(frame);
		Syntax.code('canvas.convertToBlob({0}).then({1})', _type, _registerFrame);
	}
	
	private function _registerFrame(blob:Blob):Void {
		if(_current.filename != null){
			_labels.set(_current.filename, _frames.length);
			if(_onlabel != null){
				_onlabel(this, _current.filename);
			}
		}
		_frames.push(blob);
		if(_onprogress != null){
			_onprogress(this, _progress, _slices.length);
		}
		_cropNext();
	}
	
	public function getAsImage(label:Dynamic):Img {
		return Img.fromBlob(getAsBlob(_labels.get(label)));
	}
	
	public function getAsBlob(label:Dynamic):Blob {
		if(Std.isOfType(label, String)){
			return _labels.get(label);
		}else{
			return _frames[label];
		}
	}
	
	public function getAsSprite(?filter:String, ?loop:Bool = false, ?optimal:Bool):Sprite {
		if (filter != null){
			var result:Sprite = new Sprite(null, loop, optimal);
			Dice.Values(_labels, function(p:String, v:Blob):Void{
				result.addFrame(v);
			});
			return result;
		}else{
			return new Sprite(_frames, loop, optimal);
		}
	}
	
	public function getFrames():Array<Blob> {
		return _frames;
	}
	
	public function dispose():Void {
		_frames = null;
		_onload = null;
	}
	
}