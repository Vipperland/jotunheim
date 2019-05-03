package sirius.db.tools;
import sirius.data.IDataSet;

/**
 * @author Rafael Moreira
 */

interface IExtCommand extends ICommand {
	
	/**
	 * Execute the command
	 * @param	handler
	 * @param	type
	 * @param	parameters
	 * @return
	 */
	public function execute (?handler:IDataSet->Bool, ?type:Dynamic, ?parameters:Array<Dynamic>) : IExtCommand;
	
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
	
}