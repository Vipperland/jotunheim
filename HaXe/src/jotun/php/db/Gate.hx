package jotun.php.db;
import haxe.extern.EitherType;
import jotun.errors.Error;
import jotun.errors.ErrorDescriptior;
import jotun.php.db.Token;
import jotun.php.db.objects.DataTable;
import jotun.php.db.objects.DataTable;
import jotun.php.db.pdo.Connection;
import jotun.php.db.pdo.Database;
import jotun.php.db.pdo.Statement;
import jotun.php.db.tools.Command;
import jotun.php.db.tools.ExtCommand;
import jotun.php.db.tools.ICommand;
import jotun.php.db.tools.IExtCommand;
import jotun.php.db.tools.QueryBuilder;
import jotun.tools.Utils;
import jotun.utils.Dice;
import php.Lib;

/**
 * ...
 * @author Rafael Moreira
 */
class Gate {
	
	private var _db:Connection;
	
	private var _token:Token;
	
	private var _tables:Dynamic;
	
	private var _errors:Array<ErrorDescriptior>;
	
	private var _onLog:Array<String->Void>;
	
	/**
	 * Fast bulk command
	 */
	public var builder:QueryBuilder;
	
	/**
	 * Last created command
	 */
	public var command:EitherType<ICommand,IExtCommand>;
	
	/**
	 * Connection and Execution Errors
	 */
	public var errors(get, null):Array<ErrorDescriptior>;
	public function get_errors():Array<ErrorDescriptior> { return _errors; }
	
	/**
	   Name of Selected database
	   @return
	**/
	public function getName():String {
		return _token.db;
	}
	
	/**
	   LAst inserted column value
	   @param	field
	   @param	mode
	   @return
	**/
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
	
	/**
	 * If the connection is available
	 * @return
	 */
	public function isOpen():Bool {
		return _db != null && errors.length == 0;
	}
	
	/**
	 * register query execution
	 * @param	handler
	 * @return
	 */
	public function listen(handler:String->Void):Gate {
		if (_onLog.indexOf(handler) == -1){
			_onLog[_onLog.length] = handler;
		}
		return this;
	}
	
	/**
	 * Open a connection
	 * @param	token
	 * @return
	 */
	public function open(token:Token):Gate {
		if (!isOpen()) {
			_token = token;
			try {
				_db = Database.connect(token.host, token.user, token.pass, token.options);
				_db.setAttribute(php.Syntax.code('\\PDO::ATTR_ERRMODE'), php.Syntax.code('\\PDO::ERRMODE_EXCEPTION'));
				setPdoAttributes(false, true, true);
			}catch (e:Dynamic) {
				errors[errors.length] = new Error(e.getCode(), e.getMessage());
			}
			command = null;
		}
		return this;
	}
	
	/**
	 * The query to execute
	 * @param	query
	 * @param	parameters
	 * @param	object
	 * @param	options
	 * @return
	 */
	public function prepare(query:String, ?parameters:Dynamic = null, ?options:Dynamic = null):ICommand {
		command = new Command(isOpen() ? _db.prepare(query, Lib.toPhpArray(options == null ? [] : options)) : null, query, parameters, _errors, _log);
		return command;
	}
	
	/**
	 * 
	 * @param	query
	 * @param	parameters
	 * @return
	 */
	public function query(query:String, ?parameters:Dynamic = null, ?options:Dynamic = null):IExtCommand {
		command = new ExtCommand(isOpen() ? _db.prepare(query, Lib.toPhpArray(options == null ? [] : options)) : null, query, parameters, _errors, _log);
		return cast command;
	}
	
	/**
	 * Show all fields of a table
	 * @param	table
	 * @return
	 */
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
	
	/**
	 * Enable/Disable INT to String conversions
	 * @param	value
	 * @return
	 */
	public function setPdoAttributes(stringify:Bool, emulate:Bool, buffered:Bool):Gate {
		_db.setAttribute(php.Syntax.code('\\PDO::ATTR_STRINGIFY_FETCHES'), stringify);
		_db.setAttribute(php.Syntax.code('\\PDO::ATTR_EMULATE_PREPARES'), emulate);
		_db.setAttribute(php.Syntax.code('\\PDO::MYSQL_ATTR_USE_BUFFERED_QUERY'), buffered);
		return this;
	}
	
	/**
	 * Shotcut to table statements and methods
	 * @param	table
	 * @return
	 */
	public function table(table:String):DataTable {
		if (!Reflect.hasField(_tables, table)) {
			Reflect.setField(_tables, table, new DataTable(table, this));
		}
		return Reflect.field(_tables, table);
	}
	
	/**
	   Get name of all tables in the selected database
	   @return
	**/
	public function getTableNames():Array<String> {
		var r:Array<String> = [];
		Dice.Values(query("show tables").execute().result, function(v:Dynamic){
			Dice.Values(v, r.push);
		});
		return r;
	}
	
	/**
	   Get all DataTable objects from the selected database
	   @return
	**/
	public function getTables():Dynamic {
		var r:Dynamic = {};
		Dice.Values(getTableNames(), function(v:String){
			Reflect.setField(r, v, table(v));
		});
		return r;
	}
	
	/**
	   LAst inserted column value
	   @param	field
	   @param	mode
	   @return
	**/
	public function ifTableExists(table:String):Bool {
		return getTableNames().indexOf(table) != -1;
	}
	
	private function _log(message:String):Void {
		Dice.Values(_onLog, function(v:String->Void){
			v(message);
		});
	}
	
}