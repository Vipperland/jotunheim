package sirius.db.objects;
import sirius.db.tools.ICommand;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class DataTable implements IDataTable {
	
	private var _name:String;
	
	private var _gate:IGate;
	
	private var _description:Dynamic;
	var _fields:Dynamic;
	
	public var description(get, null):Array<Dynamic>;
	private function get_description():Array<Dynamic> {
		if (_description == null) {
			_description = { };
			var r:Array<Dynamic> = _gate.schemaOf(_name).execute().result;
			Dice.Values(r, function(v:Dynamic) { Reflect.setField(_description, v.COLUMN_NAME, new Column(v)); });
		}
		return _description;
	}
	
	public var name(get, null):String;
	private function get_name():String { return _name; }

	public function new(name:String, gate:IGate) {
		_gate = gate;
		_name = name;
		_fields = "*";
	}
	
	public function restrict(fields:Dynamic):IDataTable {
		_fields = fields;
		return this;
	}
	
	public function create (?clausule:Dynamic = null, ?parameters:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : Array<Dynamic> {
		return _gate.builder.create(_name, clausule, parameters, order, limit).execute().result;
	}

	public function find (?clausule:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : Array<Dynamic> {
		return _gate.builder.find(_fields, _name, clausule, order, limit).execute().result;
	}

	public function update (?clausule:Dynamic=null, ?parameters:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : Array<Dynamic> {
		return _gate.builder.update(_name, clausule, parameters, order, limit).execute().result;
	}

	public function delete (?clausule:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : Array<Dynamic> {
		return _gate.builder.delete(_name, clausule, order, limit).execute().result;
	}
	
	public function getErrors():Dynamic {
		return _gate.errors;
	}
	
}