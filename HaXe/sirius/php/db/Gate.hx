package sirius.php.db;
import haxe.Log;
import php.Lib;
import sirius.data.DataSet;
import sirius.data.DataSet;
import sirius.php.db.IGate;
import sirius.php.db.pdo.Bridge;
import sirius.php.db.pdo.Connection;
import sirius.php.db.pdo.Statement;
import sirius.php.db.Token;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Gate implements IGate {
	
	private var _db:Connection;
	
	public var command:ICommand;
	
	public function new() {
	}
	
	public function isOpen():Bool {
		return _db != null;
	}
	
	public function open(token:Token):IGate {
		if (!isOpen()) {
			_db = Bridge.open(token.host, token.user, token.pass, token.options);
			command = null;
		}
		return this;
	}
	
	public function prepare(query:String, ?parameters:Dynamic = null, ?options:Dynamic = null):ICommand {
		command = null;
		if (isOpen()) {
			var pdo:Statement = _db.prepare(query, Lib.toPhpArray(options == null ? [] : options));
			command = new Command(pdo, parameters);
		}
		return command;
	}
	
	public function fields(table:Dynamic):DataSet {
		if (!Std.is(table, Array)) table = [table];
		var r:DataSet = new DataSet();
		Dice.Values(table, function(v:String) {
			var c:ICommand = prepare("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = :table", { table:v } ).execute();
			var s:Array<String> = [];
			Dice.Values(c.result, function(v:Dynamic) {	s[s.length] = v.COLUMN_NAME; } );
			r.set(v, s);
		});
		return r;
	}
	
}