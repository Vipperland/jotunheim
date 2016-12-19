package sirius.db.objects;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class TableObject {
	
	public static var PROPERTIES:Array<String> = ['id', 'updated_at', 'created_at'];
	
	public static var OPT_PROPERTIES:Array<String> = [];
	
	public static function GetProperties():Array<String> { return untyped __php__("STATIC::$PROPERTIES"); }
	
	var _table:IDataTable;

	public var id(get, null):UInt;
	public function get_id():UInt {	return data.id; }
	
	public var data:Dynamic;
	
	public function new(table:IDataTable, ?data:Dynamic) {
		_table = table;
		if (data != null) this.data = data;
	}
	
	public function create(data:Dynamic):TableObject {
		data.created_at = Sirius.tick;
		data.updated_at = Sirius.tick;
		_table.add(data);
		this.data = data;
		data.id = Sirius.gate.insertedId();
		return this;
	}
	
	public function update(data:Dynamic):Void {
		_table.update(data, Clause.ID(id), null, Limit.ONE);
	}
	
	public function copy():TableObject {
		var obj:TableObject = new TableObject(_table);
		return obj.create(untyped __call__('clone', data));
	}
	
	public function delete():Void {
		_table.delete(Clause.ID(id), null, Limit.ONE);
		_table = null;
		data = null;
	}
	
}