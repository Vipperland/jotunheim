package jotun.gaming.actions;
import jotun.Jotun;
import jotun.gaming.actions.IEventContext;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_EventController")
class EventController implements IEventDispatcher  {
	
	private var _debug:Bool;
	
	public var events:Dynamic;
	
	private function _onCallBefore(context:IEventContext):Void { }
	
	private function _onCallAfter(context:IEventContext):Void { }
	
	private function _onChainEnd(chain:Array<IEventContext>):Void { }
	
	private function _createContext(data:Dynamic, name:String):IEventContext {
		return cast {
			name:name,
			debug:_debug,
			log:[],
			ident:0,
			ticks:0,
			origin:data,
			history:[],
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
	
	private var _index:Int = 0;
	
	private var _chain:Array<IEventContext> = [];
	
	public function call(name:String, ?data:Dynamic):Bool {
		if (Reflect.hasField(events, name)){
			var context:IEventContext = _createContext(data, name);
			_chain[_chain.length] = context;
			++_index;
			_onCallBefore(context);
			Reflect.field(events, name).run(context);
			if (--_index == 0){
				_onChainEnd(_chain);
				_chain = [];
			}
			_onCallAfter(context);
			return true;
		}else{
			if (_debug){
				var context:IEventContext = _createContext(data, name);
				_onCallBefore(context);
				context.log.push("≈ EVENT " + name + " [!] Not Found on " + Type.getClassName(Type.getClass(this))) + ". ";
				_onCallAfter(context);
			}
			return false;
		}
	}
	
}