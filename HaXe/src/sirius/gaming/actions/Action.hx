package sirius.gaming.actions;
import sirius.gaming.actions.ActionQuery;
import sirius.gaming.actions.Requirement;
import sirius.tools.Key;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class Action extends Resolution {
	
	public static var commands:ActionQuery = new ActionQuery();
	
	public var requirements:Array<Requirement>;
	
	public var target:Int;
	
	public function new(type:String, data:Dynamic) {
		super(type, data);
		// Construct Requirement Objects
		requirements = [];
		Dice.All(data.requirements, function(p:Dynamic, v:Dynamic){
			requirements[requirements.length] = new Requirement(type + '[' + p + ']', v);
		});
		// Required condition resolution
		target = Utils.isValid(data.target) ? Std.int(data.target) : (requirements.length == 0 ? 0 : 1);
	}
	
	public function run(context:IEventContext):Bool {
		// Check requirements
		var resolution:Int = 0;
		++context.ident;
		Dice.Values(requirements, function(r:Requirement){
			var result:Bool = r.verify(context);
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
		var success:Bool = target == 0 || (target > 0 && resolution >= target) || (target < 0 && resolution <= target);
		_log(this, context, success, resolution);
		if (success){
			if(Utils.isValid(query)){
				commands.proc(query);
				commands.flush();
			}
		}
		return resolve(success, context);
	}

	private static function _log(evt:Action, context:IEventContext, success:Bool, score:Int):Void {
		var s:String = "";
		while (s.length < context.ident){
			s += '	';
		}
		context.log.push(s + "↑ ACTION " + evt._type + " " + (success ? "SUCCESS" : "FAIL") + " score:" + score + '/' + evt.target);
	}
	
}