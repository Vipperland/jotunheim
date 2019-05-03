package sirius.db.tools;
import sirius.data.IDataSet;
import sirius.db.pdo.Statement;
import sirius.errors.IError;

/**
 * @author Rafael Moreira
 */

interface ICommand {
	
	/**
	 * If command as succesfully executed
	 */
	public var success : Bool;
	
	/**
	 * The PDO statement
	 */
	public var statement : Statement;
	
	/**
	 * An Array of all returned data
	 */
	public var result : Array<Dynamic>;
	
	/**
	 * Running error on query
	 */
	public var errors(get, null):Array<IError>;
	
	/**
	 * Flush arguments to query
	 * @param	arguments
	 * @return
	 */
	public function bind (arguments:Dynamic) : ICommand;
	
	/**
	 * Execute the command
	 * @param	handler
	 * @param	type
	 * @param	parameters
	 * @return
	 */
	public function execute (?handler:IDataSet->Bool, ?type:Dynamic, ?parameters:Array<Dynamic>) : ICommand;
	
	/**
	 * Dump the final query
	 */
	public function log():String;
	
}