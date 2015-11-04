package sirius.utils;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.Json;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('Criptog')
class Criptog {

	public static function encodeBase64(q:Dynamic):String {
		if (!Std.is(q, String)) q = Json.stringify(q);
		return Base64.encode(Bytes.ofString(q));
	}
	
	public static function decodeBase64(q:String, ?json:Bool):Dynamic {
		var r:String = null;
		try {
			r = Base64.decode(q).toString();
		}catch (e:Dynamic) {}
		return r != null ? (json && r.length > 1 ? Json.parse(r) : r) : null;
	}
	
}