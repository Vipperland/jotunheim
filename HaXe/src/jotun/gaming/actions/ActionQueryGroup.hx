package jotun.gaming.actions;
import jotun.objects.QueryGroup;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class ActionQueryGroup extends QueryGroup {

	public function new() {
		super();
	}
	
	public function invocation(query:Dynamic, context:SpellCasting):Dynamic {
		var result:Dynamic = {};
		if (context.debug){
			Dice.Values(query, function(single:String){
				context.registerActionQuery(single);
				Dice.Values(units, function(o:ActionQuery){
					o.invocation = context;
					o.proc(single, result);
				});
			});
			Dice.Values(units, function(o:ActionQuery){
				o.flush();
			});
		}else{
			Dice.Values(units, function(o:ActionQuery){
				o.invocation = context;
				o.proc(query, result);
				o.flush();
			});
		}
		return result;
	}
	
}