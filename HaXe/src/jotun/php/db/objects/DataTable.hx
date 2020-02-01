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
class DataTable implements IDataTable {
	
	private var _name:String;
	
	private var _gate:IGate;
	
	private var _fields:Dynamic;
	
	private var _class:Dynamic;
	
	private var _info:Dynamic;
	
	private var _restrict:UInt;
	
	private function _checkRestriction():Dynamic {
		var r:Dynamic = _fields;
		if (_restrict > 0 && --_restrict == 0) unrestrict();
		return r;
	}
	
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
	
	public function getAutoIncrement():Int {
		var cmd:IExtCommand = _gate.builder.find('AUTO_INCREMENT', 'INFORMATION_SCHEMA.TABLES', Clause.AND([
				Clause.EQUAL('TABLE_SCHEMA', _gate.getName()), 
				Clause.EQUAL('TABLE_NAME', _name)
			]), null, Limit.MAX(1)).execute();
		return (cmd.result != null && cmd.result.length > 0) ? Std.parseInt(cmd.result[0].AUTO_INCREMENT) : 0;
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
	
	public function addAll (?parameters:Dynamic = null) : Array<IQuery> {
		var r:Array<IQuery> = [];
		Dice.All(parameters, function(v:Dynamic){
			r[r.length] = add(parameters);
		});
		return r;
	}

	public function add (?parameters:Dynamic = null) : IQuery {
		return new Query(this, _gate.builder.add(_name, parameters).execute().success);
	}

	public function find (?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : IExtQuery {
		return new ExtQuery(this, _gate.builder.find(_checkRestriction(), _name, clause, order, limit).execute(null, _class).result);
	}

	public function findOne (?clause:Dynamic=null, ?order:Dynamic = null) : Dynamic {
		return new ExtQuery(this, _gate.builder.find(_checkRestriction(), _name, clause, order, Limit.ONE).execute(null, _class).result).first();
	}

	public function update (?parameters:Dynamic=null, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQuery {
		return new Query(this, _gate.builder.update(_name, clause, parameters, order, limit).execute().success);
	}

	public function updateOne (?parameters:Dynamic=null, ?clause:Dynamic=null, ?order:Dynamic=null) : IQuery {
		return new Query(this, _gate.builder.update(_name, clause, parameters, order, Limit.ONE).execute().success);
	}

	public function delete (?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQuery {
		return new Query(this, _gate.builder.delete(_name, clause, order, limit).execute().success);
	}
	
	public function deleteOne (?clause:Dynamic=null, ?order:Dynamic=null) : IQuery {
		return new Query(this, _gate.builder.delete(_name, clause, order, Limit.ONE).execute().success);
	}
	
	public function copy (toTable:String, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IExtQuery {
		return new ExtQuery(this, _gate.builder.copy(_name, toTable, clause, order, limit));
	}
	
	public function copyOne (toTable:String, ?clause:Dynamic=null, ?order:Dynamic=null) : IExtQuery {
		return new ExtQuery(this, _gate.builder.copy(_name, toTable, clause, order, Limit.ONE)[0]);
	}
	
	public function clear():IQuery {
		return new Query(this, _gate.builder.truncate(_name).success);
	}
	
	public function query(data:String, ?params:Dynamic):IQuery {
		data = Filler.to(data, {table :_name});
		var iof:Int = data.indexOf('SELECT');
		if (iof != -1 && iof < 6 && data.indexOf('FROM', iof+1) != -1){
			return new ExtQuery(this, _gate.query(data, params).execute().result);
		}else{
			return new Query(this, _gate.prepare(data, params).execute().success);
		}
	}
	
	public function rename(to:String):IQuery {
		var old:String = _name;
		_name = to;
		return new Query(this, _gate.builder.rename(old, to).success);
	}
	
	public function length(?clause:Dynamic=null, ?limit:String=null):UInt {
		return cast _gate.builder.find('COUNT(*)', _name, clause, null, limit).execute().length();
	}
	
	public function exists(?clause:Dynamic=null):Bool {
		return length(clause, Limit.ONE) > 0;
	}
	
	public function sum(field:String, ?clause:Dynamic = null):UInt {
		var command:IExtCommand = _gate.builder.find('SUM(' + field + ') as _SumResult_', _name, clause, null, null).execute();
		return Utils.getValidOne(command.result.length > 0 ? Std.parseInt(Reflect.field(command.result[0], '_SumResult_')) : 0, 0);
	}
	
	public function optimize(paramaters:Dynamic):Dynamic {
		var desc:Dynamic = getInfo();
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
		return Reflect.hasField(getInfo(), name);
	}
	
	public function getColumn(name:String):Column {
		return hasColumn(name)
					? Reflect.field(getInfo(), name)
					: null;
	}
	
	public function getErrors():Dynamic {
		return _gate.errors;
	}
	
}