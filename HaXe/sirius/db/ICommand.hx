package sirius.db;
import sirius.db.pdo.Statement;

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
	 * Flush arguments to query
	 * @param	arguments
	 * @return
	 */
	public function bind (arguments:Dynamic) : ICommand;
	
	/**
	 * Execute the command
	 * @param	handler
	 * @param	type
	 * @param	queue
	 * @param	parameters
	 * @return
	 */
	public function execute (?handler:Dynamic, ?type:Int=2, ?queue:String=null, ?parameters:Array<Dynamic>) : ICommand;
	
	/**
	 * Shortcut only, Similar to Dice.Values(command.result, handler)
	 * @param	handler
	 * @return
	 */
	public function fetch (handler:Dynamic) : ICommand;
	
	/**
	 * Send fetched data to main result pool (Sirius.cache)
	 * @param	name
	 */
	public function queue (name:String) : Void;
	
	/**
	 * Dump the final query
	 */
	public function log():String;
	
}