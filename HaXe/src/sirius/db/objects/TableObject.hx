package sirius.db.objects;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class TableObject implements ITableObject {
	
	public static var PROPERTIES:Array<String> = ['id', 'updated_at', 'created_at'];
	
	public static function GetProperties():Array<String> { 
		return untyped __php__("STATIC::$PROPERTIES"); 
	}
	
	var _table:IDataTable;

	public var id(get, null):UInt;
	public function get_id():UInt {	return data != null ? data.id : null; }
	
	public var data:Dynamic;
	
	public function new(table:IDataTable, ?data:Dynamic) {
		_table = table;
		if (data != null) this.data = data;
	}
	
	public function create(data:Dynamic, ?verify:Bool = false):ITableObject {
		data.created_at = Sirius.tick;
		data.updated_at = Sirius.tick;
		if (verify) {
			_table.optimize(data);
		}
		_table.add(data);
		this.data = data;
		data.id = Sirius.gate.insertedId();
		return this;
	}
	
	public function update(data:Dynamic, ?verify:Bool = false):Void {
		data.updated_at = Sirius.tick;
		if (verify) {
			_table.optimize(data);
		}
		_table.update(data, Clause.ID(id), null, Limit.ONE);
	}
	
	public function copy():ITableObject {
		var obj:ITableObject = new TableObject(_table);
		var newdata:Dynamic = untyped __call__('clone', data);
		Reflect.deleteField(newdata, 'id');
		return obj.create(newdata);
	}
	
	public function delete():Void {
		_table.delete(Clause.ID(id), null, Limit.ONE);
		_table = null;
		data = null;
	}
	
}