package sirius.css;
import haxe.Log;
import math.IARGB;
import sirius.math.ARGB;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com> <rafael@gateofsirius.com>
 */
@:expose("sru.css.Shadow")
class Shadow extends CSS {
	
	private static var _active:Bool = false;
	
	public function create(name:String, color:Dynamic):Void {
		var t:IARGB = (!Std.is(color, ARGB)) ? new ARGB(color) : color;
		var tbody:String = "0 1px 0 " + t.range(.8).hex() + ",0 2px 0 " + t.range(.7).hex() + ",0 3px 0 " + t.range(.5).hex() + ",0 4px 0 " + t.range(.4).hex() + ",0 5px 0 " + t.range(.3).hex() + ",0 6px 1px rgba(0,0,0,.1),0 0 5px rgba(0,0,0,.1),0 1px 3px rgba(0,0,0,.3),0 3px 5px rgba(0,0,0,.2),0 5px 10px rgba(0,0,0,.25),0 10px 10px rgba(0,0,0,.2),0 20px 20px rgba(0,0,0,.15);";
		setSelector(".txt-shad-" + name, "text-shadow: " + tbody);
		setSelector(".box-shad-" + name, "box-shadow: " + tbody);
	}
	
	public function new() {
		super();
		if (!_active) {
			_active = true;
			_parse();
		}
	}
	
	private function _parse():Void {
		Dice.All(Color.COLORS, function(p:String, v:Dynamic) {
			create(p, new ARGB(v.color));
		});
	}
	
}