package jotun.gaming.actions;
import haxe.DynamicAccess;
import jotun.gaming.actions.EventContext;
import jotun.objects.QueryGroup;
import jotun.gaming.actions.ActionQuery;
import jotun.gaming.actions.Requirement;
import jotun.tools.Key;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_Action")
class Action extends Resolution {
	
	public static var cache:DynamicAccess<Action> = {};
	
	public static var commands:ActionQueryGroup = new ActionQueryGroup();
	
	public static function save(action:Action):Void {
		cache.set(action.id, action);
	}
	
	public static function load(id:String):Action {
		return cache.get(id);
	}
	
	static public function create(v:Array<Dynamic>):Void {
		
	}
	
	public var require:Array<Requirement>;
	
	public var target:Int;
	
	/**
	 * Parse action from object data
	 * 
	 * 	// Object definition
		{
			"id": STRING	 					// same id will replace previous
			"require" : STRING | ARRAY			// List of requirements for action to run
			"target" : INT						// Each succesful required will add +1 to score, failed requirements will result in -1, action only will run if score >= target
			"reverse" : BOOL					// Reverse axction result
			"breakon" : NULL | BOOL | STRING		// Check if next action in chain will be executed ("always" and "never" are valid values for string)
			"then" : ARRAY						// Actions to execute if SUCCESS state (will ignore reverse state)
			"fail" : ARRAY						// Actions to execute if FAILED state (will ignore reverse state)
			"*" : STRING | ARRAY				// Queries to execute if SUCCESS (before then and fail, ignore reverse state)
		}
	 * 
	 * @param	type
	 * @param	data
	 */
	public function new(type:String, data:Dynamic) {
		super(type, data);
		// Construct Requirement Objects
		require = [];
		var i:Int = 0;
		Dice.All(data.require, function(p:Dynamic, v:Dynamic):Void {
			if (Std.isOfType(v, String)){
				v = EventController.loadRequirement(v);
			}
			if(v != null){
				if (Std.isOfType(v, Requirement)){
					require[i] = cast v;
				}else{
					require[i] = new Requirement(type + '[' + p + ']', v);
				}
				++i;
			}
		});
		// Required condition resolution
		if (target == null){
			target = require.length;
		}else{
			target = Std.int(data.target);
		}
		// Action aways break on success if not defined
		if(breakon == null){
			breakon = true;
		}
		if (Utils.isValid(data.id)){
			EventController.saveAction(this);
		}
	}
	
	public function run(context:EventContext, position:Int):Bool {
		connect();
		// Check requirements
		var resolution:Int = 0;
		++context.ident;
		Dice.All(require, function(p:Int, r:Requirement){
			var result:Bool = r.verify(context, p);
			if (result){
				++resolution;
			}else{
				--resolution;
			}
			return r.willBreakOn(result);
		});
		--context.ident;
		// resolution
		var success:Bool = (target == 0) || (target > 0 && resolution >= target) || (target < 0 && resolution <= target);
		if (context.debug){
			_log(this, context, success, resolution, position);
		}
		if (success){
			context.registerAction(this);
			if (Utils.isValid(query)){
				commands.eventRun(query, context);
			}
		}
		return resolve(success, context);
	}
	
	private static function _log(evt:Action, context:EventContext, success:Bool, score:Int, position:Int):Void {
		context.addLog(0, "↑ " + (success ? "SUCCESS" : "FAILED") + " ACTION " + (evt.willBreakOn(success) ? "[x]" : "[>]") + " " + (Utils.isValid(evt.id) ? "#{" + evt.id + "} ": "") + "[" + position + "] " + (evt.target != 0 ? "score:" + score + "/" + evt.target + " ": "") + "queries:" + evt.length());
	}
	
}