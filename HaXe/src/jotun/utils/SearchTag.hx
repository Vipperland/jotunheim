package jotun.utils;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('J_SearchTag')
class SearchTag {
	
	private static var _M:Dynamic = [['á', 'a'], ['ã', 'a'], ['â', 'a'], ['à', 'a'], ['ê', 'e'], ['é', 'e'], ['è', 'e'], ['î', 'i'], ['í', 'i'], ['ì', 'i'], ['õ', 'o'], ['ô', 'o'], ['ó', 'o'], ['ò', 'o'], ['ú', 'u'], ['ù', 'u'], ['û', 'u'], ['ç', 'c']];
	
	private static var _E:EReg = ~/^[a-z0-9]/g;
	
	public static function from(value:Dynamic):SearchTag {
		if (!Std.is(value, SearchTag))
			value = new SearchTag(value);
		return value;
	}
	
	public static function convert(data:Dynamic, space:String = "+"):String {
		data = Std.string(data).toLowerCase();
		//data = data.substr(0,1) + _E.replace(data, '');
		var i:Int = 0;
		var l:Int = _M.length;
		while (i < l) {
			data = data.split(_M[i][0]).join(_M[i][1]);
			++i;
		}
		data = data.split(" ").join(space);
		data = data.split("\t").join(space);
		return data;
	}
	
	public var tags:Array<String>;
	
	private function _tag():String {
		return '|' + tags.join('|') + '|';
	}
	
	public function new(?tags:Dynamic) {
		tags = [];
		add(tags);
	}
	
	
	private function add(values:Dynamic):Void {
		values = Std.is(values, Array) ? values : [values];
		Dice.Values(values, function(v:Dynamic) {
			v = convert(v);
			var iof = Lambda.indexOf(this.tags, v);
			if (iof == -1)
				this.tags[this.tags.length] = v;
		});
	}
	
	
	public function remove(values:Dynamic):Void {
		values = from(values).tags;
		Dice.Values(values, function(v:String) {
			var iof = Lambda.indexOf(this.tags, v);
			if (iof != -1)
				this.tags.splice(iof, 1); 
		});
	}
	
	
	public function compare(values:Dynamic, ?equality:Bool = false):Float {
		var tag:String = _tag();
		values = from(values).tags;
		var total:UInt = values.length;
		var count:UInt = Dice.Values(values, function(v:String) {
			if (equality)
				return tag.indexOf('|' + v + '|') == -1;
			else
				return tag.indexOf(v) != -1;
		}).keys;
		return count/total * 100;
	}
	
	public function equal(values:Dynamic):Bool {
		var tag:String = _tag();
		values = from(values).tags;
		return Dice.Values(values, function(v:String) { return tag.indexOf('|' + v + '|') == -1; } ).completed;
	}
	
	public function contains(values:Dynamic):Bool {
		var tag:String = _tag();
		values = from(values).tags;
		return !Dice.Values(values, function(v:String) { return tag.indexOf(v) != -1; } ).completed;
	}
	
}