package php.db;
import php.db.PDO.PDOStatement;
import php.NativeArray;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Command {
	
	// PDO::FETCH_ASSOC = 2
	// PDO::FETCH_OBJ = 5
	
	public var success:Bool;
	
	public var statement:PDOStatement;
	
	public var result:Array<Dynamic>;

	public function new(statement:PDOStatement, arguments:Array<Dynamic>) {
		this.statement = statement;
		if (arguments != null) bind(arguments);
	}
	
	public function bind(arguments:Array<Dynamic>):Command {
		Dice.All(arguments, function(p:Int, v:Dynamic) {
			statement.setAttribute(p, v);
		});
		return this;
	}
	
	public function execute(?handler:Dynamic, ?parameters:Array<Dynamic>):Command {
		var p:NativeArray = null;
		if (parameters != null) p = Lib.toPhpArray(parameters);
		success = statement.execute(p);
		if (handler != null) fetch(handler);
		return this;
	}
	
	public function fetch(?handler:Dynamic):Command {
		result = Lib.toHaxeArray(statement.fetchAll(2));
		if (handler != null) handler(success, result);
		return this;
	}
	
}