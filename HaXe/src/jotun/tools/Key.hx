package jotun.tools;
import jotun.serial.Packager;
#if js
	import js.RegExp;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_Key")
class Key {
	
	private static var TABLE:String = "abcdefghijklmnopqrstuvwxyz0123456789";
	
	static private var _cts:Dynamic = {'global':0};
	
	public static function COUNTER(?id:String):Int {
		if (id == null) 
			id = 'global';
		var v:UInt = 0;
		if (!Reflect.hasField(_cts, id)) 
			Reflect.setField(_cts, id, 0);
		else {
			v = Reflect.field(_cts, id);
			Reflect.setField(_cts, id, v+1);
		}
		return v;
	}
	
	public static function GEN(?size:UInt=9, ?table:String = null, ?mixCase:Bool = true):String {
		var s:String = "";
		if (table == null) {
			table = TABLE;
		}
		var l:UInt = table.length;
		var c:String = null;
		while (s.length < size) {
			c = table.substr(Std.random(l), 1);
			if (mixCase) {
				if (Math.random() < .5) c = c.toUpperCase();
				else c = c.toLowerCase();
			}
			s += c;
		}
		return s;
	}
	
	private static var _last_uuid:String;
	public static function getLastUUID():String {
		return _last_uuid;
	}
	
	public static function UUID():String {
		_last_uuid = Packager.md5Encode(Date.now() + '-' + GEN());
		return _last_uuid;
	}
	
	public static function TAG(value:Dynamic, ?prefix:String = '0', ?len:Int = 11):String {
		if (!Std.is(value, String)){
			value = Std.string(value);
		}else if (value == null){
			value = COUNTER('tag');
		}
		var k:Int = value.length;
		while (k < len){
			value = prefix + value;
			++k;
		}
		return value;
	}
	
	public static var VALIDATE_DATE:EReg = ~/\d{1,2}\/\d{1,2}\/\d{4}/;
	
	public static var VALIDATE_URL:EReg = ~/https?:\/\/.+/;
	
	public static var VALIDATE_IPV4:EReg = ~/^\d{1,3}d{1,3}.\d{1,3}.\d{1,3}/;
	
	public static var VALIDATE_CURRENCY:EReg = ~/\d+(.\d{2})?/;
	
	public static var VALIDATE_EMAIL:EReg = ~/^[a-z0-9!'#$%&*+\/=?^_`{|}~-]+(?:\.[a-z0-9!'#$%&*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-zA-Z]{2,}$/giu;
	
	public static var VALIDATE_NUMBER:EReg = ~/^\d{1,}$/;
	
	public static var VALIDATE_PHONE:EReg = ~/^(\d{10,11})|(\(\d{2}\) \d{4,5}-\d{4})$/;
	
	public static var VALIDATE_LETTER:EReg = ~/^[a-zA-Z]{6,}$/;
	
	public static var VALIDATE_USER_NAME:EReg = ~/^[a-zA-Z ]{8,100}$/;
	
	public static var VALIDATE_CHAR_NAME:EReg = ~/^[a-zA-Z ]{8,32}$/;
	
	public static var VALIDATE_NON_URL:EReg = ~/^[A-Za-z0-9._-]{6,24}$/;
	
	public static var VALIDATE_HASH:EReg = ~/^[A-Za-z0-9._-]{35}$/;
	
	public static var VALIDATE_CARD:EReg = ~/\d{4}-\d{4}-\d{4}-\d{4}$/;
	
}