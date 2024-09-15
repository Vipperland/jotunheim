package jotun.gaming.actions;
import haxe.DynamicAccess;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.ActionQuery;
import jotun.gaming.actions.EventController;
import jotun.gaming.actions.EventContext;
import jotun.gaming.actions.Resolution;
import jotun.timer.DelayedCall;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_Events")
class Events {
	
	public static function patch(data:DynamicAccess<Events>, ?validate:String->DynamicAccess<Dynamic>->String):DynamicAccess<Events> {
		var patched:DynamicAccess<Events> = { };
		if (data != null){
			Dice.All(data, function(p:String, v:Dynamic):Void {
				p = (validate == null ? p : validate(p, v));
				if(p != null && p != ""){
					if (!Std.isOfType(v, Events)){
						patched.set(p, new Events(p, v));
					}else{
						patched.set(p, v);
					}
				}
				
			});
		}
		return patched;
	}
	
	private var _data:Array<Action>;
	private var _type:String;
	private var _save:Int->Resolution->Void;
	private var _load:Int->String->Resolution;
	private var _is_waiting:Bool;
	private var _cursor_pos:Int;
	private var _context:EventContext;
	private var _delayed:DelayedCall;
	
	public function new(type:String, data:Array<Dynamic>) {
		_type = type;
		_init(data);
	}
	
	public function _init(data:Array<Dynamic>) {
		_data = [];
		var i:UInt = 0;
		var r:Dynamic = {};
		Dice.All(data, function(p:String, v:Dynamic):Void {
			if (Std.isOfType(v, String)){
				v = EventController.loadAction(v);
			}
			if (v != null && (v.id == null || !Reflect.hasField(r, v.id))){
				if (Std.isOfType(v, Action)){
					_data[i] = v;
				}else{
					_data[i] = new Action(_type + '[' + p + ']', v);
				}
				if (v.id != null){
					Reflect.setField(r, v.id, 1);
				}
				++i;
			}
		});
	}
	
	public function getType():String {
		return _type;
	}
	
	public function matchType(q:String):Bool {
		return _type == q;
	}
	
	#if js
	
	private function _unblock():Void {
		if (_delayed != null){
			_delayed.cancel();
			_delayed = null;
		}
	}
	
	public function wait(?time:Float):Void {
		if(canWait()){
			_unblock();
			_is_waiting = true;
			if(time == null && time <= 0){
				time = 3600;
			}
			_delayed = Jotun.timer.delayed(release, time, 0);
		}
	}
	
	public function release():Void {
		_unblock();
		if (_is_waiting){
			_is_waiting = false;
			_innerRun();
		}
	}
	
	#end
	
	private function _innerRun():Void {
		var a:Action = null;
		Dice.Count(_cursor_pos, _data.length, function(current:Int, max:Int, completed:Bool):Bool {
			++_cursor_pos;
			_context.registerEvent(this);
			a = _data[current];
			if (a.willBreakOn(a.run(_context, current))){
				_is_waiting = false;
				return true;
			}else {
				return _is_waiting;
			}
		});
		if(_is_waiting == false){
			--_context.ident;
			if (_context.ident == 0){
				if (_context.debug){
					_log(this, _context);
					_context.log.reverse();
				}
			}
			_context = null;
		}
	}
	
	public function canWait():Bool {
		return _cursor_pos < _data.length;
	}
	
	public function run(context:EventContext):Void {
		_is_waiting = false;
		_cursor_pos = 0;
		_context = context;
		++context.ident;
		_innerRun();
	}
	
	private static function _log(evt:Events, context:EventContext):Void {
		var a:Int = evt._data.length;
		context.addLog(0, (context.chain > 0 ? "└ " : "") + "≈ EVENT " + (a == 0 ? "" : "CHAIN ") + evt._type + (a == 0 ? " [!] Empty" : " @" + a));
		if (context.chain > 0 && context.parent.action != null){
			context.addLog(1, "├ ACTION \"" + context.parent.action.query + "\"");
		}
	}
	
}