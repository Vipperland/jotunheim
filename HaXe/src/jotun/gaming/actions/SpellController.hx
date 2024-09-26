package jotun.gaming.actions;
import haxe.DynamicAccess;
import jotun.Jotun;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.SpellCasting;
import jotun.gaming.actions.IDataProvider;
import jotun.gaming.actions.Requirement;
import jotun.gaming.actions.Resolution;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("Jtn.SpellController")
class SpellController implements IEventDispatcher implements IEventCollection  {
	
	static private var _rAction:String->Action;
	static private var _wAction:Action->Void;
	
	static private var _rRequirement:String->Requirement;
	static private var _wRequirement:Requirement->Void;
	
	static private var _debug:Bool;
	
	static public function createContext(name:String, data:Dynamic, provider:IDataProvider, controller:SpellController):SpellCasting {
		return new SpellCasting(name, data, provider, controller, _debug);
	}
	
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
		if (_wAction != null){
			_wAction(a);
		}else{
			Action.save(a);
		}
	}
	
	static public function loadRequirement(id:String):Requirement {
		return _rRequirement != null ? _rRequirement(id) : Requirement.load(id);
	}
	
	static public function saveRequirement(r:Requirement):Void {
		if (_wRequirement != null){
			_wRequirement(r);
		}else{
			Requirement.save(r);
		}
	}
	
	public var events:DynamicAccess<Spells>;
	
	private function _onCallBefore(context:SpellCasting):Void { }
	
	private function _onCallAfter(context:SpellCasting):Void { }
	
	private function _onChainEnd(chain:Array<SpellCasting>):Void { }
	
	public function new(data:Dynamic, ?debug:Bool, ?validate:String->DynamicAccess<Dynamic>->String, ?priority:Array<String>) {
		_debug = debug == true;
		events = Spells.patch(data, validate, priority);
	}
	
	public function setDebug(mode:Bool):Void {
		_debug = mode;
	}
	
	private var _index:Int = 0;
	
	private var _chain:Array<SpellCasting> = [];
	
	public function call(name:String, ?data:Dynamic, ?provider:IDataProvider):Bool {
		var context:SpellCasting = createContext(name, data, provider, this);
		if (Reflect.hasField(events, name)){
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
				context.ended = true;
				_onChainEnd(_chain);
				_chain = [];
			}
			return true;
		}else{
			if (_debug){
				_onCallBefore(context);
				context.addLog(0, "≈ EVENT " + name + " [!] Not Found on " + Type.getClassName(Type.getClass(this)) + ". ");
				_onCallAfter(context);
			}
			return false;
		}
	}
	
}