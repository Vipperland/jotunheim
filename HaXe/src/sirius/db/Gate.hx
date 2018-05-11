package sirius.db;
import php.Lib;
import sirius.data.IDataSet;
import sirius.db.tools.Command;
import sirius.db.IGate;
import sirius.db.objects.IDataTable;
import sirius.db.objects.DataTable;
import sirius.db.pdo.Database;
import sirius.db.pdo.Connection;
import sirius.db.pdo.Statement;
import sirius.db.Token;
import sirius.db.tools.ICommand;
import sirius.db.tools.IQueryBuilder;
import sirius.db.tools.QueryBuilder;
import sirius.errors.Error;
import sirius.errors.IError;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Gate implements IGate {
	
	private var _db:Connection;
	
	private var _token:Token;
	
	private var _tables:Dynamic;
	
	private var _errors:Array<IError>;
	
	private var _log:Array<String>;
	
	private var _logCommands:Bool;
	
	public var builder:IQueryBuilder;
	
	public var command:ICommand;
	
	public var errors(get, null):Array<IError>;
	public function get_errors():Array<IError> { return _errors; }
	
	public var log(get, null):Array<String>;
	public function get_log():Array<String> { return _log; }
	
	public function new() {
		_errors = [];
		_log = [];
		_logCommands = false;
		_tables = { };
		builder = new QueryBuilder(this);
	}
	
	public function isOpen():Bool {
		return _db != null && errors.length == 0;
	}
	
	public function open(token:Token, log:Bool = false):IGate {
		_logCommands = log;
		if (!isOpen()) {
			_token = token;
			try {
				_db = Database.connect(token.host, token.user, token.pass, token.options);
			}catch (e:Dynamic) {
				errors[errors.length] = new Error(e.getCode(), e.getMessage());
			}
			command = null;
		}
		return this;
	}
	
	public function prepare(query:String, ?parameters:Dynamic = null, ?object:Dynamic, ?options:Dynamic = null):ICommand {
		var pdo:Statement = null;
		if (isOpen()) pdo = _db.prepare(query, Lib.toPhpArray(options == null ? [] : options));
		command = new Command(pdo, query, parameters, object, _errors, _logCommands ? _log : null);
		return command;
	}
	
	public function schema(?table:Dynamic):ICommand {
		var r:IDataSet = null;
		if (!Std.is(table, Array)) table = [table];
		
		var tables:Array<Dynamic> = [];
		var clausule:Clause = Clause.AND([
			Clause.EQUAL('TABLE_SCHEMA', _token.db),
			Clause.OR(tables),
		]);
		Dice.Values(table, function(v:String) {
			tables[tables.length] = Clause.EQUAL('TABLE_NAME', v);
		});
		return builder.find("*", "INFORMATION_SCHEMA.COLUMNS", clausule).execute();
	}
	
	public function insertedId():UInt {
		return Std.parseInt(_db.lastInsertId());
	}
	
	public function table(table:String):IDataTable {
		if (!Reflect.hasField(_tables, table)) Reflect.setField(_tables, table, new DataTable(table, this));
		return Reflect.field(_tables, table);
	}
	
}