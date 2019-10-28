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
	
	private var _debug:Bool;
	
	public var events:Dynamic;
	
	private function _onCallBefore(context:IEventContext):Void { }
	
	private function _onCallAfter(context:IEventContext):Void { }
	
	private function _createContext(data:Dynamic):IEventContext {
		return cast {
			debug:_debug,
			log:[],
			ident:0,
			ticks:0,
			origin:data,
		};
	}
	
	public function new(data:Dynamic, ?debug:Bool) {
		_debug = debug == true;
		if(data != null){
			events = data;
			Dice.All(events, function(p:String, v:Dynamic){
				Events.patch(this); 
			});
		}
	}
	
	public function setDebug(mode:Bool):Void {
		_debug = mode;
	}
	
	public function call(name:String, ?data:Dynamic):Bool {
		if (Reflect.hasField(events, name)){
			var context:IEventContext = _createContext(data);
			_onCallBefore(context);
			Reflect.field(events, name).run(context);
			_onCallAfter(context);
			return true;
		}else{
			return false;
		}
	}
	
}