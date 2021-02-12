package jotun.php.db.tools;
import jotun.data.IDataSet;
import jotun.php.db.pdo.Statement;
import jotun.errors.IError;

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
	 * Running error on query
	 */
	public var errors(get, null):Array<IError>;
	
	/**
	 * Flush arguments to query
	 * @param	arguments
	 * @return
	 */
	public function bind (arguments:Array<Dynamic>) : ICommand;
	
	/**
	 * Execute the command
	 * @param	handler
	 * @param	type
	 * @param	parameters
	 * @return
	 */
	public function execute (?handler:IDataSet->Bool, ?type:Dynamic, ?parameters:Array<Dynamic>) : ICommand;
	
	/**
	 * The final value of the query
	 */
	public function log():String;
	
	/**
	 * The base value of the query
	 * @return
	 */
	public function query():String;
	
}