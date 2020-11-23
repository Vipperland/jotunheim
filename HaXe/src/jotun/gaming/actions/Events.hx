package jotun.gaming.actions;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.IEventContext;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_Events")
class Events {
	
	public static function patch(data:Dynamic, ?origin:Dynamic){
		if (data.events != null){
			if (!data.events.patched){
				data.events.patched = true;
				Dice.All(data.events, function(p:Dynamic, v:Dynamic){
					(cast data.events)[p] = new Events(p, v);
				});
			}
		}
	}
	
	private var _data:Array<Action>;
	private var _type:String;
	
	public function new(type:String, data:Array<Dynamic>) {
		_type = type;
		_init(data);
	}
	
	public function _init(data:Array<Dynamic>) {
		_data = [];
		var i:UInt = 0;
		Dice.All(data, function(p:String, v:Dynamic){
			if (Std.is(v, String)){
				v = Action.get(v);
			}
			if(v != null){
				if (Std.is(v, Action)){
					_data[i] = v;
				}else{
					_data[i] = new Action(_type + '[' + p + ']', v);
				}
				++i;
			}
		});
	}
	
	public function run(context:IEventContext) {
		var l:UInt = context.log.length;
		++context.ident;
		Dice.All(_data, function(p:Int, a:Action):Bool{
			return !a.run(context, p);
		});
		--context.ident;
		if (context.ident == 0){
			if (context.debug){
				_log(this, context);
				context.log.reverse();
			}
		}
	}
	
	private static function _log(evt:Events, context:IEventContext):Void {
		var s:String = "";
		while (s.length < context.ident){
			s += '	';
		}
		var a:Int = evt._data.length;
		context.log.push(s + "≈ EVENT " + evt._type + (a == 0 ? " [!] No Actions" : " @" + a));
	}
	
}