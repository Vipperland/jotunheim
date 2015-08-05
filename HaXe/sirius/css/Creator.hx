package sirius.css;
import haxe.Log;
import js.html.Element;
import js.html.StyleElement;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("CSS")
class Creator {

	static public var plugins:Array<ICSS> = [];
	
	static public function init(scripts:Array<Dynamic>, ?extras:Array<Dynamic>):Void {
		Dice.Values(scripts, function(V:Dynamic) {
			plugins[plugins.length] = untyped __js__("new V();");
		});
		generate(0, 20, 1);
		generate(22, 100, 2);
		Dice.Values(extras, function(v:Dynamic) {
			if (Std.is(v, Array)) {
				generate(Std.parseInt(v[0]), Std.parseInt(v[1]), Std.parseInt(v[3]));
			}else {
				v = Std.parseInt(v);
				generate(v, v, 1);
			}
		});
		Dice.Values(plugins, function(v:ICSS) {
			v.apply();
		});
	}
	
	static public function generate(from:Int, ?to:Int, increment:UInt = 1):Void {
		if (to == null) to = from;
		Dice.Count(from, to + 1, function(a:Int, b:Int) {
			Dice.Values(plugins, function(v:ICSS) {
				if (v.countable) v.add(a, to);
			});
		}, null, increment);
	}
	
	static public function valueOf():String {
		return CSS.ALL.innerText.split("}").join("}<br/>");
	}
	
	static public function all():StyleElement {
		return cast CSS.ALL;
	}
	
}