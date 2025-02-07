package jotun.gaming;
import haxe.DynamicAccess;
import js.Browser;
import js.Syntax;
import js.html.Blob;
import js.html.ImageData;
import js.html.Window;
import jotun.dom.Sprite;
import jotun.signals.Signals;

typedef FrameData = {
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
	
	private var _name:String;
	
	private var _onload:Null<Spritesheet->Void>;
	
	public var _image:Blob;
	
	public var _slices:Array<FrameData>;
	
	public var _progress:Int = 0;
	
	public function new(name:String, image:Blob, data:Array<FrameData>, ?onload:Spritesheet->Void) {
		_onload = onload;
		_frames = [];
		_name = name;
		_progress = 0;
		_image = image;
		_slices = data;
		_cropNext();
	}
	
	function _cropNext():Void {
		if (_progress < _slices.length){
			var frame:FrameData = _slices[_progress];
			++_progress;
			Syntax.code("window.createImageBitmap({0},{1},{2},{3},{4}).then({5})", _image, frame.x, frame.y, frame.w, frame.h, _createBlob);
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
		_frames.push(blob);
		_cropNext();
	}
	
	public function getFrames():Array<Blob> {
		return _frames;
	}
	
	public function getSprite(loop:Bool = false, optimal:Bool = true):Sprite {
		return new Sprite(_frames, loop, optimal);
	}
	
	public function dispose():Void {
		if(_name != null){
			_frames = null;
		}
		_onload = null;
	}
	
}