package jotun.utils;
import haxe.Log;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_Filler")
class Filler{
	
	static private function _apply(path:String, content:String, data:Dynamic):String {
		if (data == null) {
			content = content.split("{{" + path + "}}").join("");
		}else if (Std.isOfType(data, Float) || Std.isOfType(data, String) || Std.isOfType(data, Bool) || Std.isOfType(data, Int)) {
			var is_valid:Bool = data != null && data != 0 && data != false;
			content = content.split("{{" + path + "}}").join(data);
			//content = content.split("{{show-if:" + path + "}}").join(is_valid ? '' : 'hidden');
			//content = content.split("{{hide-if:" + path + "}}").join(is_valid ? 'hidden' : '');
			path = path.toLowerCase();
			content = content.split("{{" + path + "}}").join(data);
			//content = content.split("{{show-if:" + path + "}}").join(is_valid ? '' : 'hidden');
			//content = content.split("{{hide-if:" + path + "}}").join(is_valid ? 'hidden' : '');
		}else {
			path = path != null && path != "" ? path + "." : "";
			Dice.All(data, function(p:String, v:Dynamic) {
				p = '' + p;
				if (p.substr(0, 1) != '_'){
					content = _apply(path + p, content, v);
				}
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
		if (Std.isOfType(data, Array)) {
			Dice.All(data, function(p:Int, v:Dynamic) {
				Reflect.setField(v, '%0', p);
				r += _apply(sufix, value, v);
				Reflect.deleteField(v, '%0');
			});
		}else {
			r = _apply(sufix, value, data);
		}
		return r;
	}
	
	/**
	 * Fill a string block with object data
	 * If data is an Array, build a block for each content object
	 * @param	value
	 * @param	data
	 * @param	sufix
	 * @return
	 */
	static public function splitter(value:String, split:String, glue:Array<Dynamic>, ?each:Dynamic->String):String {
		var r:Array<String>  = value.split(split);
		if(r.length > 1){
			Dice.All(r, function(p:Dynamic, v:String) {
				if (p < glue.length){
					var e:Dynamic = glue[p];
					if (each != null) {
						e = each(e);
					}
					r[p] = v + e;
				}
			});
		}
		return r.join('');
	}
	
	static public function splitterTo(value:String, data:Dynamic, split:String, glue:Array<Dynamic>, ?each:Dynamic->String):String {
		value = to(value, data);
		return splitter(value, split, glue, each);
	}
	
	/**
	 * Extract number from string
	 * @param	value
	 * @return
	 */
	static public function extractNumber(value:String):UInt {
		var s:String = '';
		var i:UInt = 0;
		while (i < value.length) {
			var j:UInt = Std.parseInt(value.substr(i, 1));
			++i;
			if (j != null)
				s += j + '';
		}
		i = Std.parseInt(s);
		return i == null ? 0 : i;
	}
	
	
	
}