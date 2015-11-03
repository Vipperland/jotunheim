package sirius.utils;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.Json;

/**
 * ...
 * @author Rafael Moreira
 */
class Criptog {

	public static function encodeBase64(q:Dynamic):String {
		if (!Std.is(q, String)) q = Json.stringify(q);
		return Base64.encode(Bytes.ofString(q));
	}
	
	public static function decodeBase64(q:String, ?json:Bool):Dynamic {
		var r:String = Base64.decode(q).toString();
		return json && r.length > 1 ? Json.parse(r) : r;
	}
	
}