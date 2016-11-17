package sirius.serial;

/**
 * ...
 * @author Rafael Moreira <vipperland[at]live.com>
 */
class Vault {

	public static function create(q:String):String {
		return untyped __call__("password_hash", q, untyped __php__("PASSWORD_BCRYPT"), untyped __php__("['cost'=>12]"));
	}
	
	public static function match(q:String, hash:String):Bool {
		return untyped __call__("password_verify", q, hash);
	}
	
}