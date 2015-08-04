package php.db;
import php.db.PDO.PDOClass;
import php.db.PDO.PDOStatement;
import php.NativeArray;
import sirius.utils.Dice;
import sys.db.Connection;

/**
 * ...
 * @author Rafael Moreira
 */
class Gate {
	
	private var _db:PDOClass;
	
	public var command:Command;
	
	public function new() {
	}
	
	public function isOpen():Bool {
		return _db != null;
	}
	
	public function open(token:Token):Gate {
		if (!isOpen()) {
			_db = cast PDO.open(token.host, token.user, token.pass, token.options);
			command = null;
		}
		return this;
	}
	
	public function prepare(query:String, parameters:Array<Dynamic>, ?exec:Bool = true, ?options:Dynamic = null):Gate {
		command = null;
		if (isOpen()) {
			command = new Command(_db.prepare(query, options), parameters);
			if (exec) {
				command.execute();
			}
		}
		return this;
	}
	
	public function bind(parameters:Array<Dynamic>):Gate {
		if (isOpen() && command != null) {
			command.bind(parameters);
		}
		return this;
	}
	
	public function execute(?parameters:Array<Dynamic>):Command {
		command.execute(parameters);
		return command;
	}
	
}