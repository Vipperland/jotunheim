package jotun.gaming.actions;
import haxe.Json;
import jotun.Jotun;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.EventController;
import jotun.gaming.actions.IEventContext;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("jtn.game.Events")
class Events {
	
	public static function patch(data:Dynamic, ?run:String, ?origin:Dynamic, ?debug:Bool, ?feedback:IEventContext->Void){
		if (data.events != null){
			if (!data.events.patched){
				data.events.patched = true;
				Dice.All(data.events, function(p:Dynamic, v:Dynamic){
					(cast data.events)[p] = new Events(p, v);
				});
			}
		}
		if (run != null){
			if (Reflect.hasField(data.events, run)){
				var events:Events = Reflect.field(data.events, run);
				events.run(EventController.CONTEXT(data, debug, feedback));
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
			if (Std.is(v, Action)){
				_data[i] = v;
			}else{
				_data[i] = new Action(_type + '[' + p + ']', v);
			}
			++i;
		});
	}
	
	public function run(context:IEventContext) {
		var l:UInt = context.log.length;
		++context.ident;
		Dice.Values(_data, function(a:Action):Bool{
			return !a.run(context);
		});
		--context.ident;
		if (context.debug){
			_log(this, context);
		}
		if (context.ident == 0){
			context.log.reverse();
			if (context.feedback != null){
				context.feedback(context);
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