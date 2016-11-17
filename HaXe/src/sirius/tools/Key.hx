package sirius.tools;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.tools.Key")
class Key {
	
	static private var _cts:Dynamic = {'global':0};
	public static function COUNTER(?id:String):Int {
		if (id == null) 
			id = 'global';
		var v:UInt = 0;
		if (!Reflect.hasField(_cts, id)) 
			Reflect.setField(_cts, id, 0);
		else {
			v = Reflect.field(_cts, id);
			Reflect.setField(_cts, id, v+1);
		}
		return v;
	}
	
	private static var TABLE:String = "abcdefghijklmnopqrstuvwxyz0123456789";
	
	public static function GEN(?size:UInt=9, ?table:String = null, ?mixCase:Bool = true):String {
		var s:String = "";
		if (table == null) table = TABLE;
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