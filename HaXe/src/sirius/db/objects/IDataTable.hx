package sirius.db.objects;
import sirius.db.objects.IDataTable;

/**
 * @author Rafael Moreira
 */

interface IDataTable {
  
	public var name(get_name, null):String;
	
	public var description(get_description, null):Dynamic;
	
	public function create (?parameters:Dynamic=null, ?clausule:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQueryResult;

	public function findAll (?clausule:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : IQueryResult;
	
	public function findOne (?clausule:Dynamic=null) : Dynamic;

	public function update (?parameters:Dynamic=null, ?clausule:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQueryResult;

	public function delete (?clausule:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQueryResult;
	
	public function restrict(fields:Dynamic):IDataTable;
	
}