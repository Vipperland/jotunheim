package sirius.tools;
import haxe.Log;
import sirius.tools.Key;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.tools.Delayer")
class Delayer {
	
	static private var _tks:Dynamic = { };
	
	public static function create(handler:Dynamic, time:Float, ?args:Array<Dynamic>, ?thisObj:Dynamic):Delayer {
		return new Delayer(handler, time, args, thisObj);
	}
	
	private var _id:String;
	private var _tid:Int;
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
		_tid = untyped __js__("setTimeout(this._tick,this._time,this);");
		return this;
	}
	
	public function cancel():Delayer {
		_cnt = 0;
		if (Reflect.hasField(_tks, _id)) {
			untyped __js__("clearTimeout(this._tid);");
			Reflect.deleteField(_tks, _id);
		}
		return this;
	}
	
	private function _tick(d:Delayer):Void {
		if (d._handler != null) {
			untyped __js__ ("d._handler.call(d._thisObj, d._args)");
			if (d._rpt == 0 || (++d._cnt < d._rpt)) {
				d.call();
			}else {
				d._cnt = 0;
			}
		}
	}
	
}