package sirius.php.db;
import sirius.data.DataSet;
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
	public function fields (table:Dynamic) : DataSet;
	
}