package jotun.gaming.actions;
import haxe.DynamicAccess;
import haxe.extern.EitherType;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.ActionQuery;
import jotun.gaming.actions.SpellCodex;
import jotun.gaming.actions.SpellCasting;
import jotun.gaming.actions.Resolution;
#if js
import jotun.timer.DelayedCall;
#end
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.utils.IDiceRoll;

/**
 * ...
 * @author Rim Project
 */
@:expose("Jtn.SpellGroup")
class SpellGroup {
	
	/**
	 * Create a patch with events data
	 * @param	data			Object of names array of event chain
	 * @param	validate		Validate event name, control if events are valid or not
	 * @param	priority		Events to be patched first
	 * @return Array of fully patched events, actions and requirements
	 */
	public static function patch(data:DynamicAccess<SpellGroup>, ?validate:String->DynamicAccess<Dynamic>->String, ?priority:Array<String>):DynamicAccess<SpellGroup> {
		var patched:DynamicAccess<SpellGroup> = { };
		if (data != null){
			if(priority != null){
				Dice.Values(priority, function(v:String):Void {
					if(data.exists(v)){
						var e:Dynamic = data.get(v);
						if (!Std.isOfType(e, SpellGroup)){
							patched.set(v, new SpellGroup(v, e));
						}else{
							patched.set(v, e);
						}
					}
					Reflect.deleteField(data, v);
				});
			}
			Dice.All(data, function(p:String, v:Dynamic):Void {
				p = (validate == null ? p : validate(p, v));
				if(p != null && p != ""){
					if (!Std.isOfType(v, SpellGroup)){
						patched.set(p, new SpellGroup(p, v));
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
	private var _context:SpellCasting;
	#if js
	private var _delayed:DelayedCall;
	#end
	
	public function new(type:String, data:Array<Dynamic>) {
		_type = type;
		_data = [];
		_init(data, 0);
	}
	
	public function _init(data:Array<Dynamic>, ?index:UInt):Void {
		if(data.length == 0){
			return;
		}
		var toConcat:Array<Action> = null;
		if(index < _data.length){
			toConcat = _data.splice(0, index);
		}
		var i:UInt = index;
		var r:Dynamic = {};
		Dice.All(data, function(p:String, v:Dynamic):Void {
			if (Std.isOfType(v, String)){
				v = SpellCodex.loadAction(v);
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
		if(toConcat != null){
			_data = _data.concat(toConcat);
			toConcat = null;
		}
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
			_innerCasting();
		}
	}
	
	public function canWait():Bool {
		return _cursor_pos < _data.length;
	}
	
	#end
	
	private function _innerCasting():Void {
		var a:Action = null;
		Dice.Count(_cursor_pos, _data.length, function(current:Int, max:Int, completed:Bool):Bool {
			++_cursor_pos;
			_context.registerEvent(this);
			a = _data[current];
			if (a.willBreakOn(a.invoke(_context, current))){
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
	
	public function execute(context:SpellCasting):Void {
		_is_waiting = false;
		_cursor_pos = 0;
		_context = context;
		++context.ident;
		_innerCasting();
	}
	
	private static function _log(evt:SpellGroup, context:SpellCasting):Void {
		var a:Int = evt._data.length;
		context.addLog(0, (context.chain > 0 ? "└ " : "") + "≈ EVENT " + (a == 0 ? "" : "CHAIN ") + evt._type + (a == 0 ? " [!] Empty" : " @" + a));
		if (context.chain > 0 && context.parent.action != null && context.parent.action.query != null){
			context.addLog(1, "├ ACTION \"" + context.parent.action.query + "\"");
		}
	}
	
	public function length():Int {
		return _data.length;
	}
	
	public function learn(action:Action, ?index:Int):Void {
		if(index == null || index < 0 || index > _data.length){
			index = _data.length;
		}
		_init([action], index);
	}
	
	public function getIndexOf(action:EitherType<Action,String>):Int {
		if(Std.isOfType(action, String)){
			action = SpellCodex.loadAction(action);
		}
		var roll:IDiceRoll = Dice.Values(_data, function(value:Action):Bool {
			return action == value;
		});
		return roll.completed ? _data.length : roll.param;
	}
	
	public function learnAfter(action:Action, search:EitherType<Action,String>):Void {
		learn(action, getIndexOf(search) + 1);
	}
	
	public function learnBefore(action:Action, search:EitherType<Action,String>):Void {
		learn(action, getIndexOf(search) - 1);
	}
	
}