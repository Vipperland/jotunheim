package sirius.db.objects;
import sirius.db.objects.IDataTable;

/**
 * @author Rafael Moreira
 */

interface IDataTable {
  
	/**
	 * Table Name
	 */
	public var name(get_name, null):String;
	
	/**
	 * All table fields description
	 */
	public var description(get_description, null):Dynamic;
	
	/**
	 * Insert a new entry
	 * @param	parameters
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function add (?parameters:Dynamic=null, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQueryResult;

	/**
	 * Select all entries
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function findAll (?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : IQueryResult;
	
	/**
	 * Select a single entry
	 * @param	clause
	 * @return
	 */
	public function findOne (?clause:Dynamic=null) : Dynamic;
	
	/**
	 * Update a entry
	 * @param	parameters
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function update (?parameters:Dynamic=null, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQueryResult;

	/**
	 * Delete an entry
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function delete (?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : IQueryResult;
	
	/**
	 * Copy entry to another table
	 * @param	toTable
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function copy (toTable:String, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQueryResult;
	
	/**
	 * Validate parameters with table description and remove invalid ones
	 * @param	paramaters
	 * @return
	 */
	public function clear(paramaters:Dynamic):Dynamic;
	
	/**
	 * Restrict the field selection of find command
	 * @param	fields
	 * @return
	 */
	public function restrict(fields:Dynamic):IDataTable;
	
}