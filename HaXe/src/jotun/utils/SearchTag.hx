package jotun.utils;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('J_SearchTag')
class SearchTag {
	
	private static var _M:Dynamic = [
		['á', 'a'], ['ã', 'a'], ['â', 'a'], ['à', 'a'], 
		['ê', 'e'], ['é', 'e'], ['è', 'e'], 
		['î', 'i'], ['í', 'i'], ['ì', 'i'], 
		['õ', 'o'], ['ô', 'o'], ['ó', 'o'], ['ò', 'o'],
		['ú', 'u'], ['ù', 'u'], ['û', 'u'], 
		['ç', 'c'], ['ñ', 'n']
	];
	
	public static function create(value:Dynamic):SearchTag {
		if (!Std.isOfType(value, SearchTag)){
			value = new SearchTag(value);
		}
		return value;
	}
	
	private static function _clear(data:String, space:String){
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
	
	public static function clear(data:Dynamic, space:String = "+"):String {
		data = Std.string(data).toLowerCase();
		return _clear(data, space);
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
		values = Std.isOfType(values, Array) ? values : [values];
		Dice.Values(values, function(v:Dynamic) {
			v = _clear(v, '+');
			var iof = Lambda.indexOf(this.tags, v);
			if (iof == -1){
				this.tags[this.tags.length] = v;
			}
		});
	}
	
	
	public function remove(values:Dynamic):Void {
		values = create(values).tags;
		Dice.Values(values, function(v:String) {
			var iof = Lambda.indexOf(this.tags, v);
			if (iof != -1)
				this.tags.splice(iof, 1); 
		});
	}
	
	
	public function compare(values:Dynamic, ?equality:Bool = false):Float {
		var tag:String = _tag();
		values = create(values).tags;
		var total:UInt = values.length;
		var count:UInt = 
		Dice.Values(values, function(v:String) {
			if (equality){
				return tag.indexOf('|' + v + '|') == -1;
			} else{
				return tag.indexOf(v) != -1;
			}
		}).keys;
		return count/total * 100;
	}
	
	public function equal(values:Dynamic):Bool {
		var tag:String = _tag();
		return Dice.Values(create(values).tags, function(v:String) {
			return tag.indexOf('|' + v + '|') == -1; 
		}).completed;
	}
	
	public function contains(values:Dynamic):Bool {
		var tag:String = _tag();
		return !Dice.Values(create(values).tags, function(v:String) {
			return tag.indexOf(v) != -1; 
		}).completed;
	}
	
}