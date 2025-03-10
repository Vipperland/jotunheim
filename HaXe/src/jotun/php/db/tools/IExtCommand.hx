package jotun.php.db.tools;
import jotun.errors.ErrorDescriptior;
import jotun.php.db.pdo.Statement;

/**
 * @author Rafael Moreira
 */

interface IExtCommand {

	/**
	 * An Array of all returned data
	 */
	public var result:Array<Dynamic>;
	
	/**
	 * Execute the command
	 * @param	handler
	 * @param	type
	 * @param	parameters
	 * @return
	 */
	public function execute (?handler:Dynamic->Bool, ?type:Dynamic, ?parameters:Array<Dynamic>, ?contruct:Array<Dynamic>) : IExtCommand;
	
	/**
	 * Shortcut only, Similar to Dice.Values(command.result, handler)
	 * @param	handler
	 * @return
	 */
	public function fetch (handler:Dynamic->Bool) : IExtCommand;
	
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
	
	
}