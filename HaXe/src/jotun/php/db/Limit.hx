package jotun.php.db;

/**
 * ...
 * @author Rafael Moreira
 */
class Limit{
	
	public static var ONE:String = "1";
	
	public static function MAX(i:UInt = 1):String {
		return Std.string(i);
	}
	
	public static function PAGE(i:UInt, len:UInt = 10):String {
		return len + " OFFSET " + (i * len);
	}

	public static function SECTION(from:UInt, to:UInt):String {
		return (to - from) + " OFFSET " + from;
	}
	
}