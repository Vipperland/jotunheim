package jotun.php.db.objects;
import jotun.php.db.objects.IDataTable;
import jotun.php.db.tools.ICommand;

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
	public function getAutoIncrement():Int;
	
	/**
	 * All table fields description
	 */
	public function getInfo():Dynamic;
	
	/**
	 * Default Constructor Object for SELECT
	 * @param	value
	 * @return
	 */
	public function setClassObj(value:Dynamic):IDataTable;
	
	/**
	 * Insert a new object
	 * @param	parameters
	 * @return
	 */
	public function add (?parameters:Dynamic = null) : IQuery;
	
	/**
	   Insert multiples objects
	   @param	parameters
	   @return
	**/
	public function addAll (?parameters:Dynamic = null) : Array<IQuery>;

	/**
	 * Select all entries
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function find (?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : IExtQuery;
	
	/**
	 * Select a single entry
	 * @param	clause
	 * @return
	 */
	public function findOne (?clause:Dynamic=null, ?order:Dynamic = null) : Dynamic;
	
	/**
	 * Update a entry
	 * @param	parameters
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function update (?parameters:Dynamic = null, ?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : IQuery;
	
	/**
	 * Update ONE entry
	 * @param	parameters
	 * @param	clause
	 * @param	order
	 * @return
	 */
	public function updateOne (?parameters:Dynamic=null, ?clause:Dynamic=null, ?order:Dynamic=null) : IQuery;

	/**
	 * Delete an entry
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function delete (?clause:Dynamic = null, ?order:Dynamic = null, ?limit:String = null) : IQuery;
	
	/**
	 * Delete ONE entry
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function deleteOne (?clause:Dynamic = null, ?order:Dynamic = null) : IQuery;
	
	/**
	 * Copy entry to another table
	 * @param	toTable
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function copy (toTable:String, ?clause:Dynamic=null, ?order:Dynamic=null, ?limit:String=null) : IQuery;
	
	/**
	 * Copy ONE entry to another table
	 * @param	toTable
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 */
	public function copyOne (toTable:String, ?clause:Dynamic=null, ?order:Dynamic=null) : IQuery;
	
	/**
	   Run a custom query
	   @param	data
	   @param	params
	   @return
	**/
	public function query(data:String, ?params:Dynamic):IQuery;
	
	/**
	 * Erase all table entries (TRUNCATE)
	 * @return
	 */
	public function clear():IQuery;
	
	/**
	 * Sum field values and return its value
	 * @param	field
	 * @param	clausule
	 * @return
	 */
	public function sum(field:String, ?clausule:Dynamic = null):UInt;
	
	/**
	 * Validate parameters with table description and remove invalid ones
	 * @param	paramaters
	 * @return
	 */
	public function optimize(paramaters:Dynamic):Dynamic;
	
	
	public function link(id:String, key:String, table:String, field:String, ?del:String = 'RESTRICT', ?update:String = 'RESTRICT'):ICommand;
	
	
	public function unlink(id:String):ICommand;
	
	/**
	 * The ammount of rows in table
	 * @return
	 */
	public function length(?clause:Dynamic=null, ?limit:String=null):UInt;
	
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