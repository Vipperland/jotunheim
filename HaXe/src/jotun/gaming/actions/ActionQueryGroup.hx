package jotun.gaming.actions;
import jotun.objects.QueryGroup;
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
		Dice.Values(units, function(o:ActionQuery){
			o.ioContext = context;
			o.proc(query, result);
			o.flush();
		});
		return result;
	}
	
	
}