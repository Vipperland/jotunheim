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
	
	public function eventRun(query:Dynamic, context:IEventContext):Dynamic {
		var result:Dynamic = {};
		if (context.debug){
			Dice.Values(query, function(single:String){
				context.action = single;
				Dice.Values(units, function(o:ActionQuery){
					o.ioContext = context;
					o.proc(single, result);
					o.flush();
				});
			});
			context.action = null;
		}else{
			Dice.Values(units, function(o:ActionQuery){
				o.ioContext = context;
				o.proc(query, result);
				o.flush();
			});
		}
		return result;
	}
	
}