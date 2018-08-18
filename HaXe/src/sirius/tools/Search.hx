package sirius.tools;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.tools.Search")
class Search {

	private static var _M:Dynamic = [['á', 'a'], ['ã', 'a'], ['â', 'a'], ['à', 'a'], ['ê', 'e'], ['é', 'e'], ['è', 'e'], ['î', 'i'], ['í', 'i'], ['ì', 'i'], ['õ', 'o'], ['ô', 'o'], ['ó', 'o'], ['ò', 'o'], ['ú', 'u'], ['ù', 'u'], ['û', 'u'], ['ç', 'c'],['ä', 'a'],['ë', 'e'],['ï', 'i'],['ö', 'o'],['ü', 'u'],['ÿ', 'y']];
	public static function format(q:Dynamic, ?condense:Bool = true):String {
		q = Std.string(q.toLowerCase());
		var i:Int = 0;
		var l:Int = _M.length;
		while (i<l) {
			q = q.split(_M[i][0]).join(_M[i][1]);
			++i;
		}
		if (condense) {
			q = q.split(' ').join('');
		}
		return q;
	}
	
	public static function indexOf(q:String, n:String):Int {
		return format(q, true).indexOf(format(q, true));
	}
	
	public static function match(a:String, b:String):Bool {
		return format(a, true) == format(b, true);
	}
	
}