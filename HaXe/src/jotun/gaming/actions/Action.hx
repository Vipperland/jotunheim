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
	public static function get(id:String):Action {
		return cast Reflect.field(cache, id);
	}
	
	public static var commands:QueryGroup = new QueryGroup();
	
	public var requirements:Array<Requirement>;
	
	public var target:Int;
	
	public function new(type:String, data:Dynamic) {
		super(type, data);
		// Construct Requirement Objects
		requirements = [];
		var i:Int = 0;
		Dice.All(data.requirements, function(p:Dynamic, v:Dynamic){
			if (Std.is(v, String)){
				v = Requirement.get(v);
			}
			if(v != null){
				if (Std.is(v, Requirement)){
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
			Reflect.setField(cache, data.id, this);
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
				return r.cancelOnSuccess;
			}else{
				--resolution;
				return r.cancelOnFail;
			}
		});
		--context.ident;
		// resolution
		var success:Bool = (target == 0) || (target > 0 && resolution >= target) || (target < 0 && resolution <= target);
		if (context.debug){
			_log(this, context, success, resolution, position);
		}
		if (success){
			if(Utils.isValid(query)){
				commands.run(query);
			}
		}
		return resolve(success, context);
	}

	private static function _log(evt:Action, context:IEventContext, success:Bool, score:Int, position:Int):Void {
		var s:String = "";
		while (s.length < context.ident){
			s += '	';
		}
		context.log.push(s + "↑ " + (success ? "SUCCESS" : "FAIL") + " ACTION " + (Utils.isValid(evt.id) ? "#{" + evt.id + "} ": "") + "[" + position + "] score:" + score + "/" + evt.target + " queries:" + evt.length());
	}
	
}