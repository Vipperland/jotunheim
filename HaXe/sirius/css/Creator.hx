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
	
	static public function init(scripts:Array<Dynamic>, ?max:Int = 100):Void {
		Dice.Values(scripts, function(V:Dynamic) {
			plugins[plugins.length] = untyped __js__("new V();");
		});
		var l:Int = max + 1;
		Dice.Count(0, l, function(a:Int, b:Int) {
			Dice.Values(plugins, function(v:ICSS) {
				if(v.countable)	v.add(a, max);
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