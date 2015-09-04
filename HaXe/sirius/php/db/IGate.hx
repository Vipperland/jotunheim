package sirius.php.db;
import sirius.data.IDataSet;
import sirius.errors.Error;
import sirius.php.db.ICommand;
import sirius.php.db.Token;

/**
 * @author Rafael Moreira
 */

interface IGate {
	
	/**
	 * Last created command
	 */
	public var command : ICommand;
	
	/**
	 * Connection and Execution Errors
	 */
	public var errors:Array<Error>;
	
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
	public function schemaOf (?table:Dynamic) : IDataSet;
	
	/**
	 * 
	 * @param	table
	 * @param	parameters
	 * @return
	 */
	public function insert(table:String, parameters:Dynamic, ?options:Dynamic = null):ICommand;
	
	
}