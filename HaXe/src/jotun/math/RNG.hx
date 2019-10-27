package jotun.math;

/**
 * ...
 * @author Rim Project
 */
class RNG {
	
	private var _s:Float;
	
	public function new(?seed:Float=0) {
		set(seed);
	}
	
	public function set(seed:Float):Void {
		_s = seed;
	}
	
	public function get():Float {
		var x:Float = Math.sin(_s) * 10000;
		_s += .01;
		if (_s < 0){
			_s -= _s;
		}
		return x - Math.floor(x);
	}
	
	public function seed():Float {
		return _s;
	}
	
}