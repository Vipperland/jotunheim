package sirius.utils;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('Validator')
class Validator{

	public static function checkEmail(value:String):Bool {
		return ~/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/.match(value);
	}
	
}