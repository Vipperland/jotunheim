package jotun.math;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_math_RNG")
class RNG {
	
	private var _s:Float;
	
	public function new(?seed:Float) {
		if (seed == null){
			seed = Math.random();
		}
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
	
	public function between(a:Int, b:Int):Int {
		++b;
		return Std.int(get() * (b - a) + a);
	}
	
	public function max(a:Int):Int {
		++a;
		return Std.int(get() * a);
	}
	
	public function seed():Float {
		return _s;
	}
	
}