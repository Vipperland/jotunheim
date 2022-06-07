package jotun.tools;
import jotun.utils.Dice;
import jotun.utils.IDiceRoll;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
#if js
@:expose("Flag")
#end
class Flag {
	
	/* 
		Flag 1<<00 = 1
		Flag 1<<01 = 2
		Flag 1<<02 = 4
		Flag 1<<03 = 8
		Flag 1<<04 = 16
		Flag 1<<05 = 32
		Flag 1<<06 = 64
		Flag 1<<07 = 128
		Flag 1<<08 = 256
		Flag 1<<09 = 512
		Flag 1<<10 = 1024
		Flag 1<<11 = 2048
		Flag 1<<12 = 4096
		Flag 1<<13 = 8192
		Flag 1<<14 = 16384
		Flag 1<<15 = 32768
		Flag 1<<16 = 65536
		Flag 1<<17 = 131072
		Flag 1<<18 = 262144
		Flag 1<<19 = 524288
		Flag 1<<20 = 1048576
		Flag 1<<21 = 2097152
		Flag 1<<22 = 4194304
		Flag 1<<23 = 8388608
		Flag 1<<24 = 16777216
		Flag 1<<25 = 33554432
		Flag 1<<26 = 67108864
		Flag 1<<27 = 134217728
		Flag 1<<28 = 268435456
		Flag 1<<29 = 536870912
		Flag 1<<30 = 1073741824
		Flag 1<<31 = 2147483648
	*/
	
	public static function from(hash:Dynamic):Flag {
		if (Std.is(hash, String)){
			hash = Std.parseInt(hash);
		}
		return new Flag(hash);
	}
	
	public static function FPut(hash:UInt, bit:UInt):UInt {
		return hash | bit;
	}
	
	public static function FDrop(hash:UInt, bit:UInt):UInt {
		return hash & ~bit;
	}
	
	public static function FToggle(hash:UInt, bit:UInt):UInt {
		return FTest(hash, bit) ? FDrop(hash, bit) : FPut(hash, bit);
	}
	
	public static function FTest(hash:UInt, value:UInt):Bool {
		return (hash & value) == value;
	}
	
	public static function FValue(hash:UInt, ?size:UInt = 32, ?glen:UInt = 8):String {
		var r:String = '';
		var g:Int = 0;
		while(size>0){
			--size;
			r += FTest(hash, 1 << size) ? '1' : '0';
			if (++g == glen){
				g = 0;
				r += ' ';
			}
		}
		return r;
	}
	
	public static function FLength(hash:UInt):UInt {
		var count:UInt = 0;
		while (hash>0) {
			hash &= hash-1;
			++count;
		}
		return count;
	}
	
	public var value:UInt;
	
	public function new(value:UInt) {
		if (!Std.is(value, Float) && Std.is(value, Int)) value = Std.parseInt(cast value);
		this.value = value>>>0;
	}
	
	public function toggle(bit:UInt):Flag {
		value = FToggle(value, bit);
		return this;
	}
	
	public function put(bit:UInt):Flag {
		value = FPut(value, 1<<bit);
		return this;
	}
	
	public function drop(bit:UInt):Flag {
		value = FDrop(value, 1<<bit);
		return this;
	}
	
	public function test(bit:UInt):Bool {
		return FTest(value, 1<<bit);
	}
	
	public function putAll(bits:Array<UInt>):Flag {
		Dice.Values(bits, function(v:UInt){
			put(1<<v);
		});
		return this;
	}
	
	public function dropAll(bits:Array<UInt>):Flag {
		Dice.Values(bits, function(v:UInt){
			drop(1<<v);
		});
		return this;
	}
	
	public function testAll(bits:Array<UInt>):Bool {
		return Dice.Values(bits, function(v:UInt){
			return !test(v);
		}).completed;
	}
	
	public function testAny(bits:Array<UInt>, ?min:UInt=1):Bool {
		return !Dice.Values(bits, function(v:UInt){
			if (test(v)){
				--min;
			}
			return min == 0;
		}).completed;
	}
	
	public function length():UInt {
		return FLength(value);
	}
	
	public function toString(?size:UInt = 32, ?glen:UInt = 8):String {
		return FValue(value, size, glen);
	}
	
}