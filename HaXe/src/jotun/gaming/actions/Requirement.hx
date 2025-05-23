package jotun.gaming.actions;
import jotun.objects.QueryGroup;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("Jtn.Requirement")
class Requirement extends Resolution {
	
	public static var cache:Dynamic = {};
	
	public static var codex:RequirementQueryGroup = new RequirementQueryGroup();
	
	static public function createFromQueries(id:String, queries:Array<Dynamic>, breakon:Dynamic = null):Dynamic {
		return { id:id, "*": queries, breakon: breakon };
	}
	
	public static function save(requirement:Requirement):Void {
		Reflect.setField(cache, requirement.id, requirement);
	}
	
	public static function load(id:String):Requirement {
		return cast Reflect.field(cache, id);
	}
	
	public var target:Int;
	
	public function new(type:String, data:Dynamic) {
		super(type, data, "*");
		// Required condition resolution
		if (data.target == null){
			target = length();
		}else{
			target = Std.int(data.target);
		}
		// Requirement aways break on success if not defined
		if(breakon == null){
			breakon = 'never';
		}
		if (Utils.isValid(data.id)){
			SpellCodex.saveRequirement(this);
		}
	}
	
	public function verify(context:SpellCasting, position:Int):Bool {
		connect();
		var res:Bool = true;
		var score:UInt = 0;
		if (Utils.isValid(query)){
			context.registerRequirement(this);
			var sec:Dynamic = codex.verification(query, context).result;
			if(sec != null){
				Dice.Values(sec, function(v:Dynamic){
					if (Utils.boolean(v)){
						++score;
					}
				});
			}
			res = score >= target;
		}
		res = resolve(res, context);
		if (context.debug){
			_log(this, context, res, score, reverse, position);
		}
		return res;
	}
	
	private static function _log(evt:Requirement, context:SpellCasting, success:Bool, score:Int, reversed:Bool, position:Int):Void {
		context.addLog(0, (success ? "└ SUCCESS" : "ꭙ FAILED") + " REQUIREMENT " + (Utils.isValid(evt.id) ? '#{' + evt.id + '} ': '') + "[" + position + "]" + (reversed ? " REVERSED" : "") + " score:" + score + "/" + evt.target + " queries:" + evt.length());
	}
	
	
}