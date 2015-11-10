package sirius.db.objects;
import sirius.db.objects.IDataTable;

/**
 * @author Rafael Moreira
 */

interface IDataTable {
  
	public var name(get_name, null):String;
	
	public var description(get_description, null):Array<Dynamic>;
	
	public function create (?clausule:Dynamic=null, ?parameters:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : Array<Dynamic>;

	public function find (?clausule:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : Array<Dynamic>;

	public function update (?clausule:Dynamic=null, ?parameters:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : Array<Dynamic>;

	public function delete (?clausule:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : Array<Dynamic>;
	
	public function restrict(fields:Dynamic):IDataTable;
	
}