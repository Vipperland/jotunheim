package jotun.objects;
import jotun.objects.IQuery;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
@:expose('sru.objects.QueryGroup')
class QueryGroup {

	public var units:Array<IQuery>;
	
	public function new(){
		clear();
	}
	
	public function add(o:IQuery):Void {
		if (units.indexOf(o) == -1){
			units[units.length] = o;
		}
	}
	
	public function remove(o:IQuery):Void {
		var iof:Int = units.indexOf(o);
		if (iof != -1){
			units.splice(iof, 1);
		}
	}
	
	public function clear():Void {
		units = [];
	}
	
	public function run(query:Dynamic):Dynamic {
		var result:Dynamic = {};
		Dice.Values(units, function(o:IQuery){
			o.proc(query, result);
			o.flush();
		});
		return result;
	}
	
}