package jotun.utils;

/**
 * ...
 * @author 
 */
class Validator {

	static public function email(value:String):Bool {
		return ~/^[a-z0-9!'#$%&*+\/=?^_`{|}~-]+(?:\.[a-z0-9!'#$%&*+\/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-zA-Z]{2,}$/giu.match(value);
	}
	
	static public function number(value:String):Bool {
		return ~/^\d{1,}$/.match(value);
	}
	
	static public function username(value:String):Bool {
		return ~/^[A-Za-z0-9._-]{6,24}$/.match(value);
	}
	
	static public function password(value:String):Bool {
		return ~/^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}|(?=.*?[#?!@$%^&*-_])$/giu.match(value);
	}
	
	static public function date(value:Dynamic):Bool {
		if (value == null){
			return false;
		}
		if (Std.isOfType(value, Float)){
			return value > 0;
		}
		return ~/\d{1,2}\/\d{1,2}\/\d{4}/.match(value) || ~/\d{4}\/\d{1,2}\/\d{1,2}/.match(value);
	}
	
}