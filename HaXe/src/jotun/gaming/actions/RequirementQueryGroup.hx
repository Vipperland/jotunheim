package jotun.gaming.actions;
import jotun.objects.QueryGroup;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class RequirementQueryGroup extends QueryGroup {

	public function new() {
		super();
	}
	
	public function verification(query:Dynamic, context:SpellCasting):Dynamic {
		var result:Dynamic = {};
		if (context.debug){
			var idx:Int = 0;
			Dice.Values(query, function(single:String){
				if(single != '@result'){
					context.registerRequirementQuery(single);
					Dice.All(units, function(p:String, o:RequirementQuery):Void {
						o.invocation = context;
						if (context.debug){
							context.addLog(1, single + ' [' + p + '] == ' + o.proc(['@result', single], result).result[idx]);
						}
						++idx;
						o.flush();
					});
				}
			});
		}else{
			Dice.Values(units, function(o:RequirementQuery){
				o.invocation = context;
				o.proc(query, result);
				o.flush();
			});
		}
		return result;
	}
	
}