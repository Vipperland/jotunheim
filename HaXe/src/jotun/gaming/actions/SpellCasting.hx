package jotun.gaming.actions;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.SpellCodex;
import jotun.gaming.actions.SpellGroup;
import jotun.gaming.actions.IDataProvider;
import jotun.gaming.actions.Resolution;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class SpellCasting {
	
	private static var _channeling:Int = 0;

	private static var _channelingDepth:Int = 0;

	private static inline var MAX_CHANNELING_DEPTH:Int = 32;
	
	public var debug:Bool;
	
	public var ended:Bool;
	
	public var name:String;
	
	public var log:Array<String>;
	
	public var ident:Int;
	
	public var chain:Int;
	
	public var ticks:Int;
	
	public var origin:Dynamic;
	
	public var parent:SpellCasting;

	public var event:SpellCastContext;

	public var action:SpellCastAction;
	
	public var requirement:SpellCastRequirement;
	
	public var history:Array<Action>;
	
	public var currentProvider:IDataProvider;

	public var dataProvider:IDataProvider;
	
	public var codex:SpellCodex;
	
	public function new(name:String, data:Dynamic, provider:IDataProvider, codex:SpellCodex, debug:Bool) {
		this.origin = data;
		this.name = name;
		this.debug = debug;
		this.ended = false;
		this.log = [];
		this.ident = 0;
		this.chain = 0;
		this.ticks = 0;
		this.event = cast { current: null };
		this.action = cast { target: null, count: 0, queries: 0 };
		this.requirement = cast { target: null, count: 0, queries: 0 };
		this.history = [];
		this.dataProvider = provider;
		this.currentProvider = provider;
		this.codex = codex;
	}
	
	public function registerEvent(e:SpellGroup):Void {
		event.current = e;
	}

	public function registerAction(a:Action):Void {
		action.target = a;
		++action.count;
		this.history.push(a);
	}
	
	public function registerActionQuery(q:String):Void {
		action.query = q;
		++action.queries;
	}
	
	public function registerRequirement(r:Requirement):Void {
		requirement.target = r;
		++requirement.count;
	}
	
	public function registerRequirementQuery(q:String):Void {
		requirement.query = q;
		++requirement.queries;
	}
	
	public function addLog(i:Int, message:String):Void {
		log[log.length] = Utils.prefix("", ident + chain + i, '\t') + message;
	}
	
	public function release(resolution:Resolution, result:Bool):Void {
		var chain:SpellGroup = result ? resolution.then : resolution.fail;
		if (chain != null){
			if (_channelingDepth >= MAX_CHANNELING_DEPTH){
				trace('[SpellCasting] Max channeling depth (' + MAX_CHANNELING_DEPTH + ') reached, aborting release.');
				return;
			}
			var cid:String = '_channeling:' + _channeling;
			++_channeling;
			++_channelingDepth;
			codex.index.set(cid, chain);
			codex.invoke(cid, origin, dataProvider);
			codex.index.remove(cid);
			--_channelingDepth;
		}
	}
	
	public function previous():Action {
		if (action.count > 1){
			return this.history[action.count - 2];
		}else{
			return null;
		}
	}
	
}

interface SpellCastContext {
	public var current:SpellGroup;
}

interface SpellCastCounter {
	public var query:String;
	public var count:Int;
	public var queries:Int;
}

interface SpellCastAction extends SpellCastCounter {
	public var target:Action;
}

interface SpellCastRequirement extends SpellCastCounter {
	public var target:Requirement;
}