package sirius.tools;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.tools.Key")
class Key {
	
	static private var _counter:Int = 0;
	public static function COUNTER():Int {
		return _counter++;
	}
	
	public static function GEN(size:UInt, table:String, ?mixCase:Bool = true):String {
		var s:String = "";
		var l:UInt = table.length;
		var c:String = null;
		while (s.length < size) {
			c = table.substr(Std.random(l), 1);
			if (mixCase) {
				if (Math.random() < .5) c = c.toUpperCase();
				else c = c.toLowerCase();
			}
			s += c;
		}
		return s;
	}
	
}