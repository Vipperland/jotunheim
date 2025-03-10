package jotun.php.db.tools;
import jotun.php.db.pdo.Statement;
import jotun.errors.ErrorDescriptior;

/**
 * @author Rafael Moreira
 */

interface ICommand extends ICommandCore {
	
	public function execute (?handler:Dynamic->Bool, ?type:Dynamic, ?parameters:Array<Dynamic>) : ICommand;
	
}