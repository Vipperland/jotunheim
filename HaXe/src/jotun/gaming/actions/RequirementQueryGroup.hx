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
	
	public function eventRun(query:Dynamic, context:IEventContext):Dynamic {
		var result:Dynamic = {};
		if (context.debug){
			var idx:Int = 0;
			Dice.Values(query, function(single:String){
				if(single != '@result'){
					context.requirement = single;
					Dice.All(units, function(p:String, o:RequirementQuery):Void {
						o.ioContext = context;
						context.log.push(Utils.prefix('', context.ident+1, '\t') + single + '[' + p + '] == ' + o.proc(['@result', single], result).result[idx]);
						++idx;
						o.flush();
					});
				}
			});
			context.requirement = null;
		}else{
			Dice.Values(units, function(o:RequirementQuery){
				o.ioContext = context;
				o.proc(query, result);
				o.flush();
			});
		}
		return result;
	}
	
}