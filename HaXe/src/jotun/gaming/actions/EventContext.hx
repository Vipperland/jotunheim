package jotun.gaming.actions;
import jotun.gaming.actions.Action;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class EventContext {
	
	public var debug:Bool;
	
	public var name:String;
	
	public var log:Array<String>;
	
	public var ident:Int;
	
	public var chain:Int;
	
	public var ticks:Int;
	
	public var origin:Dynamic;
	
	public var parent:EventContext;
	
	public var action:IEventContextAction;
	
	public var requirement:IEventContextRequirement;
	
	public var history:Array<Action>;
	
	public function new(name:String, data:Dynamic, debug:Bool) {
		this.origin = data;
		this.name = name;
		this.debug = debug;
		this.log = [];
		this.ident = 0;
		this.chain = 0;
		this.ticks = 0;
		this.action = cast { target: null, count: 0, queries: 0 };
		this.requirement = cast { target: null, count: 0, queries: 0 };
		this.history = [];
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
	
}

interface IEventCounter {
	public var query:String;
	public var count:Int;
	public var queries:Int;
	
}

interface IEventContextAction extends IEventCounter{
	public var target:Action;
}

interface IEventContextRequirement extends IEventCounter {
	public var target:Requirement;
}