package jotun.gaming.dataform;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class DataIO {
	
	/**
	   
	   @param	c
	   @param	o
	   @param	nfo
	   @return
	**/
	public static function parse(c:DataObject, o:String, nfo:Dynamic):DataObject {
		var obj:DataObject = c;
		Dice.Values(o.split('|'), function(v:String){
			var tag:Array<String> = v.split(':');
			var par:String = Reflect.field(nfo, tag.shift());
			Reflect.setField(obj, par, tag.join(':').split('/_').join(' '));
		});
		obj.onUpdate();
		return obj;
	}
	
	/**
	   Data format to [n 0:a|1:b|2:c]
	   @param	o
	   @param	n
	   @param	nfo
	   @return
	**/
	public static function stringify(o:Dynamic, n:String, nfo:Dynamic):String {
		var result:Array<String> = [];
		var count:Int = 0;
		Dice.All(nfo, function(p:Int, value:Dynamic){
			value = Reflect.field(o, value);
			if (value != null){
				if (Std.is(value, String)) {
					value = value.split(' ').join('/_');
				}
				result[count] = p + ':' + value;
				++count;
			}
		});
		return n + (o.id != null ? " " + o.id : "") + " " + result.join('|');
	}
	
}