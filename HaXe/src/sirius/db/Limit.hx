package sirius.db;

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
		i = i >> 0;
		len = len >> 0;
		return (i * len) + ", " + i;
	}
	
	public static function SECTION(from:UInt, to:UInt):String {
		from = from >> 0;
		to = to >> 0;
		return from + ", " + (to - from);
	}
	
}