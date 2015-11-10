package sirius.db.tools;
import haxe.Json;
import sirius.db.tools.ICommand;
import sirius.utils.Dice;
import sirius.utils.Filler;

/**
 * ...
 * @author Rafael Moreira
 */
class QueryBuilder implements IQueryBuilder {
	
	private var _gate:IGate;
	
	public function new(gate:IGate) {
		_gate = gate;
	}
	
	private function _conditions(obj:Dynamic, props:Dynamic, joiner:String):String {
		
		var r:Array<String> = [];
		var s:String = joiner;
		var b:Bool = true;
		
		// IF IS A CLAUSULE, PARSE INNER OBJECTS
		if (Std.is(obj, Clause)) {
			Dice.Values(obj.conditions, function(v:Dynamic) { r[r.length] = _conditions(v, props, joiner); });
			s = obj.joiner();
		}
		// IF IS AN ARRAY, PARSE INNER OBJECTS
		else if(Std.is(obj, Array)){
			Dice.All(obj, function(p:String, v:Dynamic) {
				if (Std.is(v, Clause)) {
					r[r.length] = _conditions(v, props, v.joiner());
				}else {
					r[r.length] = _conditions(v, props, joiner);
				}
			});
		}
		// IS IS AN OBJECT, RETURN QUERY EXPRESSION
		else {
			r[r.length] = Filler.to(obj.condition, { p:obj.param } ) ;
			Reflect.setField(props, "in_" + obj.param, obj.value);
		}
		
		b = r.length > 1;
		return (b ? "(" : "") + r.join(s) + (b ? ")" : "");
		
	}
	
	
	private function _assembleBody(?clause:Dynamic = null, ?parameters:Dynamic = null, ?order:Dynamic = null, ?limit:String = null):String {
		var q:String = "";
		if (clause != null) q += " WHERE " + _conditions(clause , parameters, " || ");
		if (order != null) q += " ORDER BY " + _order(order);
		if (limit != null) q += " LIMIT " + limit;
		return q;
	}
	
	
	public function create(table:String, ?clause:Dynamic = null, ?parameters:Dynamic = null, ?order:Dynamic = null, ?limit:String = null):ICommand {
		return _gate.prepare("INSERT INTO " + table + _assembleBody(clause, parameters, order, limit) + ";", parameters, null);
	}
	
	
	public function find(fields:Dynamic, table:String, ?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null):ICommand {
		if (Std.is(fields, Array)) fields = fields.join(",");
		var parameters:Dynamic = { };
		return _gate.prepare("SELECT " + fields + " FROM " + table + _assembleBody(clause, parameters, order, limit) + ";", parameters, null);
	}
	
	
	public function update(table:String, ?clause:Dynamic = null, ?parameters:Dynamic = null, ?order:Dynamic = null, ?limit:String = null):ICommand {
		if (parameters == null) parameters = { };
		return _gate.prepare("UPDATE " + table + " " + _updateSet(parameters) + _assembleBody(clause, parameters, order, limit) + ";", parameters, null);
	}
	
	public function delete(table:String, ?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null):ICommand {
		var parameters:Dynamic = { };
		return _gate.prepare("DELETE FROM " + table + _assembleBody(clause, parameters, order, limit) + ";", parameters, null);
	}
	
	private function _insert(parameters:Dynamic) {
		var q:Array<String> = [];
		Dice.Params(parameters, function(p:String) { q[q.length] = p; } );
		return "(" + q.join(",") + ") VALUES (:" + q.join(",:") + ")";
	}
	
	
	private function _updateSet(parameters:Dynamic):String {
		var q:Array<String> = [];
		Dice.Params(parameters, function(p:String) { q[q.length] = p + "=:" + p; });
		return q.join(",");
	}
	
	
	private function _order(obj:Dynamic):String {
		var r:Array<String> = [];
		Dice.All(obj, function(p:String, v:Dynamic) { r[r.length] = p + (v != null ? " " + v : ""); } );
		return r.join(",");
	}
	
}