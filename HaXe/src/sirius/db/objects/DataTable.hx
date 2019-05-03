package sirius.db.objects;
import php.Lib;
import sirius.db.tools.ICommand;
import sirius.db.tools.IExtCommand;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class DataTable implements IDataTable {
	
	private var _name:String;
	
	private var _gate:IGate;
	
	private var _description:Dynamic;
	
	private var _fields:Dynamic;
	
	private var _class:Dynamic;
	
	private var _restrict:UInt;
	
	private function _checkRestriction():Dynamic {
		var r:Dynamic = _fields;
		if (_restrict > 0 && --_restrict == 0) unrestrict();
		return r;
	}
	
	public var description(get, null):Dynamic;
	private function get_description():Dynamic {
		if (_description == null) {
			_description = { };
			var r:Array<Dynamic> = _gate.schema(_name).execute().result;
			Dice.Values(r, function(v:Dynamic) { Reflect.setField(_description, v.COLUMN_NAME, new Column(v)); });
		}
		return _description;
	}
	
	public var name(get, null):String;
	private function get_name():String { return _name; }
	
	public var autoIncrement(get, null):UInt;
	private function get_autoIncrement():UInt {
		var cmd:ICommand = _gate.builder.find('AUTO_INCREMENT', 'INFORMATION_SCHEMA.TABLES', Clause.EQUAL('TABLE_NAME', _name));
		return cmd.result.length > 0 ? Std.parseInt(cmd.result[0].AUTO_INCREMENT) : 0;
	}

	public function new(name:String, gate:IGate) {
		_gate = gate;
		_name = name;
		_fields = "*";
		_restrict = 0;
	}
	
	public function setClassObj(value:Dynamic):IDataTable {
		_class = value;
		return this;
	}
	
	public function restrict(fields:Dynamic, ?times:UInt = 0):IDataTable {
		_restrict = times;
		_fields = fields;
		return this;
	}
	
	public function unrestrict():IDataTable {
		_fields = "*";
		return this;
	}
	
	public function addAll (?parameters:Dynamic = null, ?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : Array<IQueryResult> {
		var r:Array<IQueryResult> = [];
		Dice.All(parameters, function(v:Dynamic){
			r[r.length] = add(parameters, clause, order, limit);
		});
		return r;
	}

	public function add (?parameters:Dynamic = null, ?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : IQueryResult {
		return new QueryResult(this, _gate.builder.add(_name, clause, parameters, order, limit).execute().result);
	}

	public function findAll (?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : IQueryResult {
		return new QueryResult(this, _gate.builder.find(_checkRestriction(), _name, clause, order, limit).execute(null, _class).result);
	}

	public function findOne (?clause:Dynamic=null, ?order:Dynamic = null) : Dynamic {
		return new QueryResult(this, _gate.builder.find(_checkRestriction(), _name, clause, order, Limit.ONE).execute(null, _class).result).first();
	}

	public function update (?parameters:Dynamic=null, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQueryResult {
		return new QueryResult(this, _gate.builder.update(_name, clause, parameters, order, limit).execute().result);
	}

	public function updateOne (?parameters:Dynamic=null, ?clause:Dynamic=null, ?order:Dynamic=null) : IQueryResult {
		return new QueryResult(this, _gate.builder.update(_name, clause, parameters, order, Limit.ONE).execute().result);
	}

	public function delete (?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQueryResult {
		return new QueryResult(this, _gate.builder.delete(_name, clause, order, limit).execute().result);
	}
	
	public function deleteOne (?clause:Dynamic=null, ?order:Dynamic=null) : IQueryResult {
		return new QueryResult(this, _gate.builder.delete(_name, clause, order, Limit.ONE).execute().result);
	}
	
	public function copy (toTable:String, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQueryResult {
		return new QueryResult(this, _gate.builder.copy(_name, toTable, clause, order, limit).execute().result);
	}
	
	public function copyOne (toTable:String, ?clause:Dynamic=null, ?order:Dynamic=null) : IQueryResult {
		return new QueryResult(this, _gate.builder.copy(_name, toTable, clause, order, Limit.ONE).execute().result);
	}
	
	public function clear():IQueryResult {
		return new QueryResult(this, _gate.builder.truncate(_name).result);
	}
	
	public function rename(to:String):IQueryResult {
		var old:String = _name;
		_name = to;
		return new QueryResult(this, _gate.builder.rename(old, to).result);
	}
	
	public function length(?clause:Dynamic=null, ?limit:String=null):UInt {
		return cast _gate.builder.find('COUNT(*)', _name, clause, null, limit).execute().length();
	}
	
	public function exists(?clause:Dynamic=null):Bool {
		return length(clause, Limit.ONE) > 0;
	}
	
	public function sum(field:String, ?clause:Dynamic = null):UInt {
		var command:ICommand = _gate.builder.find('SUM(' + field + ') as _SumResult_', _name, clause, null, null).execute();
		return Utils.getValidOne(command.result.length > 0 ? Std.parseInt(Reflect.field(command.result[0], '_SumResult_')) : 0, 0);
	}
	
	public function optimize(paramaters:Dynamic):Dynamic {
		var desc:Dynamic = get_description();
		Dice.All(paramaters, function(p:String, v:Dynamic) { if (!Reflect.hasField(desc, p)) Reflect.deleteField(paramaters, p); });
		return paramaters;
	}
	
	
	public function link(id:String, key:String, table:String, field:String, ?del:String='RESTRICT', ?update:String='RESTRICT'):ICommand {
		return _gate.builder.fKey(_name, id, key, table, field, del, update).execute();
	}
	
	public function unlink(id:String):ICommand {
		return _gate.builder.fKey(_name, id).execute();
	}
	
	
	public function hasColumn(name:String):Bool {
		var d:Dynamic = description;
		return Reflect.hasField(d, name);
	}
	
	public function getColumn(name:String):Column {
		return hasColumn(name)
					? Reflect.field(_description, name)
					: null;
	}
	
	public function getErrors():Dynamic {
		return _gate.errors;
	}
	
}