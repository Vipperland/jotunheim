package sirius.db.tools;
import sirius.db.tools.ICommand;

/**
 * @author Rafael Moreira
 */

interface IQueryBuilder {
	
	public function add (table:String, ?clause:Dynamic, ?parameters:Dynamic, ?order:Dynamic, ?limit:String) : ICommand;

	public function find (fields:Dynamic, table:String, ?clause:Dynamic, ?order:Dynamic, ?limit:String) : ICommand;

	public function update (table:String, ?clause:Dynamic, ?parameters:Dynamic, ?order:Dynamic, ?limit:String) : ICommand;

	public function delete (table:String, ?clause:Dynamic, ?order:Dynamic, ?limit:String) : ICommand;
	
	public function copy(from:String, to:String, ?clause:Dynamic, ?parameters:Dynamic, ?limit:String):ICommand;

}
