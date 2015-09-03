package sirius.php.db;
import php.Lib;
import php.NativeArray;
import sirius.php.db.pdo.Statement;
import sirius.Sirius;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Command implements ICommand {
	
	// PDO::FETCH_ASSOC = 2
	// PDO::FETCH_OBJ = 5
	
	public var success:Bool;
	
	public var statement:Statement;
	
	public var result:Array<Dynamic>;

	public function new(statement:Statement, ?arguments:Dynamic) {
		this.statement = statement;
		if (arguments != null) bind(arguments);
	}
	
	public function bind(arguments:Dynamic):ICommand {
		var isArray:Bool = Std.is(arguments, Array);
		Dice.All(arguments, function(p:Dynamic, v:Dynamic) {
			if (isArray) {
				statement.setAttribute(p, v);
			}else {
				statement.bindValue(p, v);
			}
		});
		return this;
	}
	
	public function execute(?handler:Dynamic, ?type:Int = 2, ?queue:String = null, ?parameters:Array<Dynamic>):ICommand {
		var p:NativeArray = null;
		if (parameters != null)	p = Lib.toPhpArray(parameters);
		success = statement.execute(p);
		result = Lib.toHaxeArray(statement.fetchAll(type));
		if (handler != null) fetch(handler);
		if (queue != null) this.queue(queue);
		return this;
	}
	
	public function fetch(handler:Dynamic):ICommand {
		Dice.Values(result, function(v:Dynamic) { handler(v); } );
		return this;
	}
	
	public function queue(name:String):Void {
		Sirius.cache.add(name, result);
	}
	
}