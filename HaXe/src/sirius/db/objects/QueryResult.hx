package sirius.db.objects;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class QueryResult implements IQueryResult {
	
	public var data:Array<Dynamic>;
	
	public function new(data:Array<Dynamic>) {
		this.data = data != null ? data : [];	
	}
	
	public function each(handler:Dynamic->Bool):Void {
		Dice.Values(data, function(v:Dynamic) {
			return handler(v) == true;
		});
	}
	
	public function one(i:Int):Dynamic {
		return (i < data.length) ? data[i] : null;
	}
	
	public function first():Dynamic {
		return one(0);
	}
	
	public function last():Dynamic {
		return one(data.length - 1);
	}
	
	public function slice():Dynamic {
		return (data.length > 0) ? data.shift() : null;
	}
	
}