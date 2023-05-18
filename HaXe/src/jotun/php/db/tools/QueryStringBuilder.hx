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
class QueryStringBuilder {
	
	static private function _insert(parameters:Dynamic, dataset:Array<Dynamic>) {
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
	
	
	static private function _updateSet(parameters:Dynamic, dataset:Array<Dynamic>):String {
		var q:Array<String> = [];
		Dice.All(parameters, function(p:String, v:Dynamic) { 
			q[q.length] = p + "=?"; 
			dataset[dataset.length] = v;
		});
		return q.join(",");
	}
	
	
	static private function _order(obj:Dynamic):String {
		var r:Array<String> = [];
		Dice.All(obj, function(p:String, v:Dynamic) { r[r.length] = p + (v != null ? " " + v : ""); } );
		return r.join(",");
	}
	
	static private function _conditions(obj:Dynamic, props:Dynamic, joiner:String, skip:Bool):String {
		
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
	
	static private function _assembleBody(?clause:Dynamic, ?parameters:Array<Dynamic>, ?order:Dynamic, ?limit:String):String {
		var q:String = "";
		if (clause != null)
			q += " WHERE " + _conditions(clause , parameters, " || ", false);
		if (order != null)
			q += " ORDER BY " + _order(order);
		if (limit != null)
			q += " LIMIT " + limit;
		return q;
	}
	
	static public function add(table:String, ?parameters:Dynamic):String {
		var dataset:Array<Dynamic> = [];
		return _gate.prepare("INSERT INTO " + table + _insert(parameters, dataset) + _assembleBody(null, dataset) + ";", dataset);
	}
	
	static public function find(fields:Dynamic, table:Dynamic, ?clause:Dynamic, ?order:Dynamic, ?limit:String):IExtCommand {
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
	
	static public function update(table:String, ?clause:Dynamic, ?parameters:Dynamic, ?order:Dynamic, ?limit:String):String {
		var dataset:Array<Dynamic> = [];
		return _gate.prepare("UPDATE " + table + " SET " + _updateSet(parameters, dataset) + _assembleBody(clause, dataset, order, limit) + ";", dataset);
	}
	
	static public function delete(table:String, ?clause:Dynamic, ?order:Dynamic, ?limit:String):String {
		var parameters:Dynamic = [];
		return _gate.prepare("DELETE FROM " + table + _assembleBody(clause, parameters, order, limit) + ";", parameters);
	}
	
	static public function truncate(table:String):String {
		return "TRUNCATE " + table;
	}
	
	static public function rename(table:String, to:String):String {
		return "RENAME TABLE " + table + " TO " + to;
	}
	
	static public function join(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'JOIN ' + (Std.isOfType(table, IDataTable) ? table.name : table) + (name != null ? ' AS ' + name : '') + ' ON ' + _conditions(clause , [], " || ", true);
	}
	
	static public function leftJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'LEFT ' + join(table, name, clause);
	}
	
	static public function outerJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'OUTER ' + join(table, name, clause);
	}
	
	static public function leftOuterJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'LEFT ' + outerJoin(table, name, clause);
	}
	
	static public function rightOuterJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'RIGHT ' + outerJoin(table, name, clause);
	}
	
	static public function fullOuterJoin(table:Dynamic, ?name:String, ?clause:Dynamic):String {
		return 'FULL ' + outerJoin(table, name, clause);
	}
	
	static private var _enabled:Bool = false;
	
	static public function cryptoSet(value:String, key:String):String {
		return "/AES_ENCRYPT('" + value + "', '" + key + "')";
	}
	
	static public function cryptoSelect(field:String, key:String):String {
		return "/CAST(AES_DECRYPT(" + field + ",'" + key + "') AS char(255)) as " + field;
	}
	
	static public function decryptoSet(field:String, key:String):String {
		return "/CAST(AES_DECRYPT(" + field + ",'" + key + "') AS char(255))";
	}
	
}