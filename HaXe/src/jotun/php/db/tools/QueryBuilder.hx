package jotun.php.db.tools;
import haxe.Json;
import jotun.php.db.objects.IDataTable;
import php.Lib;
import jotun.php.db.tools.ICommand;
import jotun.utils.Dice;
import jotun.utils.Filler;

/**
 * ...
 * @author Rafael Moreira
 */
class QueryBuilder implements IQueryBuilder {
	
	private var _gate:IGate;
	
	public function new(gate:IGate) {
		_gate = gate;
	}
	
	private function _insert(parameters:Dynamic, dataset:Array<Dynamic>) {
		var r:Array<String> = [];
		var q:Array<String> = [];
		var i:UInt = 0;
		Dice.All(parameters, function(p:String, v:Dynamic) { 
			r[i] = p; 
			q[i] = "?"; 
			++i;
			dataset[dataset.length] = v;
		});
		return "(" + r.join(",") + ") VALUES (" + q.join(",") + ")";
	}
	
	
	private function _updateSet(parameters:Dynamic, dataset:Array<Dynamic>):String {
		var q:Array<String> = [];
		Dice.All(parameters, function(p:String, v:Dynamic) { 
			q[q.length] = p + "=?"; 
			dataset[dataset.length] = v;
		});
		return q.join(",");
	}
	
	
	private function _order(obj:Dynamic):String {
		var r:Array<String> = [];
		Dice.All(obj, function(p:String, v:Dynamic) { r[r.length] = p + (v != null ? " " + v : ""); } );
		return r.join(",");
	}
	
	private function _conditions(obj:Dynamic, props:Dynamic, joiner:String, skip:Bool):String {
		
		var r:Array<String> = [];
		var s:String = joiner;
		var b:Bool = true;
		
		// IF IS A CLAUSULE, PARSE INNER OBJECTS
		if (Std.isOfType(obj, Clause)) {
			Dice.Values(obj.conditions, function(v:Dynamic) { 
				v = _conditions(v, props, joiner, skip);
				if (v != null){
					r[r.length] = v;
				}
			});
			s = obj.joiner();
		}
		// IF IS AN ARRAY, PARSE INNER OBJECTS
		else if(Std.isOfType(obj, Array)){
			Dice.All(obj, function(p:String, v:Dynamic) {
				v = _conditions(v, props, Std.isOfType(v, Clause) ? v.joiner() : joiner, skip);
				if (v != null){
					r[r.length] = v;
				}
			});
		}
		else if (Std.isOfType(obj, String)){
			r[r.length] = obj;
		}
		// IS IS AN OBJECT, RETURN QUERY EXPRESSION
		else if(obj != null) {
			if (Std.isOfType(obj.value, Array)){
				r[r.length] = Filler.to(obj.condition, { p:obj.param } ) ;
				Dice.All(obj.value, function(p:String, v:Dynamic){
					props[props.length] = v;
				});
			}else {
				if (skip){
					r[r.length] = Filler.splitter(Filler.to(obj.condition, { p:obj.param } ), '?', [obj.value]);
				}else{
					r[r.length] = Filler.to(obj.condition, { p:obj.param } );
					if (!obj.skip){
						props[props.length] = obj.value;
					}
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
	
	private function _assembleBody(?clause:Dynamic, ?parameters:Array<Dynamic>, ?order:Dynamic, ?limit:String):String {
		var q:String = "";
		if (clause != null)
			q += " WHERE " + _conditions(clause , parameters, " || ", false);
		if (order != null)
			q += " ORDER BY " + _order(order);
		if (limit != null)
			q += " LIMIT " + limit;
		return q;
	}
	
	public function add(table:String, ?parameters:Dynamic):ICommand {
		var dataset:Array<Dynamic> = [];
		return _gate.prepare("INSERT INTO " + table + _insert(parameters, dataset) + _assembleBody(null, dataset) + ";", dataset);
	}
	
	public function find(fields:Dynamic, table:Dynamic, ?clause:Dynamic, ?order:Dynamic, ?limit:String):IExtCommand {
		if (Std.isOfType(fields, Array)) {
			fields = fields.join(",");
		}
		var joinner:String = "";
		if (Std.isOfType(table, Array)) {
			var main:Dynamic = table.shift();
			table = main + ' ' + table.join(" ");
		}
		var parameters:Dynamic = [];
		return _gate.query("SELECT " + fields + " FROM " + table + _assembleBody(clause, parameters, order, limit) + ";", parameters);
	}
	
	public function update(table:String, ?clause:Dynamic, ?parameters:Dynamic, ?order:Dynamic, ?limit:String):ICommand {
		var dataset:Array<Dynamic> = [];
		return _gate.prepare("UPDATE " + table + " SET " + _updateSet(parameters, dataset) + _assembleBody(clause, dataset, order, limit) + ";", dataset);
	}
	
	public function delete(table:String, ?clause:Dynamic, ?order:Dynamic, ?limit:String):ICommand {
		var parameters:Dynamic = [];
		return _gate.prepare("DELETE FROM " + table + _assembleBody(clause, parameters, order, limit) + ";", parameters);
	}
	
	public function copy(from:String, to:String, ?clause:Dynamic, ?filter:Dynamic->Dynamic, ?limit:String):Array<Dynamic> {
		var entries:Dynamic = find("*", from, clause, null, limit).result;
		var result:Array<Dynamic> = [];
		Dice.Values(entries, function(v:Dynamic) { 
			if (filter != null) {
				v = filter(v);
			}
			if (add(to, v).success){
				result[result.length] = v;
			}
		});
		return result;
	}
	
	public function fKey(table:String, reference:String, ?key:String, ?target:String, ?field:String, ?delete:String = 'RESTRICT', ?update:String = 'RESTRICT'):ICommand {
		if (key == null){
			return _gate.query("ALTER TABLE " + table + " DROP FOREIGN KEY " + reference);
		}else{
			return _gate.query("ALTER TABLE " + table + " ADD CONSTRAINT " + reference + " FOREIGN KEY (" + key + ") REFERENCES " + target + "(" + field + ") ON DELETE " + delete.toUpperCase() + " ON UPDATE " + update.toUpperCase() + ";");
		}
	}
	
	public function truncate(table:String):ICommand {
		return _gate.prepare("TRUNCATE :table", {table:table});
	}
	
	public function rename(table:String, to:String):ICommand {
		return _gate.prepare("RENAME TABLE :oldname TO :newname", {oldname:table, newname:to});
	}
	
	public function join(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'JOIN ' + (Std.isOfType(table, IDataTable) ? table.name : table) + (name != null ? ' AS ' + name : '') + ' ON ' + _conditions(clause , [], " || ", true);
	}
	
	public function leftJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'LEFT ' + join(table, name, clause);
	}
	
	public function outerJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'OUTER ' + join(table, name, clause);
	}
	
	public function leftOuterJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'LEFT ' + outerJoin(table, name, clause);
	}
	
	public function rightOuterJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'RIGHT ' + outerJoin(table, name, clause);
	}
	
	public function fullOuterJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'FULL ' + outerJoin(table, name, clause);
	}
	
}