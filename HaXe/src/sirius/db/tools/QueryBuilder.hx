package sirius.db.tools;
import haxe.Json;
import php.Lib;
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
	
	private function _insert(parameters:Dynamic) {
		var q:Array<String> = [];
		Dice.Params(parameters, function(p:String) { q[q.length] = p; } );
		return "(" + q.join(",") + ") VALUES (:" + q.join(",:") + ")";
	}
	
	
	private function _updateSet(parameters:Dynamic):String {
		var q:Array<String> = [];
		Dice.All(parameters, function(p:String, v:Dynamic) { 
			q[q.length] = p + "=:" + p; 
		});
		return q.join(",");
	}
	
	
	private function _order(obj:Dynamic):String {
		var r:Array<String> = [];
		Dice.All(obj, function(p:String, v:Dynamic) { r[r.length] = p + (v != null ? " " + v : ""); } );
		return r.join(",");
	}
	
	private function _conditions(obj:Dynamic, props:Dynamic, joiner:String, i:UInt = 0):String {
		
		var r:Array<String> = [];
		var s:String = joiner;
		var b:Bool = true;
		
		// IF IS A CLAUSULE, PARSE INNER OBJECTS
		if (Std.is(obj, Clause)) {
			Dice.Values(obj.conditions, function(v:Dynamic) { 
				v = _conditions(v, props, joiner);
				if(v != null)
					r[r.length] = v;
			});
			s = obj.joiner();
		}
		// IF IS AN ARRAY, PARSE INNER OBJECTS
		else if(Std.is(obj, Array)){
			Dice.All(obj, function(p:String, v:Dynamic) {
				if (Std.is(v, Clause)) {
					v = _conditions(v, props, v.joiner());
					if (v != null)
						r[r.length] = v;
				}else {
					v = _conditions(v, props, joiner);
					if (v != null)
						r[r.length] = v;
				}
			});
		}
		// IS IS AN OBJECT, RETURN QUERY EXPRESSION
		else {
			if (Std.is(obj.value, Array)){
				r[r.length] = Filler.to(obj.condition, { p:obj.param } ) ;
				Dice.All(obj.value, function(p:String, v:Dynamic){
					Reflect.setField(props, "in_" + obj.i + "x" + p + "_", v);
				});
			}else {
				r[r.length] = Filler.to(obj.condition, { p:obj.param } ) ;
				if (obj.value != null){
					Reflect.setField(props, "in_" + obj.i + "_", obj.value);
				}
			}
		}
		
		if(r.length > 0){
			b = r.length > 1;
			return (b ? "(" : "") + r.join(s) + (b ? ")" : "");
		}else {
			return null;
		}
		
	}
	
	private function _assembleBody(?clause:Dynamic, ?parameters:Dynamic, ?order:Dynamic, ?limit:String):String {
		var q:String = "";
		if (clause != null)
			q += " WHERE " + _conditions(clause , parameters, " || ");
		if (order != null)
			q += " ORDER BY " + _order(order);
		if (limit != null)
			q += " LIMIT " + limit;
		return q;
	}
	
	public function add(table:String, ?clause:Dynamic, ?parameters:Dynamic, ?order:Dynamic, ?limit:String):ICommand {
		return _gate.prepare("INSERT INTO " + table + _insert(parameters) + _assembleBody(clause, parameters, order, limit) + ";", parameters, null);
	}
	
	public function find(fields:Dynamic, table:String, ?clause:Dynamic, ?order:Dynamic, ?limit:String):ICommand {
		if (Std.is(fields, Array)) fields = fields.join(",");
		var parameters:Dynamic = { };
		return _gate.prepare("SELECT " + fields + " FROM " + table + _assembleBody(clause, parameters, order, limit) + ";", parameters, null, null);
	}
	
	public function update(table:String, ?clause:Dynamic, ?parameters:Dynamic, ?order:Dynamic, ?limit:String):ICommand {
		if (parameters == null) parameters = { };
		return _gate.prepare("UPDATE " + table + " SET " + _updateSet(parameters) + _assembleBody(clause, parameters, order, limit) + ";", parameters, null);
	}
	
	public function delete(table:String, ?clause:Dynamic, ?order:Dynamic, ?limit:String):ICommand {
		var parameters:Dynamic = { };
		return _gate.prepare("DELETE FROM " + table + _assembleBody(clause, parameters, order, limit) + ";", parameters, null);
	}
	
	public function copy(from:String, to:String, ?clause:Dynamic, ?filter:Dynamic->Dynamic, ?limit:String):ICommand {
		var entries:Dynamic = find("*", from, clause, null, limit).result;
		Dice.Values(entries, function(v:Dynamic) { 
			if (filter != null) v = filter(v);
			add(to, null, v, null, null); 
		});
		return null;
	}
	
	public function fKey(table:String, reference:String, ?key:String, ?target:String, ?field:String, ?delete:String = 'RESTRICT', ?update:String = 'RESTRICT'):ICommand {
		if (key == null){
			return _gate.prepare("ALTER TABLE " + table + " DROP FOREIGN KEY " + reference);
		}else{
			return _gate.prepare("ALTER TABLE " + table + " ADD CONSTRAINT " + reference + " FOREIGN KEY (" + key + ") REFERENCES " + target + "(" + field + ") ON DELETE " + delete.toUpperCase() + " ON UPDATE " + update.toUpperCase() + ";");
		}
	}
	
	public function truncate(table:String):ICommand {
		return _gate.prepare("TRUNCATE :table", {table:table});
	}
	
	public function rename(table:String, to:String):ICommand {
		return _gate.prepare("RENAME TABLE :oldname TO :newname", {oldname:table, newname:to});
	}
	
}