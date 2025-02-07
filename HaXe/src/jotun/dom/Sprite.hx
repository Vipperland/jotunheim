package jotun.dom;
import js.html.Blob;
import jotun.dom.Img;
import jotun.signals.Signals;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("Jtn.Sprite")
class Sprite extends Img {

	private var _frames:Array<Blob>;
	
	private var _frame:Int = 0;
	
	private var _loop:Bool;
	
	private var _reverse:Bool;
	
	private var _optimal:Bool;
	
	private var signals:Signals;
	
	public function new(frames:Array<Blob>, loop:Bool = false, optimal:Bool = true) {
		super(null);
		_loop = loop;
		_frames = frames != null ? frames : [];
		_optimal = optimal;
		if (!optimal){
			signals = new Signals(this);
		}
	}
	
	public function addFrame(data:Blob):Void {
		_frames.push(data);
		if(_frames.length == 1){
			src(data);
		}
	}
	
	public function goto(frame:Int):Void {
		if(frame < _frames.length){
			_frame = frame;
			refresh();
		}
	}
	
	public function advance():Void {
		if(_reverse){
			prevFrame();
		}else{
			nextFrame();
		}
	}
	
	public function nextFrame():Void {
		if (_frame < _frames.length - 1){
			++_frame;
			refresh();
		}else if(_loop){
			_frame = 0;
			refresh();
			if (!_optimal){
				signals.call('loop');
			}
		}else{
			if (!_optimal){
				signals.call('end');
			}
		}
	}
	
	public function prevFrame():Void {
		if (_frame > 0){
			--_frame;
			refresh();
		}else if(_loop){
			_frame = _frames.length;
			refresh();
			if (!_optimal){
				signals.call('loop');
			}
		}else{
			if (!_optimal){
				signals.call('end');
			}
		}
	}
	
	public function setLoop(mode:Bool):Void {
		_loop = mode;
	}
	
	public function setReverse(mode:Bool):Void {
		_reverse = mode;
	}
	
	public function isReversed():Bool {
		return _reverse;
	}
	
	public function refresh():Void {
		src(_frames[_frame]);
	}
	
	public function reset():Void {
		_frames = [];
	}
	
	override public function dispose():Void {
		if(signals != null){
			signals.dispose();
			signals = null;
		}
		_frames = null;
		super.dispose();
	}
	
}