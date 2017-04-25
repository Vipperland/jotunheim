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
	 * Current AUTO_INCREMENT value for table
	 */
	public var autoIncrement(get, null):UInt;
	
	/**
	 * All table fields description
	 */
	public var description(get_description, null):Dynamic;
	
	/**
	 * Create a TableObject and return itself
	 * @param	data
	 * @return
	 */
	public function create(data:Dynamic):ITableObject;
	
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
	 * Erase all table entries (TRUNCATE)
	 * @return
	 */
	public function clear():IQueryResult;
	
	/**
	 * Validate parameters with table description and remove invalid ones
	 * @param	paramaters
	 * @return
	 */
	public function optimize(paramaters:Dynamic):Dynamic;
	
	/**
	 * The ammount of rows in table
	 * @return
	 */
	public function length(?clause:Dynamic=null):UInt;
	
	/**
	 * Restrict the field selection of find command
	 * @param	fields
	 * @return
	 */
	public function restrict(fields:Dynamic, ?times:UInt = 0):IDataTable;
	
	/**
	 * Unrestrict all fields for find command
	 * @return
	 */
	public function unrestrict():IDataTable;
	
	/**
	 * If table as a specified column name
	 * @param	name
	 * @return
	 */
	public function hasColumn(name:String):Bool;
	
	/**
	 * Get table column data erference
	 * @param	name
	 * @return
	 */
	public function getColumn(name:String):Column;
	
}