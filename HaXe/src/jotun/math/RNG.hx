package jotun.math;

/**
 * ...
 * @author Rim Project
 */
@:expose("JRNG")
class RNG {
	
	private var _s:Float;
	private var _l:Float;
	
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
		_l = Math.sin(_s) * 10000;
		_s += .01;
		if (_s < 0){
			_s -= _s;
		}
		_l -= Math.floor(_l);
		return _l;
	}
	
	public function between(a:Float, b:Float):Float {
		if (a > b){
			a = a + b;
			b = a - b;
			a = a - b;
		}
		return get() * ((b) - a) + a;
	}
	
	public function max(a:Float):Float {
		return Std.int(get() * (a));
	}
	
	public function seed():Float {
		return _s;
	}
	
	public function last():Float {
		return _l;
	}
	
}