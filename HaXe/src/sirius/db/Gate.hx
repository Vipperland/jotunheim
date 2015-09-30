package sirius.db;
import php.Lib;
import sirius.data.DataSet;
import sirius.data.IDataSet;
import sirius.errors.Error;
import sirius.db.Command;
import sirius.db.IGate;
import sirius.db.pdo.Bridge;
import sirius.db.pdo.Connection;
import sirius.db.pdo.Statement;
import sirius.db.Token;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Gate implements IGate {
	
	private var _db:Connection;
	
	public var command:ICommand;
	
	private var _token:Token;
	
	public var errors:Array<Error>;
	
	public function new() {
		errors = [];
	}
	
	public function isOpen():Bool {
		return _db != null && errors.length == 0;
	}
	
	public function open(token:Token):IGate {
		if (!isOpen()) {
			_token = token;
			try {
				_db = Bridge.open(token.host, token.user, token.pass, token.options);
			}catch (e:Dynamic) {
				Lib.dump(e);
				errors[errors.length] = new Error(e.getCode(), e.getMessage());
			}
			command = null;
		}
		return this;
	}
	
	public function prepare(query:String, ?parameters:Dynamic = null, ?options:Dynamic = null):ICommand {
		command = null;
		if (isOpen()) {
			var pdo:Statement = _db.prepare(query, Lib.toPhpArray(options == null ? [] : options));
			command = new Command(pdo, query, parameters);
		}
		return command;
	}
	
	public function insert(table:String, parameters:Dynamic, ?options:Dynamic = null):ICommand {
		var ps:Array<String> = [];
		Dice.All(parameters, ps.push);
		return prepare("INSERT INTO " + table + " (" + ps.join(",") + ") VALUES (:" + ps.join(",:") + ")", parameters, options);
	}
	
	public function schemaOf(?table:Dynamic):IDataSet {
		var r:IDataSet = null;
		if(isOpen()){
			if (!Std.is(table, Array)) table = [table];
			r = new DataSet();
			Dice.Values(table, function(v:String) {
				var c:ICommand = prepare("SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = :schema AND TABLE_NAME = :table", { schema:_token.db, table:v } ).execute();
				var s:IDataSet = new DataSet();
				Dice.All(c.result, s.set);
				r.set(v, s);
			});
		}
		return r;
	}
	
	public function insertedId():UInt {
		return Std.parseInt(_db.lastInsertId());
	}
	
}