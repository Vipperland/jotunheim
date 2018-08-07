package sirius.db.tools;
import php.NativeArray;
import sirius.data.DataSet;
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
	public function execute (?handler:IDataSet->Bool, ?type:Int=2, ?parameters:Array<Dynamic>) : ICommand;
	
	/**
	 * Shortcut only, Similar to Dice.Values(command.result, handler)
	 * @param	handler
	 * @return
	 */
	public function fetch (handler:IDataSet->Bool) : ICommand;
	
	/**
	 * Count result length by COUNT(*) property or result length
	 * @return
	 */
	public function length(?prop:String):UInt;
	
	/**
	 * Find params equal one or more value
	 * @param	params
	 * @param	values
	 * @param	limit
	 * @return
	 */
	public function find(param:String, values:Array<Dynamic>, ?limit:UInt = 0):Array<Dynamic>;
	
	/**
	 * Dump the final query
	 */
	public function log():String;
	
}