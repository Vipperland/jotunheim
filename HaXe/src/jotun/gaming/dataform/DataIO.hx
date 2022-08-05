package jotun.gaming.dataform;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class DataIO {
	
	public static var PROP:String = '|';
	public static var SET:String = ':';
	public static var SPACE:String = '/+';
	
	/**
	   Object construct by property index
	   @param	c
	   @param	o
	   @param	nfo
	   @return
	**/
	public static function parse(c:DataObject, o:String, nfo:Dynamic):DataObject {
		var obj:DataObject = c;
		Dice.Values(o.split(PROP), function(v:String){
			var tag:Array<String> = v.split(SET);
			var par:String = Reflect.field(nfo, tag.shift());
			c.set(par, tag.join(SET).split(SPACE).join(' '));
		});
		obj.onParse();
		obj.allowChanges();
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
				if (Std.isOfType(value, String)) {
					value = value.split(' ').join(SPACE);
				}
				result[count] = p + SET + value;
				++count;
			}
		});
		return n + (o.id != null ? " " + o.id : "") + " " + result.join(PROP);
	}
	
}