package jotun.gaming.actions;
import jotun.Jotun;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.IEventContext;
import jotun.gaming.actions.Requirement;
import jotun.gaming.actions.Resolution;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_EventController")
class EventController implements IEventDispatcher  {
	
	static private var _rAction:String->Action;
	static private var _wAction:Action->Void;
	
	static private var _rRequirement:String->Requirement;
	static private var _wRequirement:Requirement->Void;
	
	static public function cacheController(saveAction:Action->Void, loadAction:String->Action, saveRequirement:Requirement->Void, loadRequirement:String->Requirement):Void {
		_wAction = saveAction;
		_rAction = loadAction;
		_wRequirement = saveRequirement;
		_rRequirement = loadRequirement;
	}
	
	static public function loadAction(id:String):Action {
		return _rAction != null ? _rAction(id) : Action.load(id);
	}
	
	static public function saveAction(a:Action):Void {
		_wAction != null ? _wAction(a) : Action.save(a);
	}
	
	static public function loadRequirement(id:String):Requirement {
		return _rRequirement != null ? _rRequirement(id) : Requirement.load(id);
	}
	
	static public function saveRequirement(r:Requirement):Void {
		_wRequirement != null ? _wRequirement(r) : Requirement.save(r);
	}
	
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
			Dice.All(events, function(p:String, v:Dynamic):Void {
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
			context.chain = _index;
			_chain[_chain.length] = context;
			if (_index > 0){
				context.parent = _chain[_index-1];
			}
			++_index;
			_onCallBefore(context);
			Reflect.field(events, name).run(context);
			--_index;
			_onCallAfter(context);
			if (_index == 0){
				_onChainEnd(_chain);
				_chain = [];
			}
			return true;
		}else{
			if (_debug){
				var context:IEventContext = _createContext(data, name);
				_onCallBefore(context);
				context.log.push(Utils.prefix("", context.ident + context.chain, '\t') + "≈ EVENT " + name + " [!] Not Found on " + Type.getClassName(Type.getClass(this))) + ". ";
				_onCallAfter(context);
			}
			return false;
		}
	}
	
}