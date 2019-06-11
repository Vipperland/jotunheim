package jotun.db.objects;

/**
 * ...
 * @author Rafael Moreira
 */
class Query implements IQuery {
	
	public var success:Bool;
	
	public var table:IDataTable;
	
	public function new(table:IDataTable, success:Bool) {
		this.table = table;
		this.success = success;
	}
	
}