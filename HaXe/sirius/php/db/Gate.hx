package sirius.php.db;
import php.Lib;
import sirius.php.db.pdo.Bridge;
import sirius.php.db.pdo.Connection;
import sirius.php.db.pdo.Statement;
import sirius.php.db.Token;

/**
 * ...
 * @author Rafael Moreira
 */
class Gate {
	
	private var _db:Connection;
	
	public var command:Command;
	
	public function new() {
	}
	
	public function isOpen():Bool {
		return _db != null;
	}
	
	public function open(token:Token):Gate {
		if (!isOpen()) {
			_db = Bridge.open(token.host, token.user, token.pass, token.options);
			command = null;
		}
		return this;
	}
	
	public function prepare(query:String, ?parameters:Dynamic = null, ?options:Dynamic = null):Command {
		command = null;
		if (isOpen()) {
			var pdo:Statement = _db.prepare(query, Lib.toPhpArray(options == null ? [] : options));
			command = new Command(pdo, parameters);
		}
		return command;
	}
	
}