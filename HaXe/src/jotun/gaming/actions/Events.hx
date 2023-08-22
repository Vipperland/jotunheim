package jotun.gaming.actions;
import haxe.DynamicAccess;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.EventController;
import jotun.gaming.actions.EventContext;
import jotun.gaming.actions.Resolution;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_Events")
class Events {
	
	//public static var mapper:DynamicAccess<String>;
	
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
	
	public function run(context:EventContext) {
		++context.ident;
		Dice.All(_data, function(p:Int, a:Action):Bool{
			return a.willBreakOn(a.run(context, p));
		});
		--context.ident;
		if (context.ident == 0){
			if (context.debug){
				_log(this, context);
				context.log.reverse();
			}
		}
	}
	
	private static function _log(evt:Events, context:EventContext):Void {
		var a:Int = evt._data.length;
		context.addLog(0, (context.chain > 0 ? "└ " : "") + "≈ EVENT " + (a == 0 ? "" : "CHAIN ") + evt._type + (a == 0 ? " [!] Empty" : " @" + a));
		if (context.chain > 0 && context.parent.action != null){
			context.addLog(1, "├ ACTION \"" + context.parent.action.query + "\"");
		}
	}
	
}