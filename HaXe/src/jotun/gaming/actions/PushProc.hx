package jotun.gaming.actions;
import jotun.flow.IPush;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class PushProc {

	public var units:Array<IPush>;
	
	public function new(){
		clear();
	}
	
	public function add(o:IPush):Void {
		if (units.indexOf(o) == -1){
			units[units.length] = o;
		}
	}
	
	public function remove(o:IPush):Void {
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
		Dice.Values(units, function(o:IPush){
			o.proc(query, result);
			o.flush();
		});
		return result;
	}
	
}