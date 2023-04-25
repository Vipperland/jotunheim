package jotun.php.db;
import jotun.errors.Error;
import jotun.errors.IError;
import jotun.php.db.IGate;
import jotun.php.db.Token;
import jotun.php.db.objects.DataTable;
import jotun.php.db.objects.IDataTable;
import jotun.php.db.pdo.Connection;
import jotun.php.db.pdo.Database;
import jotun.php.db.pdo.Statement;
import jotun.php.db.tools.Command;
import jotun.php.db.tools.ExtCommand;
import jotun.php.db.tools.ICommand;
import jotun.php.db.tools.IExtCommand;
import jotun.php.db.tools.IQueryBuilder;
import jotun.php.db.tools.QueryBuilder;
import jotun.tools.Utils;
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
	
	private var _onLog:Array<String->Void>;
	
	public var builder:IQueryBuilder;
	
	public var command:ICommand;
	
	public var errors(get, null):Array<IError>;
	public function get_errors():Array<IError> { return _errors; }
	
	public function getName():String {
		return _token.db;
	}
	
	public function getInsertedID(?field:String, ?mode:String):Dynamic {
		var r:Dynamic = field != null ? _db.lastInsertId(field) : _db.lastInsertId();
		switch(mode){
			case 'int' : return Std.parseInt(r);
			case 'float' : return Std.parseFloat(r);
			case 'bool' : return Utils.boolean(r);
			default : return r;
		}
	}
	
	public function new() {
		_errors = [];
		_onLog = [];
		_tables = { };
		builder = new QueryBuilder(this);
	}
	
	public function isOpen():Bool {
		return _db != null && errors.length == 0;
	}
	
	public function listen(handler:String->Void):IGate {
		if (_onLog.indexOf(handler) == -1){
			_onLog[_onLog.length] = handler;
		}
		return this;
	}
	
	public function open(token:Token):IGate {
		if (!isOpen()) {
			_token = token;
			try {
				_db = Database.connect(token.host, token.user, token.pass, token.options);
				setPdoAttributes(true);
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
		command = new Command(pdo, query, parameters, _errors, _log);
		return command;
	}
	
	public function query(query:String, ?parameters:Dynamic = null):IExtCommand {
		command = new ExtCommand(isOpen() ? _db : null, query, parameters, _errors, _log);
		return cast command;
	}
	
	public function schema(?table:Dynamic):Array<Dynamic> {
		if (!Std.isOfType(table, Array)) {
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
	
	public function setPdoAttributes(value:Bool):IGate {
		_db.setAttribute(php.Syntax.code('\\PDO::ATTR_STRINGIFY_FETCHES'), value);
		_db.setAttribute(php.Syntax.code('\\PDO::ATTR_EMULATE_PREPARES'), value);
		_db.setAttribute(php.Syntax.code('\\PDO::MYSQL_ATTR_USE_BUFFERED_QUERY'), value);
		_db.setAttribute(php.Syntax.code('\\PDO::ATTR_ERRMODE'), php.Syntax.code('\\PDO::ERRMODE_EXCEPTION'));
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
	
	private function _log(message:String):Void {
		Dice.Values(_onLog, function(v:String->Void){
			v(message);
		});
	}
	
}