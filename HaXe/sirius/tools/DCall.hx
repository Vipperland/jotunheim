package sirius.tools;
import sirius.tools.Key;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.tools.DCall")
class DCall {
	
	static private _tks:Dynamic = { };
	
	public static function create(handler:Dynamic, time:Int, args:Array<Dynamic>):DCall {
		return new DCall(handler, time, args);
	}
	
	private var _id:String;
	private var _tid:Int;
	private var _rpt:Int;
	private var _cnt:Int;
	private var _handler:Dynamic;
	private var _time:Int;
	private var _args:Array<Dynamic>;
	
	public function new (h:Dynamic, t:Int, args:Array<Dynamic>) {
		_handler = h;
		_time = t;
		_args = args;
		_cnt = 0;
		_rpt = 1;
	}
	
	public function call(?repeats:Dynamic):Int {
		if (repeats != null) {
			_rpt = repeats;
		}
		if(id == null){
			id = "t" + Key.COUNTER();
			Reflect.setField(_tks, Std.string(id), this);
		}
		_tid = untyped __js__("setTimeout(this._handler," + _time + ");");
	}
	
	public function cancel():Void {
		_cnt = 0;
		if (Reflect.hasField(_tks, id)) {
			untyped __js__("clearTimeout(" + _tid + ");");
			Reflect.deleteField(_tks, _id);
		}
	}
	
	private function _tick() {
		if (_handler != null) {
			untyped __js__ ("this._handler.call(null, this._args)");
			if (_rpt == 0 || (++_cnt < _rpt)) {
				call();
			}else {
				_cnt = 0;
			}
		}
	}
	
}