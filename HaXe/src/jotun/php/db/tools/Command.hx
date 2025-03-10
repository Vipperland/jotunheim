package jotun.php.db.tools;
import haxe.Json;
import jotun.php.db.tools.CommandCore;
import php.Lib;
import php.NativeArray;
import jotun.php.db.pdo.Statement;
import jotun.errors.Error;
import jotun.errors.ErrorDescriptior;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Command extends CommandCore implements ICommand {
	
	public function execute(?handler:Dynamic->Bool, ?type:Dynamic, ?parameters:Array<Dynamic>):ICommand {
		if (statement != null){
			var p:NativeArray = null;
			if (parameters != null)	{
				p = Lib.toPhpArray(parameters);
			}
			try {
				success = statement.execute(p);
				if (!success) {
					errors[errors.length] = new Error(statement.errorCode(), Lib.toHaxeArray(statement.errorInfo()));
				}
				this.statement = null;
			}catch (e:Dynamic) {
				if (Std.isOfType(e, String)) {
					errors[errors.length] = new Error(0, e);
				}else {
					errors[errors.length] = new Error(e.getCode(), e.getMessage());
				}
			}
			if (_log != null) {
				_log((success ? "[1]" : "[0]") + " " + log());
			}
		}else {
			errors[errors.length] = new Error(0, "A connection with database is required.");
		}
		return this;
	}
	
}