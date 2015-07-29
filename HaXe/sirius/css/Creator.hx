package sirius.css;
import haxe.Log;
import js.html.Element;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("CSS")
class Creator {

	static public var plugins:Array<ICSS> = [];
	
	static public function init(scripts:Array<Dynamic>):Void {
		Dice.Values(scripts, function(V:Dynamic) {
			plugins[plugins.length] = untyped __js__("new V();");
		});
		Dice.Count(0, 1001, function(a:Int, b:Int){
			Dice.Values(plugins, function(v:ICSS) {
				if(v.countable)	v.add(a);
			});
		});
		Dice.Values(plugins, function(v:ICSS) {
			v.apply();
		});
	}
	
	static public function valueOf():String {
		return CSS.ALL.innerText.split("}").join("}<br/>");
	}
	
}