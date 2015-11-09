package sirius.db;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class QueryBuilder{
	
	public function new() {
		
	}
	
	private function _clausule(obj:Dynamic):String {
		var r:Array<String> = [];
		var s:String = " && ";
		var b:Bool = true;
		// IF ARRAY, CREATE "AND" BETWEEN OBJECTS
		if (Std.is(obj, Array)) {
			Dice.Values(obj, function(v:Dynamic) { r[r.length] = _clausule(v); });
			s = " || ";
		}else{
			// IF OBJECT, CREATE ||
			Dice.All(obj, function(p:String, v:Dynamic) { r[r.length] = p + (v == null ? "=" : v) + ":" + p; } );
		}
		b = r.length > 1;
		return (b ? "(" : "") + r.join(s) + (b ? ")" : "");
		
	}
	
	public function select(fields:Dynamic, table:String, ?conditions:Array<Dynamic> = null, ?properties:Dynamic = null, ?order:Dynamic = null, ?limit:String = null):String {
		if (Std.is(fields, Array)) fields = fields.join(",");
		var q:String = "SELECT " + fields + " FROM " + table;
		if (conditions != null) q += " WHERE " + _clausule(conditions);
		if (order != null) q += " ORDER BY " + _order(order);
		if (limit != null) q += " LIMIT " + limit;
		return q + ";";
	}
	
	public function _order(obj:Dynamic):String {
		var r:Array<String> = [];
		Dice.All(obj, function(p:String, v:Dynamic) { r[r.length] = p + (v != null ? " " + v : ""); } );
		return r.join(",");
		
	}
	
}

/*

	select('id,name,email', 'users', [[{},{}], [[{}],[{},{}]]])
									(A1 && A2) || (B1 || (C1 && C2))

*/