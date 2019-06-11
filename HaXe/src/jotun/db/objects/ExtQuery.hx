package jotun.db.objects;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class ExtQuery extends Query implements IExtQuery {
	
	public var data:Array<Dynamic>;
	
	public function new(table:IDataTable, data:Array<Dynamic>) {
		super(table, true);
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