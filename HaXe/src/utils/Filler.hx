package sirius.utils;
import haxe.Log;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("sru.utils.Filler")
class Filler{
	
	static private function _apply(path:String, content:String, data:Dynamic):String {
		if (data == null) content = content.split("%" + path + "%").join("");
		else if (Std.is(data, Float) || Std.is(data, String) || Std.is(data, Bool) || Std.is(data, Int)) content = content.split("%" + path + "%").join(data);
		else {
			path = path != null && path != "" ? path + "." : "";
			Dice.All(data, function(p:String, v:Dynamic) {
				content = _apply(path + p, content, v);
			});
		}
		return content;
	}
	
	static public function to(value:String, data:Dynamic, ?sufix:String = null):String {
		return _apply(sufix, value, data);
	}
	
}