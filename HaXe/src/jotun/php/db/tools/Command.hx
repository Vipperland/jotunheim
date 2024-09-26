package jotun.php.db.tools;
import haxe.Json;
import php.Lib;
import php.NativeArray;
import jotun.php.db.pdo.Statement;
import jotun.errors.Error;
import jotun.errors.ErrorDescriptior;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Command implements ICommand {
	
	private var _query:String;
	
	private var _parameters:Array<Dynamic>;
	
	private var _errors:Array<ErrorDescriptior>;
	
	private var _log:String->Void;
	
	// PDO::FETCH_ASSOC = 2
	// PDO::FETCH_OBJ = 5
	
	public var success:Bool;
	
	public var statement:Statement;
	
	public var result:Array<Dynamic>;
	
	public var errors(get, null):Array<ErrorDescriptior>;
	private function get_errors():Array<ErrorDescriptior> { return _errors; }

	public function new(statement:Statement, query:String, parameters:Array<Dynamic>, errors:Array<ErrorDescriptior>, log:String->Void) {
		_log = log;
		_errors = errors;
		_query = query;
		this.statement = statement;
		if (parameters != null) {
			bind(parameters);
		}
	}
	
	private function _getType(v:Dynamic):Int {
		if (Std.isOfType(v, String)){
			return php.Syntax.code('\\PDO::PARAM_STR');
		} else if (Std.isOfType(v, Float)){
			return php.Syntax.code('\\PDO::PARAM_STR');
		}  else if (Std.isOfType(v, Int)){
			return php.Syntax.code('\\PDO::PARAM_INT');
		} else if (Std.isOfType(v, Bool)){
			return php.Syntax.code('\\PDO::PARAM_INT');
		} else if (v == null){
			return php.Syntax.code('\\PDO::PARAM_NULL');
		}else{
			return php.Syntax.code('\\PDO::PARAM_STR');
		}
	}
	
	public function bind(parameters:Array<Dynamic>):ICommand {
		_parameters = parameters;
		if(statement != null){
			Dice.All(parameters, function(p:Dynamic, v:Dynamic):Void  {
				statement.bindValue(1+p, v, _getType(v));
				Reflect.setField(_parameters, p, v);
			});
		}
		return this;
	}
	
	public function execute(?handler:Dynamic->Bool, ?type:Dynamic, ?parameters:Array<Dynamic>):ICommand {
		if (statement != null){
			var p:NativeArray = null;
			if (parameters != null)	{
				p = Lib.toPhpArray(parameters);
			}
			try {
				success = statement.execute(p);
				if (!success) {
					errors[errors.length] = new Error(statement.errorCode(), Lib.toHaxeArray(statement.errorInfo()));
				}
				this.statement = null;
			}catch (e:Dynamic) {
				if (Std.isOfType(e, String)) {
					errors[errors.length] = new Error(0, e);
				}else {
					errors[errors.length] = new Error(e.getCode(), e.getMessage());
				}
			}
			if (_log != null) {
				_log((success ? "[1]" : "[0]") + " " + log());
			}
		}else {
			errors[errors.length] = new Error(0, "A connection with database is required.");
		}
		return this;
	}
	
	public function log():String {
		var r:Array<String>  = _query.split('?');
		if(_parameters != null){
			Dice.All(r, function(p:Dynamic, v:String):Void {
				if (p < _parameters.length){
					var e:Dynamic = _parameters[p];
					if (Std.isOfType(e, String)){
						e = '"' + e + '"';
					}
					r[p] = v + e;
				}
			});
		}
		return r.join('');
	}
	
	public function query():String {
		return _query;
	}
	
}