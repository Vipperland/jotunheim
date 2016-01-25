package sirius.db.tools;
import haxe.Json;
import php.Lib;
import php.NativeArray;
import sirius.data.DataSet;
import sirius.data.IDataSet;
import sirius.errors.Error;
import sirius.db.pdo.Statement;
import sirius.errors.IError;
import sirius.Sirius;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Command implements ICommand {
	
	private var _query:String;
	
	private var _parameters:Dynamic;
	
	private var _errors:Array<IError>;
	
	private var _log:Array<String>;
	
	// PDO::FETCH_ASSOC = 2
	// PDO::FETCH_OBJ = 5
	
	public var success:Bool;
	
	public var statement:Statement;
	
	public var result:Array<Dynamic>;
	
	public var errors(get, null):Array<IError>;
	private function get_errors():Array<IError> { return _errors; }

	public function new(statement:Statement, query:String, ?parameters:Dynamic, errors:Array<IError>, log:Array<String>) {
		_log = log;
		_errors = errors;
		_query = query;
		this.statement = statement;
		if (parameters != null) bind(parameters);
	}
	
	public function bind(parameters:Dynamic):ICommand {
		_parameters = parameters;
		if(statement != null){
			var isArray:Bool = Std.is(parameters, Array);
			Dice.All(parameters, function(p:Dynamic, v:Dynamic) {
				if (isArray)	statement.setAttribute(p, v);
				else 			statement.bindValue(p, v);
				Reflect.setField(_parameters, p, v);
			});
		}
		return this;
	}
	
	public function execute(?handler:IDataSet->Bool, ?type:Int, ?parameters:Array<Dynamic>):ICommand {
		if(statement !=null){
			if (type == null) type = untyped __php__("\\PDO::FETCH_OBJ");
			var p:NativeArray = null;
			if (parameters != null)	p = Lib.toPhpArray(parameters);
			try {
				success = statement.execute(p);
				if (success) {
					result = Lib.toHaxeArray(statement.fetchAll(type));
					if (handler != null) fetch(handler);
				}else {
					errors[errors.length] = new Error(statement.errorCode(), Json.stringify(statement.errorInfo()));
				}
			}catch (e:Dynamic) {
				if (Std.is(e, String)) {
					errors[errors.length] = new Error(0, e);
				}else {
					errors[errors.length] = new Error(e.getCode(), e.getMessage());
				}
			}
			if (_log != null) _log[_log.length] = (success ? "[1]" : "[0]") + " " + log();
		}else {
			errors[errors.length] = new Error(0, "A connection with database is required.");
		}
		return this;
	}
	
	public function fetch(handler:IDataSet->Bool):ICommand {
		Dice.Values(result, function(v:Dynamic) { return handler(new DataSet(v)); } );
		return this;
	}
	
	public function find(param:String, values:Array<Dynamic>, ?limit:UInt = 0):Array<Dynamic> {
		var filter:Array<Dynamic> = [];
		Dice.Values(result, function(v:Dynamic) {
			if (Dice.Match([Reflect.field(v, param)], values, 1) > 0) {
				filter[filter.length] = v;
				return limit > 0 && --limit == 0;
			}
			return false;
		});
		return filter;
	}
	
	public function log():String {
		var q:String = _query;
		Dice.All(_parameters, function(p:String, v:Dynamic) { q = StringTools.replace(q, ":" + p, v); });
		return q;
	}
	
}