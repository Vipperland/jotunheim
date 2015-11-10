package sirius.db;
import sirius.db.tools.ICommand;
import sirius.db.objects.IDataTable;
import sirius.db.Token;
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
	 * If the connection is available
	 * @return
	 */
	public function isOpen () : Bool;
	
	/**
	 * Open a connection
	 * @param	token
	 * @return
	 */
	public function open (token:Token) : IGate;
	
	/**
	 * The query to execute
	 * @param	query
	 * @param	parameters
	 * @param	options
	 * @return
	 */
	public function prepare (query:String, ?parameters:Dynamic = null, ?options:Dynamic = null) : ICommand;
	
	/**
	 * Show all fields of a table
	 * @param	table
	 * @return
	 */
	public function schemaOf (?table:Dynamic) : ICommand;
	
	/**
	 * Shotcut to table statements and methods
	 * @param	table
	 * @return
	 */
	public function getTable(table:String):IDataTable;
	
	/**
	 * Last row affected
	 * @return
	 */
	public function insertedId():UInt;
	
	
}