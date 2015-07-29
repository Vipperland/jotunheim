package sirius.plugins;
import haxe.Log;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class SruObject{

	public static function fromString(value:String):Dynamic {
		var o:Dynamic = { };
		var d:Array<String> = value.split(";");
		Dice.Values(d, function(v:String) {
			var a:Array<String> = v.split(":");
			var p:String = a.shift();
			v = a.join(":");
			Reflect.setField(o, p, v);
		});
		return o;
	}
	
}