package sirius.db;
import sirius.db.tools.ICommand;
import sirius.db.objects.IDataTable;
import sirius.db.Token;
import sirius.db.tools.IExtCommand;
import sirius.db.tools.IQueryBuilder;
import sirius.errors.IError;

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
	public function schema (?table:Dynamic) : ICommand;
	
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
	 * Last row affected
	 * @return
	 */
	public function insertedId ():UInt;
	
	/**
	 * Verify if table exists
	 * @param	table
	 * @return
	 */
	public function ifTableExists(table:String):Bool;
	
	
}