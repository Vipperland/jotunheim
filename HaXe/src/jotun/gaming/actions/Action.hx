package jotun.gaming.actions;
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
	
	public static var cache:Dynamic = {};
	
	public static function save(action:Action):Void {
		Reflect.setField(cache, action.id, action);
	}
	
	public static function load(id:String):Action {
		return cast Reflect.field(cache, id);
	}
	
	public static var commands:ActionQueryGroup = new ActionQueryGroup();
	
	public var requirements:Array<Requirement>;
	
	public var target:Int;
	
	public function new(type:String, data:Dynamic) {
		super(type, data);
		// Construct Requirement Objects
		requirements = [];
		var i:Int = 0;
		Dice.All(data.requirements, function(p:Dynamic, v:Dynamic):Void {
			if (Std.isOfType(v, String)){
				v = EventController.loadRequirement(v);
			}
			if(v != null){
				if (Std.isOfType(v, Requirement)){
					requirements[i] = cast v;
				}else{
					requirements[i] = new Requirement(type + '[' + p + ']', v);
				}
				++i;
			}
		});
		// Required condition resolution
		target = Std.int(data.target);
		if (target == null){
			target = requirements.length;
		}
		if (Utils.isValid(data.id)){
			EventController.saveAction(this);
		}
	}
	
	public function run(context:IEventContext, position:Int):Bool {
		// Check requirements
		var resolution:Int = 0;
		++context.ident;
		Dice.All(requirements, function(p:Int, r:Requirement){
			var result:Bool = r.verify(context, p);
			if (result){
				++resolution;
				return r.breakon == '*' || r.breakon == 'success';
			}else{
				--resolution;
				return r.breakon == '*' || r.breakon == 'fail';
			}
		});
		--context.ident;
		// resolution
		var success:Bool = (target == 0) || (target > 0 && resolution >= target) || (target < 0 && resolution <= target);
		if (context.debug){
			_log(this, context, success, resolution, position);
		}
		if (success){
			context.history.push(this);
			if(Utils.isValid(query)){
				commands.eventRun(query, context);
				if (context.debug){
					_logTracer(context);
				}
			}
		}
		return resolve(success, context);
	}
	
	private static function _logTracer(context:IEventContext):Void  {
		if(context.tracer.length > 0){
			Dice.Values(context.tracer, function(v:String):Void {
				context.log.push(Utils.prefix("", context.ident + context.chain, '\t') + "@TRACER \"" + v + "\"");
			});
			context.tracer = [];
		}
	}

	private static function _log(evt:Action, context:IEventContext, success:Bool, score:Int, position:Int):Void {
		if (context.log != null){
			context.log.push(Utils.prefix("", context.ident + context.chain, '\t') + "↑ " + (success ? "SUCCESS" : "FAILED") + " ACTION " + (Utils.isValid(evt.id) ? "#{" + evt.id + "} ": "") + "[" + position + "] score:" + score + "/" + evt.target + " queries:" + evt.length());
		}
	}
	
}