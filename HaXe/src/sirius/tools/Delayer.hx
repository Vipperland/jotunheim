package sirius.tools;
import haxe.Log;
import haxe.Timer;
import sirius.tools.Key;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.tools.Delayer")
class Delayer {
	
	static public var setTimeout:Dynamic->UInt->Array<Dynamic>->Int = untyped __js__('setTimeout');
	static public var clearTimeout:UInt->Void = untyped __js__('clearTimeout');
	
	static public var setInterval:Dynamic->UInt->Array<Dynamic>->Int = untyped __js__('setInterval');
	static public var clearInterval:UInt->Void = untyped __js__('clearInterval');
	
	static private var _tks:Dynamic = { };
	
	public static function create(handler:Dynamic, time:Float, ?args:Array<Dynamic>, ?thisObj:Dynamic):Delayer {
		return new Delayer(handler, time, args, thisObj);
	}
	
	private var _id:String;
	private var _tid:Timer;
	private var _rpt:Int;
	private var _cnt:Int;
	private var _handler:Dynamic;
	private var _this:Dynamic;
	private var _time:Int;
	private var _args:Array<Dynamic>;
	
	public function new (handler:Dynamic, time:Float, ?args:Array<Dynamic>, thisObj:Dynamic) {
		_this = thisObj;
		_handler = handler;
		_time = Std.int(time * 1000);
		_args = args;
		_cnt = 0;
		_rpt = 1;
	}
	
	public function call(?repeats:Int):Delayer {
		if (repeats != null) {
			_rpt = repeats;
		}
		if(_id == null){
			_id = "t" + Key.COUNTER();
			Reflect.setField(_tks, Std.string(_id), this);
		}
		_tid = Timer.delay(_tick, _time);
		_tid.run();
		return this;
	}
	
	public function cancel():Delayer {
		_cnt = 0;
		if (_tid != null) {
			_tid.stop();
			_tid = null;
		}
		return this;
	}
	
	private function _tick():Void {
		if (_handler != null) {
			_tid = null;
			Reflect.callMethod(_this, _handler, _args);
			if (_rpt == 0 || (++_cnt < _rpt)) {
				call();
			}else {
				_cnt = 0;
			}
		}
	}
	
}