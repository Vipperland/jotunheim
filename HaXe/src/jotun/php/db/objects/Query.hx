package jotun.php.db.objects;

/**
 * ...
 * @author Rafael Moreira
 */
class Query {
	
	public var success:Bool;
	
	public var table:DataTable;
	
	public function new(table:DataTable, success:Bool) {
		this.table = table;
		this.success = success;
	}
	
}