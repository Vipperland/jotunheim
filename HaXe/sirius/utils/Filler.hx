package sirius.utils;
import haxe.Log;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.utils.Filler")
class Filler{
	
	static private var _pattern:Array<String> = ["{{", "}}"];
	
	static private function _apply(path:String, content:String, data:Dynamic, ?pattern:Array<String>):String {
		if (pattern == null) pattern = _pattern;
		if (data == null) {
			content = content.split(_pattern[0] + path + _pattern[1]).join("");
		}else if (Std.is(data, Float) || Std.is(data, String) || Std.is(data, Bool) || Std.is(data, Int)) {
			content = content.split(_pattern[0] + path + _pattern[1]).join(data);
		}else {
			path = path != null && path != "" ? path + "." : "";
			Dice.All(data, function(p:String, v:Dynamic) {
				content = _apply(path + p, content, v);
			});
		}
		return content;
	}
	
	static public function setPattern(head:String, tail:String):Void {
		_pattern = [head, tail];
	}
	
	static public function to(value:String, data:Dynamic, ?sufix:String, ?pattern:Array<String>):String {
		return _apply(sufix, value, data, pattern);
	}
	
}