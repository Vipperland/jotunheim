package jotun.gaming.dataform;
import haxe.Json;
import jotun.logical.Flag;
import jotun.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class SparkWriter {
	
	public static var PROP:String = '|';
	public static var SET:String = ':';
	public static var TYPE:String = 'q';
	public static var SPACE:String = ' ';
	
	public static function convert(value:String, type:String):Dynamic {
		return switch(type){
			case 'S' : value;
			case 'B' : value == '1';
			case 'N' : Std.parseFloat(value);
			case 'I' : Std.parseInt(value);
			case 'O' : Json.parse(value);
			case 'F' : new Flag(Std.parseInt(value));
			case 'U' : null;
			default : value;
		}
	}
	
	/**
	   Object construct by property index
	   @param	c
	   @param	o
	   @param	nfo
	   @return
	**/
	public static function parse(c:Spark, o:String, nfo:Array<String>, silent:Bool):Spark {
		var obj:Spark = c;
		var tag:Array<String> = null;
		var def:Array<String> = null;
		var par:String = null;
		Dice.Values(o.split(PROP), function(v:Dynamic){
			tag = v.split(SET);
			def = tag.shift().split(TYPE);
			par = nfo[cast def[0]];
			v = tag.join(SET).split(SPACE).join(' ');
			v = convert(v, def[1]);
			if (silent){
				Reflect.setField(c, par, v);
			}else{
				c.set(par, v);
			}
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
		var type:String = null;
		Dice.All(nfo, function(p:Int, value:Dynamic):Void {
			value = Reflect.field(o, value);
			if (Std.isOfType(value, Bool)){
				type = 'B';
				value = value ? 1 : 0;
			}else if (Std.isOfType(value, Float)){
				type = 'N';
			}else if (Std.isOfType(value, Int)){
				type = 'I';
			}else if (Std.isOfType(value, String)) {
				type = 'S';
				value = value.split(' ').join(SPACE);
			}else if (Std.isOfType(value, Flag)){
				type = 'F';
				value = value.value;
			}else if (value != null){
				type = 'O';
				value = Json.stringify(value);
			}else{
				type = 'U';
				value = '-';
			}
			result[count] = p + TYPE + type + SET + value;
			++count;
		});
		return n + (o.id != null ? " " + o.id : "") + (result.length > 0 ? " @::" + result.join(PROP) : "");
	}
	
}