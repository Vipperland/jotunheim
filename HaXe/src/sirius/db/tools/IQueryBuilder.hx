package sirius.db.tools;
import sirius.db.tools.ICommand;

/**
 * @author Rafael Moreira
 */

interface IQueryBuilder {
	
	public function create (table:String, ?clausule:Dynamic=null, ?parameters:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : ICommand;

	public function find (fields:Dynamic, table:String, ?clausule:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : ICommand;

	public function update (table:String, ?clausule:Dynamic=null, ?parameters:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : ICommand;

	public function delete (table:String, ?clausule:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : ICommand;

}
