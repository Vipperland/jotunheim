package sirius.db.tools;
import haxe.Json;
import php.Lib;
import php.NativeArray;
import sirius.db.pdo.Statement;
import sirius.errors.Error;
import sirius.errors.IError;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Command implements ICommand {
	
	private var _query:String;
	
	private var _parameters:Dynamic;
	
	private var _object:Dynamic;
	
	private var _errors:Array<IError>;
	
	private var _log:Array<String>;
	
	// PDO::FETCH_ASSOC = 2
	// PDO::FETCH_OBJ = 5
	
	public var success:Bool;
	
	public var statement:Statement;
	
	public var result:Array<Dynamic>;
	
	public var errors(get, null):Array<IError>;
	private function get_errors():Array<IError> { return _errors; }

	public function new(statement:Statement, query:String, parameters:Dynamic, object:Dynamic, errors:Array<IError>, log:Array<String>) {
		_log = log;
		_errors = errors;
		_query = query;
		_object = object;
		this.statement = statement;
		if (parameters != null) bind(parameters);
	}
	
	public function bind(parameters:Dynamic):ICommand {
		_parameters = parameters;
		if(statement != null){
			var isArray:Bool = Std.is(parameters, Array);
			Dice.All(parameters, function(p:Dynamic, v:Dynamic) {
				if (isArray){
					statement.setAttribute(p, v);
				}else {
					statement.bindValue(p, v);
				}
				Reflect.setField(_parameters, p, v);
			});
		}
		return this;
	}
	
	public function execute(?handler:Dynamic->Bool, ?type:Int, ?parameters:Array<Dynamic>):ICommand {
		if (statement != null){
			if (type == null){
				type = _object != null ? untyped __php__("\\PDO::FETCH_CLASS") : untyped __php__("\\PDO::FETCH_OBJ");
			}
			var p:NativeArray = null;
			if (parameters != null)	{
				p = Lib.toPhpArray(parameters);
			}
			try {
				success = statement.execute(p);
				if (success) {
					result = Lib.toHaxeArray(statement.fetchAll(type));
					if (handler != null) {
						fetch(handler);
					}
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
			if (_log != null) {
				_log[_log.length] = (success ? "[1]" : "[0]") + " " + log();
			}
		}else {
			errors[errors.length] = new Error(0, "A connection with database is required.");
		}
		return this;
	}
	
	public function fetch(handler:Dynamic->Bool):ICommand {
		Dice.Values(result, handler);
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
	
	public function length(?prop:String = 'COUNT(*)'):UInt {
		if (result != null && result.length > 0){
			var r0:Dynamic = result[0];
			if (Reflect.hasField(r0, prop)){
				return Std.parseInt(Reflect.field(r0, prop));
			}else{
				return result.length;
			}
		}
		return 0;
	}
	
	public function log():String {
		var q:String = _query;
		var r:Array<String>  = q.split(':');
		Dice.All(r, function(p:Dynamic, v:String) {
			if(Std.parseInt(p) > 0){
				var a = Math.min(v.indexOf(' '), v.indexOf(','));
				var b = Math.min(v.indexOf(')'), v.indexOf(';'));
				var i = Math.min(a, b);
				var h = v.substring(0, cast (i-1));
				var t = v.substring(cast i, v.length);
				if (Reflect.hasField(_parameters, h)){
					h = Reflect.field(_parameters, h);
					if (Std.is(h, String)){
						h = '"' + h + '"';
					}
					r[p] = h + t;
				}else{
					r[p] = ':' + v;
				}
			}
		});
		q = r.join('');
		Dice.All(_parameters, function(p:String, v:String){
			q = q.split(':' + p).join(v);
		});
		return q;
	}
	
}