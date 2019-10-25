package jotun.gaming.actions;
import jotun.Jotun;
import jotun.gaming.actions.IEventContext;
import jotun.utils.Dice;
import rim.data.helpers.IEventDispatcher;

/**
 * ...
 * @author Rim Project
 */
@:expose("jtn.game.EventController")
class EventController implements IEventDispatcher  {
	
	public static function CONTEXT(data:Dynamic, debug:Bool, ?feedback:IEventContext->Void):IEventContext {
		return cast {
			debug:debug,
			log:[],
			ident:0,
			ticks:0,
			origin:data,
			feedback:feedback,
		};
	}
	
	private var _debug:Bool;
	
	private var _feedback:IEventContext->Void;
	
	public var events:Dynamic;
	
	public function new(data:Dynamic, ?debug:Bool, ?feedback:IEventContext->Void) {
		_debug = debug;
		_feedback = feedback;
		if(data != null){
			events = data;
			Dice.All(events, function(p:String, v:Dynamic){
				Events.patch(this); 
			});
		}
	}

	public function call(name:String, ?data:Dynamic):Void {
		if (Reflect.hasField(events, name)){
			Reflect.field(events, name).run(CONTEXT(data, _debug, _feedback));
		}
	}
	
}