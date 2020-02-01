package jotun.php.db;
import jotun.php.db.Token;
import jotun.php.db.objects.IDataTable;
import jotun.php.db.tools.ICommand;
import jotun.php.db.tools.IExtCommand;
import jotun.php.db.tools.IQueryBuilder;
import jotun.errors.IError;

/**
 * @author Rafael Moreira
 */

interface IGate {
	
	/**
	 * Last created command
	 */
	public var command : ICommand;
	
	/**
	 * Fast bulk command
	 */
	public var builder : IQueryBuilder;
	
	/**
	 * Connection and Execution Errors
	 */
	public var errors(get, null):Array<IError>;
	
	/**
	 * Query runtime log
	 */
	public var log(get, null):Array<String>;
	
	/**
	 * If the connection is available
	 * @return
	 */
	public function isOpen () : Bool;
	
	/**
	   Name of Selected database
	   @return
	**/
	public function getName():String;
	
	/**
	 * Open a connection
	 * @param	token
	 * @return
	 */
	public function open (token:Token, log:Bool = false) : IGate;
	
	/**
	 * The query to execute
	 * @param	query
	 * @param	parameters
	 * @param	object
	 * @param	options
	 * @return
	 */
	public function prepare(query:String, ?parameters:Dynamic = null, ?options:Dynamic = null):ICommand;
	
	/**
	 * 
	 * @param	query
	 * @param	parameters
	 * @return
	 */
	public function query(query:String, ?parameters:Dynamic = null):IExtCommand;
	
	/**
	 * Show all fields of a table
	 * @param	table
	 * @return
	 */
	public function schema (?table:Dynamic) : Array<Dynamic>;
	
	/**
	 * Shotcut to table statements and methods
	 * @param	table
	 * @return
	 */
	public function table (table:String):IDataTable;
	
	/**
	 * Enable/Disable INT to String conversions
	 * @param	value
	 * @return
	 */
	public function setPdoAttributes(value:Bool):IGate;
	
	/**
	   LAst inserted column value
	   @param	field
	   @param	mode
	   @return
	**/
	public function getInsertedID(?field:String, ?mode:String):Dynamic;
	
	/**
	 * Verify if table exists
	 * @param	table
	 * @return
	 */
	public function ifTableExists(table:String):Bool;
	
	/**
	   Get name of all tables in the selected database
	   @return
	**/
	public function getTableNames():Array<String>;
	
	/**
	   Get all DataTable objects from the selected database
	   @return
	**/
	public function getTables():Dynamic;
	
}