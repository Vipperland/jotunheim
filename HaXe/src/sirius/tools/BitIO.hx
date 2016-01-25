package sirius.tools;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
#if js
@:expose("sru.bit.BitIO")
#end
class BitIO {

	static public var P01:UInt = 1 << 0;
	
	static public var P02:UInt = 1 << 1;
	
	static public var P03:UInt = 1 << 2;
	
	static public var P04:UInt = 1 << 3;
	
	static public var P05:UInt = 1 << 4;
	
	static public var P06:UInt = 1 << 5;
	
	static public var P07:UInt = 1 << 6;
	
	static public var P08:UInt = 1 << 7;
	
	static public var P09:UInt = 1 << 8;
	
	static public var P10:UInt = 1 << 9;
	
	static public var P11:UInt = 1 << 10;
	
	static public var P12:UInt = 1 << 11;
	
	static public var P13:UInt = 1 << 12;
	
	static public var P14:UInt = 1 << 13;
	
	static public var P15:UInt = 1 << 14;
	
	static public var P16:UInt = 1 << 15;
	
	static public var P17:UInt = 1 << 16;
	
	static public var P18:UInt = 1 << 17;
	
	static public var P19:UInt = 1 << 18;
	
	static public var P20:UInt = 1 << 19;
	
	static public var P21:UInt = 1 << 20;
	
	static public var P22:UInt = 1 << 21;
	
	static public var P23:UInt = 1 << 22;
	
	static public var P24:UInt = 1 << 23;
	
	static public var P25:UInt = 1 << 24;
	
	static public var P26:UInt = 1 << 25;
	
	static public var P27:UInt = 1 << 26;
	
	static public var P28:UInt = 1 << 27;
	
	static public var P29:UInt = 1 << 28;
	
	static public var P30:UInt = 1 << 29;
	
	static public var P31:UInt = 1 << 30;
	
	static public var P32:UInt = 1 << 31;
	
	public static function Write(hash:UInt, bit:UInt):UInt {
		return hash | bit;
	}
	
	public static function Unwrite(hash:UInt, bit:UInt):UInt {
		return hash & ~bit;
	}
	
	public static function Toggle(hash:UInt, bit:UInt):UInt {
		return Test(hash, bit) ? Unwrite(hash, bit) : Write(hash, bit);
	}
	
	public static function Test(hash:UInt, value:UInt):Bool {
		return (hash & value) == value;
	}
	
	public static function Value(hash:Dynamic, size:UInt = 32):String {
		var v:String = hash.toString(2);
		while (v.length < size)
			v = "0" + v;
		return v;
	}
	
	static public var X:Array<Dynamic> = [Unwrite, Write, Toggle];
	
	public var value:UInt;
	
	public function new(value:UInt) {
		this.value = Std.parseInt(cast value);
	}
	
	public function invert(bit:UInt):Void {
		value = Toggle(value, bit);
	}
	
	public function set(bit:UInt):Void {
		value = Write(value, bit);
	}
	
	public function unset(bit:UInt):Void {
		value = Unwrite(value, bit);
	}
	
	public function get(bit:UInt):Bool {
		return Test(value, bit);
	}
	
	public function valueOf(size:UInt=32):String {
		return Value(value, size);
	}
	
}