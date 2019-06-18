package jotun.db;
import jotun.data.IDataSet;
import jotun.db.IGate;
import jotun.db.Token;
import jotun.db.objects.DataTable;
import jotun.db.objects.IDataTable;
import jotun.db.pdo.Connection;
import jotun.db.pdo.Database;
import jotun.db.pdo.Statement;
import jotun.db.tools.Command;
import jotun.db.tools.ExtCommand;
import jotun.db.tools.ICommand;
import jotun.db.tools.IExtCommand;
import jotun.db.tools.IQueryBuilder;
import jotun.db.tools.QueryBuilder;
import jotun.errors.Error;
import jotun.errors.IError;
import jotun.utils.Dice;
import php.Lib;

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
	
	public function getName():String {
		return _token.db;
	}
	
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
				setPdoAttributes(false);
			}catch (e:Dynamic) {
				errors[errors.length] = new Error(e.getCode(), e.getMessage());
			}
			command = null;
		}
		return this;
	}
	
	public function prepare(query:String, ?parameters:Dynamic = null, ?options:Dynamic = null):ICommand {
		var pdo:Statement = null;
		if (isOpen()) {
			pdo = _db.prepare(query, Lib.toPhpArray(options == null ? [] : options));
		}
		command = new Command(pdo, query, parameters, _errors, _logCommands ? _log : null);
		return command;
	}
	
	public function query(query:String, ?parameters:Dynamic = null):IExtCommand {
		command = new ExtCommand(isOpen() ? _db : null, query, parameters, _errors, _logCommands ? _log : null);
		return cast command;
	}
	
	public function schema(?table:Dynamic):Array<Dynamic> {
		var r:IDataSet = null;
		if (!Std.is(table, Array)) {
			table = [table];
		}
		var tables:Array<Dynamic> = [];
		var clausule:Clause = Clause.AND([
			Clause.EQUAL('TABLE_SCHEMA', _token.db),
			Clause.OR(tables),
		]);
		Dice.Values(table, function(v:String) {
			tables[tables.length] = Clause.EQUAL('TABLE_NAME', v);
		});
		return builder.find("*", "INFORMATION_SCHEMA.COLUMNS", clausule).execute().result;
	}
	
	public function insertedId():UInt {
		return Std.parseInt(_db.lastInsertId());
	}
	
	public function setPdoAttributes(value:Bool):IGate {
		_db.setAttribute(untyped __php__('PDO::ATTR_STRINGIFY_FETCHES'), value);
		_db.setAttribute(untyped __php__('PDO::ATTR_EMULATE_PREPARES'), value);
		_db.setAttribute(untyped __php__('PDO::MYSQL_ATTR_USE_BUFFERED_QUERY'), value);
		_db.setAttribute(untyped __php__('PDO::ATTR_ERRMODE'), untyped __php__('PDO::ERRMODE_EXCEPTION'));
		return this;
	}
	
	public function table(table:String):IDataTable {
		if (!Reflect.hasField(_tables, table)) {
			Reflect.setField(_tables, table, new DataTable(table, this));
		}
		return Reflect.field(_tables, table);
	}
	
	public function getTableNames():Array<String> {
		var r:Array<String> = [];
		Dice.Values(query("show tables").execute().result, function(v:Dynamic){
			Dice.Values(v, r.push);
		});
		return r;
	}
	
	public function getTables():Dynamic {
		var r:Dynamic = {};
		Dice.Values(getTableNames(), function(v:String){
			Reflect.setField(r, v, table(v));
		});
		return r;
	}
	
	public function ifTableExists(table:String):Bool {
		return getTableNames().indexOf(table) != -1;
	}
	
}