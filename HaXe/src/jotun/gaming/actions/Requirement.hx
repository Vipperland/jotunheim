package jotun.gaming.actions;
import jotun.objects.QueryGroup;
import js.html.Event;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_Requirement")
class Requirement extends Resolution {
	
	public static var cache:Dynamic = {};
	public static function get(id:String):Resolution {
		return cast Reflect.field(cache, id);
	}
	
	public static var commands:RequirementQueryGroup = new RequirementQueryGroup();
	
	public var target:Int;
	
	public function new(type:String, data:Dynamic) {
		super(type, data);
		if (data.target == null){
			target = length();
		}else{
			target = Std.int(data.target);
		}
		if (Utils.isValid(data.id)){
			Reflect.setField(cache, data.id, this);
		}
	}
	
	public function verify(context:IEventContext, position:Int):Bool {
		var res:Bool = true;
		var score:UInt = 0;
		if (Utils.isValid(query)){
			var sec:Dynamic = commands.eventRun(query, context).result;
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
	
	private static function _log(evt:Requirement, context:IEventContext, success:Bool, score:Int, reversed:Bool, position:Int):Void {
		if (context.log != null){
			context.log.push(Utils.prefix("", context.ident + context.chain, '\t') + (success ? "└ SUCCESS" : "ꭙ FAIL") + " REQUIREMENT " + (Utils.isValid(evt.id) ? '#{' + evt.id + '} ': '') + "[" + position + "]" + (reversed ? " REVERSED" : "") + " score:" + score + "/" + evt.target + " queries:" + evt.length());
		}
	}
	
	
}