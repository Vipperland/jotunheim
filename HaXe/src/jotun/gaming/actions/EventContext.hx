package jotun.gaming.actions;
import jotun.gaming.actions.Action;
import jotun.gaming.actions.EventController;
import jotun.gaming.actions.Events;
import jotun.gaming.actions.IDataProvider;
import jotun.gaming.actions.Resolution;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class EventContext {
	
	public var debug:Bool;
	
	public var ended:Bool;
	
	public var name:String;
	
	public var log:Array<String>;
	
	public var ident:Int;
	
	public var chain:Int;
	
	public var ticks:Int;
	
	public var origin:Dynamic;
	
	public var parent:EventContext;
	
	public var event:IEventContext;
	
	public var action:IEventContextAction;
	
	public var requirement:IEventContextRequirement;
	
	public var history:Array<Action>;
	
	public var currentProvider:IDataProvider;
	
	public var dataProvider:IDataProvider;
	
	public var requestProvider:IDataProvider;
	
	public var controller:EventController;
	
	public function new(name:String, data:Dynamic, provider:IDataProvider, controller:EventController, debug:Bool) {
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
		this.controller = controller;
	}
	
	public function registerEvent(e:Events):Void {
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
		var chain:Dynamic = (result ? resolution.then : resolution.fail);
		if(chain != null){
			var temp:Dynamic = Events.patch({ _onActionReleased: chain }).get('_onActionReleased');
			controller.events.set('_onActionReleased', temp);
			controller.call('_onActionReleased', origin, dataProvider );
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

interface IEventContext {
	public var current:Events;
}

interface IEventCounter {
	public var query:String;
	public var count:Int;
	public var queries:Int;
}

interface IEventContextAction extends IEventCounter {
	public var target:Action;
}

interface IEventContextRequirement extends IEventCounter {
	public var target:Requirement;
}