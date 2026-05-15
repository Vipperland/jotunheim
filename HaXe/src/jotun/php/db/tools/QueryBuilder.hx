package jotun.php.db.tools;
import haxe.Json;
import jotun.logical.Flag;
import jotun.php.db.objects.DataTable;
import php.Lib;
import jotun.php.db.tools.ICommand;
import jotun.utils.Dice;
import jotun.utils.Filler;

/**
 * ...
 * @author Rafael Moreira
 */
class QueryBuilder {

	private var _gate:Gate;

	/**
	 * var q:Dynamic = Jotun.gate.table('users').findJoin(['users.id as UID','users.name as NAME','state.alt as STATE','city.name as CITY'], [
			Jotun.gate.builder.leftJoin('user_address', 'address', Clause.EQUAL('address.user_id', 1)),
			Jotun.gate.builder.leftJoin('location_state', 'state', Clause.CUSTOM('state.id=address.state_id')),
			Jotun.gate.builder.leftJoin('location_city', 'city', 'city.id=address.city_id'),
		], Clause.CUSTOM('users.id<30'));
	 * @param	gate
	 */
	public function new(gate:Gate) {
		_gate = gate;
	}

	private function _insert(parameters:Dynamic, dataset:Array<Dynamic>) {
		var r:Array<String> = [];
		var q:Array<String> = [];
		Dice.All(parameters, function(p:String, v:Dynamic):Void {
			if (Reflect.isFunction(v)){
				return;
			}
			if(Std.isOfType(v, Flag)){
				v = cast (v, Flag).value;
			}else if(Std.isOfType(v, Array)){
				v = v.join(",");
			}
			r.push(p);
			q.push("?");
			if(v == null || Std.isOfType(v, String) || Std.isOfType(v, Bool) || Std.isOfType(v, Float) || Std.isOfType(v, Int)){
				dataset.push(v);
			}else{
				dataset.push(Json.stringify(v));
			}
		});
		return "(" + r.join(",") + ") VALUES (" + q.join(",") + ")";
	}

	/**
	 *
	 * @param	parameters
	 * @param	dataset
	 * @return
	 */
	private function _updateSet(parameters:Dynamic, dataset:Array<Dynamic>):String {
		var q:Array<String> = [];
		Dice.All(parameters, function(p:String, v:Dynamic):Void {
			if (Reflect.isFunction(v)){
				return;
			}
			if(Std.isOfType(v, Flag)){
				v = cast (v, Flag).value;
			}else if(Std.isOfType(v, Array)){
				v = v.join(",");
			}
			q.push(p + "=?");
			if(v == null || Std.isOfType(v, String) || Std.isOfType(v, Bool) || Std.isOfType(v, Float) || Std.isOfType(v, Int)){
				dataset.push(v);
			}else{
				dataset.push(Json.stringify(v));
			}
		});
		return q.join(",");
	}

	/**
	 *
	 * @param	obj
	 * @return
	 */
	private function _order(obj:Dynamic):String {
		var r:Array<String> = [];
		Dice.All(obj, function(p:String, v:Dynamic):Void {
			r.push(p + (v != null ? " " + v : ""));
		});
		return r.join(",");
	}

	/**
	 *
	 * @param	obj
	 * @param	props
	 * @param	joiner
	 * @param	skip
	 * @return
	 */
	private function _conditions(obj:Dynamic, props:Dynamic, joiner:String, skip:Bool):String {

		var r:Array<String> = [];
		var s:String = joiner;
		var b:Bool = true;

		// IF IS A CLAUSULE, PARSE INNER OBJECTS
		if (Std.isOfType(obj, Clause)) {
			Dice.Values(obj.conditions, function(v:Dynamic) {
				v = _conditions(v, props, joiner, skip);
				if (v != null){
					r.push(v);
				}
			});
			s = obj.joiner();
		}
		// IF IS AN ARRAY, PARSE INNER OBJECTS
		else if(Std.isOfType(obj, Array)){
			Dice.All(obj, function(p:String, v:Dynamic):Void {
				v = _conditions(v, props, Std.isOfType(v, Clause) ? v.joiner() : joiner, skip);
				if (v != null){
					r.push(v);
				}
			});
		}
		else if (Std.isOfType(obj, String)){
			r.push(obj);
		}
		// IS IS AN OBJECT, RETURN QUERY EXPRESSION
		else if(obj != null) {
			if (Std.isOfType(obj.value, Array)){
				r.push(Filler.to(obj.condition, { p:obj.param }));
				Dice.All(obj.value, function(p:String, v:Dynamic):Void {
					props.push(v);
				});
			}else {
				if (skip){
					r.push(Filler.splitter(Filler.to(obj.condition, { p:obj.param }), '?', [obj.value]));
				}else{
					r.push(Filler.to(obj.condition, { p:obj.param }));
					if (!obj.skip){
						props.push(obj.value);
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

	/**
	 *
	 * @param	clause
	 * @param	parameters
	 * @param	order
	 * @param	limit
	 * @return
	 */
	private function _assembleBody(?clause:Dynamic, ?parameters:Array<Dynamic>, ?order:Dynamic, ?limit:String, ?group:String):String {
		var q:String = "";
		if (clause != null){
			q += " WHERE " + _conditions(clause, parameters, " OR ", false);
		}
		if (group != null){
			q += " GROUP BY " + group;
		}
		if (order != null){
			q += " ORDER BY " + _order(order);
		}
		if (limit != null){
			q += " LIMIT " + limit;
		}
		return q;
	}

	/**
	 *
	 * @param	table
	 * @param	parameters
	 * @return
	 */
	public function add(table:String, ?parameters:Dynamic):ICommand {
		var dataset:Array<Dynamic> = [];
		return _gate.prepare("INSERT INTO " + table + _insert(parameters, dataset) + _assembleBody(null, dataset) + ";", dataset);
	}

	/**
	 *
	 * @param	fields
	 * @param	table
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function find(fields:Dynamic, table:Dynamic, ?clause:Dynamic, ?order:Dynamic, ?limit:String, ?group:String):IExtCommand {
		if (Std.isOfType(fields, Array)) {
			fields = fields.join(",");
		}
		if (Std.isOfType(table, Array)) {
			var main:Dynamic = table.shift();
			table = main + ' ' + table.join(" ");
		}
		var parameters:Array<Dynamic> = [];
		return _gate.query("SELECT " + fields + " FROM " + table + _assembleBody(clause, parameters, order, limit, group) + ";", parameters);
	}

	/**
	 *
	 * @param	table
	 * @param	clause
	 * @param	parameters
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function update(table:String, ?clause:Dynamic, ?parameters:Dynamic, ?order:Dynamic, ?limit:String):ICommand {
		var dataset:Array<Dynamic> = [];
		return _gate.prepare("UPDATE " + table + " SET " + _updateSet(parameters, dataset) + _assembleBody(clause, dataset, order, limit) + ";", dataset);
	}

	/**
	 *
	 * @param	table
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function delete(table:String, ?clause:Dynamic, ?order:Dynamic, ?limit:String):ICommand {
		var parameters:Array<Dynamic> = [];
		return _gate.prepare("DELETE FROM " + table + _assembleBody(clause, parameters, order, limit) + ";", parameters);
	}

	/**
	 *
	 * @param	from
	 * @param	to
	 * @param	clause
	 * @param	filter
	 * @param	limit
	 * @return
	 */
	public function copy(from:String, to:String, ?clause:Dynamic, ?filter:Dynamic->Dynamic, ?limit:String):Array<Dynamic> {
		var entries:Dynamic = find("*", from, clause, null, limit).result;
		var result:Array<Dynamic> = [];
		Dice.Values(entries, function(v:Dynamic) {
			if (filter != null) {
				v = filter(v);
			}
			if (add(to, v).success){
				result.push(v);
			}
		});
		return result;
	}

	/**
	 * INSERT ... ON DUPLICATE KEY UPDATE col=VALUES(col),...
	 * @param	table
	 * @param	parameters
	 * @return
	 */
	public function upsert(table:String, ?parameters:Dynamic):ICommand {
		var dataset:Array<Dynamic> = [];
		var cols:Array<String> = [];
		var placeholders:Array<String> = [];
		Dice.All(parameters, function(p:String, v:Dynamic):Void {
			if (Reflect.isFunction(v)) return;
			if (Std.isOfType(v, Flag)) v = cast(v, Flag).value;
			else if (Std.isOfType(v, Array)) v = v.join(",");
			cols.push(p);
			placeholders.push("?");
			dataset.push(v == null || Std.isOfType(v, String) || Std.isOfType(v, Bool) || Std.isOfType(v, Float) || Std.isOfType(v, Int) ? v : Json.stringify(v));
		});
		var updates:String = cols.map(function(c) return c + "=VALUES(" + c + ")").join(",");
		return _gate.prepare("INSERT INTO " + table + " (" + cols.join(",") + ") VALUES (" + placeholders.join(",") + ") ON DUPLICATE KEY UPDATE " + updates + ";", dataset);
	}

	/**
	 * INSERT INTO table (cols) VALUES (...),(...),...
	 * @param	table
	 * @param	rows
	 * @return
	 */
	public function addBatch(table:String, rows:Array<Dynamic>):ICommand {
		if (rows == null || rows.length == 0) return _gate.prepare("SELECT 0;");
		var dataset:Array<Dynamic> = [];
		var cols:Array<String> = null;
		var valueSets:Array<String> = [];
		Dice.Values(rows, function(row:Dynamic):Void {
			var rowCols:Array<String> = [];
			var placeholders:Array<String> = [];
			Dice.All(row, function(p:String, v:Dynamic):Void {
				if (Reflect.isFunction(v)) return;
				if (Std.isOfType(v, Flag)) v = cast(v, Flag).value;
				else if (Std.isOfType(v, Array)) v = v.join(",");
				rowCols.push(p);
				placeholders.push("?");
				dataset.push(v == null || Std.isOfType(v, String) || Std.isOfType(v, Bool) || Std.isOfType(v, Float) || Std.isOfType(v, Int) ? v : Json.stringify(v));
			});
			if (cols == null) cols = rowCols;
			valueSets.push("(" + placeholders.join(",") + ")");
		});
		return _gate.prepare("INSERT INTO " + table + " (" + cols.join(",") + ") VALUES " + valueSets.join(",") + ";", dataset);
	}

	/**
	 * UPDATE table SET field = field + amount
	 * @param	table
	 * @param	field
	 * @param	amount
	 * @param	clause
	 * @param	limit
	 * @return
	 */
	public function increment(table:String, field:String, ?amount:Float = 1, ?clause:Dynamic, ?limit:String):ICommand {
		var dataset:Array<Dynamic> = [amount];
		return _gate.prepare("UPDATE " + table + " SET " + field + "=" + field + "+?" + _assembleBody(clause, dataset, null, limit) + ";", dataset);
	}

	/**
	 *
	 * @param	table
	 * @param	reference
	 * @param	key
	 * @param	target
	 * @param	field
	 * @param	delete
	 * @param	update
	 * @return
	 */
	public function fKey(table:String, reference:String, ?key:String, ?target:String, ?field:String, ?delete:String = 'RESTRICT', ?update:String = 'RESTRICT'):ICommand {
		if (key == null){
			return _gate.prepare("ALTER TABLE " + table + " DROP FOREIGN KEY " + reference);
		}else{
			return _gate.prepare("ALTER TABLE " + table + " ADD CONSTRAINT " + reference + " FOREIGN KEY (" + key + ") REFERENCES " + target + "(" + field + ") ON DELETE " + delete.toUpperCase() + " ON UPDATE " + update.toUpperCase() + ";");
		}
	}

	/**
	 *
	 * @param	table
	 * @param	clause
	 * @return
	 */
	public function join(table:Dynamic, ?clause:Dynamic):String {
		return 'JOIN ' + (Std.isOfType(table, DataTable) ? table.name : table) + ' ON ' + _conditions(clause , [], " OR ", true);
	}

	/**
	 *
	 * @param	table
	 * @param	clause
	 * @return
	 */
	public function innerJoin(table:Dynamic, ?clause:Dynamic):String {
		return 'INNER ' + join(table, clause);
	}

	/**
	 *
	 * @param	table
	 * @param	clause
	 * @return
	 */
	public function outerJoin(table:Dynamic, ?clause:Dynamic):String {
		return 'OUTER ' + join(table, clause);
	}

	/**
	 *
	 * @param	table
	 * @param	clause
	 * @return
	 */
	public function leftJoin(table:Dynamic, ?clause:Dynamic):String {
		return 'LEFT ' + join(table, clause);
	}

	/**
	 *
	 * @param	table
	 * @param	clause
	 * @return
	 */
	public function leftOuterJoin(table:Dynamic, ?clause:Dynamic):String {
		return 'LEFT ' + outerJoin(table, clause);
	}

	/**
	 *
	 * @param	table
	 * @param	clause
	 * @return
	 */
	public function rightOuterJoin(table:Dynamic, ?clause:Dynamic):String {
		return 'RIGHT ' + outerJoin(table, clause);
	}

	/**
	 *
	 * @param	table
	 * @param	clause
	 * @return
	 */
	public function fullOuterJoin(table:Dynamic, ?clause:Dynamic):String {
		return 'FULL ' + outerJoin(table, clause);
	}

}
