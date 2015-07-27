package sirius.bit;

/**
 * ...
 * @author Rafael Moreira
 */
class BitIO {

	static public var P01:Int = 1 << 0;
	
	static public var P02:Int = 1 << 1;
	
	static public var P03:Int = 1 << 2;
	
	static public var P04:Int = 1 << 3;
	
	static public var P05:Int = 1 << 4;
	
	static public var P06:Int = 1 << 5;
	
	static public var P07:Int = 1 << 6;
	
	static public var P08:Int = 1 << 7;
	
	static public var P09:Int = 1 << 8;
	
	static public var P10:Int = 1 << 9;
	
	static public var P11:Int = 1 << 10;
	
	static public var P12:Int = 1 << 11;
	
	static public var P13:Int = 1 << 12;
	
	static public var P14:Int = 1 << 13;
	
	static public var P15:Int = 1 << 14;
	
	static public var P16:Int = 1 << 15;
	
	static public var P17:Int = 1 << 16;
	
	static public var P18:Int = 1 << 17;
	
	static public var P19:Int = 1 << 18;
	
	static public var P20:Int = 1 << 19;
	
	static public var P21:Int = 1 << 20;
	
	static public var P22:Int = 1 << 21;
	
	static public var P23:Int = 1 << 22;
	
	static public var P24:Int = 1 << 23;
	
	static public var P25:Int = 1 << 24;
	
	static public var P26:Int = 1 << 25;
	
	static public var P27:Int = 1 << 26;
	
	static public var P28:Int = 1 << 27;
	
	static public var P29:Int = 1 << 28;
	
	static public var P30:Int = 1 << 29;
	
	static public var P31:Int = 1 << 30;
	
	static public var P32:Int = 1 << 31;
	
	public static function write(hash:Int, bit:Int):Int {
		return hash | bit;
	}
	
	public static function unwrite(hash:Int, bit:Int):Int {
		return hash & ~bit;
	}
	
	public static function toggle(hash:Int, bit:Int):Int {
		return test(hash, bit) ? unwrite(hash, bit) : write(hash, bit);
	}
	
	public static function test(hash:Int, value:Int):Bool {
		return (hash & value) == value;
	}
	
	public static function getString(hash:Dynamic, size:Int = 32):String {
		var v:String = hash.toString(2);
		while (v.length < size)
			v = "0" + v;
		return v;
	}
	
	static public var IO:Array<Dynamic> = [unwrite, write, toggle];
	
}