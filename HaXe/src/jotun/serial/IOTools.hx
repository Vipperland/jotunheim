package jotun.serial;
import haxe.Json;
import haxe.crypto.Base64;
import haxe.crypto.Md5;
import haxe.io.Bytes;
import jotun.serial.JsonTool;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('IOTools')
class IOTools {

	/**
	 * Encode Object to Base64 encoded Json String
	 * @param	q
	 * @return
	 */
	public static function encodeBase64(q:Dynamic):String {
		if (!Std.is(q, String))
			q = jsonEncode(q);
		return Base64.encode(Bytes.ofString(q));
	}
	
	/**
	 * Decode Base64 encoded Json string to Object or String
	 * @param	q
	 * @param	json
	 * @return
	 */
	public static function decodeBase64(q:String, ?json:Bool):Dynamic {
		var r:String = null;
		try {
			r = Base64.decode(q).toString();
		}catch (e:Dynamic) {}
		return r != null ? (json && r.length > 1 ? jsonDecode(r) : r) : null;
	}
	
	/**
	 * Encode Object to Json String
	 * @param	o
	 * @param	rep
	 * @param	space
	 * @return
	 */
	public static function jsonEncode(o:Dynamic, ?rep:Dynamic->Dynamic->Dynamic, ?space:String):String {
		return JsonTool.stringify(o, rep, space);
	}
	
	/**
	 * Decode Json string to dynamic Object
	 * @param	q
	 * @return
	 */
	public static function jsonDecode(q:String):Dynamic {
		return Json.parse(q);
	}
	
	/**
	 * Convert string or object to md5
	 * @param	o
	 * @param	base64
	 * @return
	 */
	public static function md5Encode(o:Dynamic, ?base64:Bool):String {
		if (Std.is(o, String))
			return Md5.encode(o);
		else
			return Md5.encode(base64 ? encodeBase64(o) : jsonEncode(o));
	}
	//
	//public static function sruCode(o:Dynamic):String {
		///*
		//
			//prop:ClassName {
				//stringVal = string
				//intVal = 1 // int
				//floatVal = 1.0 // float
				//boolVal = true // bool
				//arrayVal:Array {
				//}
				//defaultObjVal {
				//}
				//objVal:Classname {
				//}
			//}
			//
			//### Create a class with parameters call:
			//ClassName({
				//...props
			//})
			//
			//### Call a method
			//@method inline parameters separeted by space
			//@method [
				//1 // int val
				//ClassName {
				//}
			//]
		//*/
	//}
	
}