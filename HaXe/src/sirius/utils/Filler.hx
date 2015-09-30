package sirius.utils;
import haxe.Log;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.utils.Filler")
class Filler{
	
	static private function _apply(path:String, content:String, data:Dynamic):String {
		if (data == null) {
			content = content.split("{{" + path + "}}").join("");
		}else if (Std.is(data, Float) || Std.is(data, String) || Std.is(data, Bool) || Std.is(data, Int)) {
			content = content.split("{{" + path + "}}").join(data);
		}else {
			path = path != null && path != "" ? path + "." : "";
			Dice.All(data, function(p:String, v:Dynamic) {
				content = _apply(path + p, content, v);
			});
		}
		return content;
	}
	
	/**
	 * Fill a string block with object data
	 * If data is an Array, build a block for each content object
	 * @param	value
	 * @param	data
	 * @param	sufix
	 * @return
	 */
	static public function to(value:String, data:Dynamic, ?sufix:String):String {
		var r:String = "";
		if (Std.is(data, Array)) {
			Dice.All(data, function(p:Int, v:Dynamic) {
				Reflect.setField(v, '%i', p);
				r += _apply(sufix, value, v);
				Reflect.deleteField(v, '%i');
			});
		}else {
			r = _apply(sufix, value, data);
		}
		return r;
	}
	
}