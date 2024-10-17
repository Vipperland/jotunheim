package jotun.php.db.objects;
import jotun.php.db.objects.ExtQuery;
import jotun.php.db.tools.ICommand;
import jotun.php.db.tools.IExtCommand;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.utils.Filler;

/**
 * ...
 * @author Rafael Moreira
 */
class DataTable {
	
	/**
	 * Table Name
	 */
	private var _name:String;
	
	private var _gate:Gate;
	
	private var _fields:Dynamic;
	
	private var _class:Dynamic;
	
	private var _info:Dynamic;
	
	private var _restrict:UInt;
	
	private function _checkRestriction(?fields:Dynamic):Dynamic {
		if(fields == null){
			fields = _fields;
			if (_restrict > 0 && --_restrict == 0) unrestrict();
		}
		return fields;
	}
	
	private function _join(?clause:Dynamic):String {
		return Jotun.gate.builder.join(_name, clause);
	}
	
	/**
	 * All table fields description
	 */
	public function getInfo():Dynamic {
		if (_info == null) {
			_info = { };
			var r:Array<Dynamic> = _gate.schema(_name);
			Dice.Values(r, function(v:Dynamic) { Reflect.setField(_info, v.COLUMN_NAME, new Column(v)); });
		}
		return _info;
	}
	
	public var name(get, null):String;
	private function get_name():String { return _name; }
	
	/**
	 * Current AUTO_INCREMENT value for table
	 */
	public function getAutoIncrement():Int {
		var cmd:IExtCommand = _gate.builder.find('AUTO_INCREMENT', 'INFORMATION_SCHEMA.TABLES', Clause.AND([
				Clause.EQUAL('TABLE_SCHEMA', _gate.getName()), 
				Clause.EQUAL('TABLE_NAME', _name)
			]), null, Limit.MAX(1)).execute();
		return (cmd.result != null && cmd.result.length > 0) ? Std.parseInt(cmd.result[0].AUTO_INCREMENT) : 0;
	}

	public function new(name:String, gate:Gate) {
		_gate = gate;
		_name = name;
		_fields = "*";
		_restrict = 0;
	}
	
	/**
	 * If has a class definition for fetch
	 * @return
	 */
	public function hasClassObj(Def:Dynamic):Bool {
		return _class != null && (!Def || Def == _class);
	}
	
	/**
	 * Default Constructor Object for SELECT
	 * @param	value
	 * @return
	 */
	public function setClassObj(value:Dynamic):DataTable {
		if (_class != value){
			_class = value;
		}
		return this;
	}
	
	/**
	 * Restrict the field selection of find command
	 * @param	fields
	 * @return
	 */
	public function restrict(fields:Dynamic, ?times:UInt = 0):DataTable {
		_restrict = times;
		_fields = fields;
		return this;
	}
	
	/**
	 * Unrestrict all fields for find command
	 * @return
	 */
	public function unrestrict():DataTable {
		_fields = "*";
		return this;
	}
	
	/**
	   Insert multiples objects
	   @param	parameters
	   @return
	**/
	public function addAll(?parameters:Dynamic = null) : Array<Query> {
		var r:Array<Query> = [];
		Dice.All(parameters, function(p:String, v:Dynamic):Void {
			r[r.length] = add(v);
		});
		return r;
	}

	/**
	 * Insert a new object
	 * @param	parameters
	 * @return
	 */
	public function add (?parameters:Dynamic = null) : Query {
		return new Query(this, _gate.builder.add(_name, parameters).execute().success);
	}

	/**
	 * Select all entries
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function find (?fields:Dynamic, ?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : ExtQuery {
		return new ExtQuery(this, _gate.builder.find(_checkRestriction(fields), _name, clause, order, limit).execute(null, _class).result);
	}

	/**
	 * 
	 * @param	tables
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function findJoin(?fields:Dynamic, tables:Dynamic, ?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : ExtQuery {
		if (!Std.isOfType(tables, Array)){
			tables = [tables];
		}
		tables.unshift(_name);
		return new ExtQuery(this, _gate.builder.find(_checkRestriction(fields), tables, clause, order, limit).execute(null, _class).result);
	}

	/**
	 * Select a single entry
	 * @param	clause
	 * @return
	 */
	public function findOne (?fields:Dynamic, ?clause:Dynamic=null, ?order:Dynamic = null) : Dynamic {
		return find(fields, clause, order, Limit.ONE).first();
	}

	/**
	 * 
	 * @param	tables
	 * @param	clause
	 * @param	order
	 * @return
	 */
	public function findOneJoin (?fields:Dynamic, tables:Dynamic, ?clause:Dynamic=null, ?order:Dynamic = null) : Dynamic {
		return findJoin(fields, tables, clause, order, Limit.ONE).first();
	}

	/**
	 * Update a entry
	 * @param	parameters
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function update (?parameters:Dynamic=null, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : Query {
		return new Query(this, _gate.builder.update(_name, clause, parameters, order, limit).execute().success);
	}

	/**
	 * Update ONE entry
	 * @param	parameters
	 * @param	clause
	 * @param	order
	 * @return
	 */
	public function updateOne (?parameters:Dynamic=null, ?clause:Dynamic=null, ?order:Dynamic=null) : Query {
		return new Query(this, _gate.builder.update(_name, clause, parameters, order, Limit.ONE).execute().success);
	}
	/**
	 * Delete an entry
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */

	public function delete (?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : Query {
		return new Query(this, _gate.builder.delete(_name, clause, order, limit).execute().success);
	}
	
	/**
	 * Delete ONE entry
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function deleteOne (?clause:Dynamic=null, ?order:Dynamic=null) : Query {
		return new Query(this, _gate.builder.delete(_name, clause, order, Limit.ONE).execute().success);
	}
	
	/**
	 * Copy entry to another table
	 * @param	toTable
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function copy (toTable:String, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : ExtQuery {
		return new ExtQuery(this, _gate.builder.copy(_name, toTable, clause, order, limit));
	}
	
	/**
	 * Copy ONE entry to another table
	 * @param	toTable
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function copyOne (toTable:String, ?clause:Dynamic=null, ?order:Dynamic=null) : ExtQuery {
		return new ExtQuery(this, _gate.builder.copy(_name, toTable, clause, order, Limit.ONE)[0]);
	}
	
	/**
	   Run a custom query
	   @param	data
	   @param	params
	   @return
	**/
	public function query(data:String, ?params:Dynamic):Query {
		data = Filler.to(data, {table :_name});
		var iof:Int = data.indexOf('SELECT');
		if (iof != -1 && iof < 6 && data.indexOf('FROM', iof+1) != -1){
			return new ExtQuery(this, _gate.query(data, params).execute().result);
		}else{
			return new Query(this, _gate.prepare(data, params).execute().success);
		}
	}
	
	/**
	 * Erase all table entries (TRUNCATE)
	 * @return
	 */
	public function clear():Query {
		return new Query(this, _gate.builder.truncate(_name).success);
	}
	
	/**
	 * 
	 * @param	to
	 * @return
	 */
	public function rename(to:String):Query {
		var old:String = _name;
		_name = to;
		return new Query(this, _gate.builder.rename(old, to).success);
	}
	
	/**
	 * The ammount of rows in table
	 * @return
	 */
	public function length(?clause:Dynamic=null, ?limit:String=null):UInt {
		return cast _gate.builder.find('COUNT(*)', _name, clause, null, limit).execute().length();
	}
	
	public function exists(?clause:Dynamic=null):Bool {
		return length(clause, Limit.ONE) > 0;
	}
	
	/**
	 * Sum field values and return its value
	 * @param	field
	 * @param	clausule
	 * @return
	 */
	public function sum(field:String, ?clause:Dynamic = null):UInt {
		var command:IExtCommand = _gate.builder.find('SUM(' + field + ') as _SumResult_', _name, clause, null, null).execute();
		return Utils.getValidOne(command.result.length > 0 ? Std.parseInt(Reflect.field(command.result[0], '_SumResult_')) : 0, 0);
	}
	
	/**
	 * Validate parameters with table description and remove invalid ones
	 * @param	paramaters
	 * @return
	 */
	public function optimize(paramaters:Dynamic):Dynamic {
		var desc:Dynamic = getInfo();
		Dice.All(paramaters, function(p:String, v:Dynamic):Void {
			if (!Reflect.hasField(desc, p)){
				Reflect.deleteField(paramaters, p);
			}
		});
		return paramaters;
	}
	
	/**
	 * 
	 * @param	clause
	 * @return
	 */
	public function leftJoin(?clause:Dynamic):String {
		return 'LEFT ' + _join(clause);
	}
	
	/**
	 * 
	 * @param	clause
	 * @return
	 */
	public function outerJoin(?clause:Dynamic):String {
		return 'OUTER ' + _join(clause);
	}
	
	/**
	 * 
	 * @param	clause
	 * @return
	 */
	public function leftOuterJoin(?clause:Dynamic):String {
		return 'LEFT ' + outerJoin(clause);
	}
	
	/**
	 * 
	 * @param	clause
	 * @return
	 */
	public function rightOuterJoin(?clause:Dynamic):String {
		return 'RIGHT ' + outerJoin(clause);
	}
	
	/**
	 * 
	 * @param	clause
	 * @return
	 */
	public function fullOuterJoin(?clause:Dynamic):String {
		return 'FULL ' + outerJoin(clause);
	}
	
	/**
	 * 
	 * @param	id
	 * @param	key
	 * @param	table
	 * @param	field
	 * @param	del
	 * @param	update
	 * @return
	 */
	public function link(id:String, key:String, table:String, field:String, ?del:String='RESTRICT', ?update:String='RESTRICT'):ICommand {
		return _gate.builder.fKey(_name, id, key, table, field, del, update).execute();
	}
	
	/**
	 * 
	 * @param	id
	 * @return
	 */
	public function unlink(id:String):ICommand {
		return _gate.builder.fKey(_name, id).execute();
	}
	
	/**
	 * If table as a specified column name
	 * @param	name
	 * @return
	 */
	public function hasColumn(name:String):Bool {
		return Reflect.hasField(getInfo(), name);
	}
	
	public function getColumn(name:String):Column {
		return hasColumn(name)
					? Reflect.field(getInfo(), name)
					: null;
	}
	
	/**
	 * Get table column data erference
	 * @param	name
	 * @return
	 */
	public function getErrors():Dynamic {
		return _gate.errors;
	}
	
}