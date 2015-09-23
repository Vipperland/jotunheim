package sirius.db;
import php.Lib;
import php.NativeArray;
import sirius.data.DataSet;
import sirius.errors.Error;
import sirius.db.pdo.Statement;
import sirius.Sirius;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Command implements ICommand {
	
	private var _query:String;
	private var _parameters:Dynamic;
	
	// PDO::FETCH_ASSOC = 2
	// PDO::FETCH_OBJ = 5
	
	public var success:Bool;
	
	public var statement:Statement;
	
	public var result:NativeArray;
	
	public var errors:Array<Error>;

	public function new(statement:Statement, query:String, ?parameters:Dynamic) {
		errors = [];
		_parameters = { };
		_query = query;
		this.statement = statement;
		if (parameters != null) bind(parameters);
	}
	
	public function bind(parameters:Dynamic):ICommand {
		var isArray:Bool = Std.is(parameters, Array);
		Dice.All(parameters, function(p:Dynamic, v:Dynamic) {
			if (isArray)	statement.setAttribute(p, v);
			else 			statement.bindValue(p, v);
			Reflect.setField(_parameters, p, v);
		});
		return this;
	}
	
	public function execute(?handler:Dynamic, ?type:Int = 2, ?parameters:Array<Dynamic>):ICommand {
		var p:NativeArray = null;
		if (parameters != null)	p = Lib.toPhpArray(parameters);
		try {
			success = statement.execute(p);
			result = statement.fetchAll(type);
			if (handler != null) fetch(handler);
		}catch (e:Dynamic) {
			errors[errors.length] = new Error(e.getCode(), e.getMessage());
		}
		
		return this;
	}
	
	public function dataSet(handler:Dynamic):ICommand {
		Dice.Values(result, function(v:Dynamic) { handler(new DataSet(v)); } );
		return this;
	}
	
	public function fetch(handler:Dynamic):ICommand {
		Dice.Values(result, function(v:Dynamic) { handler(new DataSet(v)); } );
		return this;
	}
	
	public function log():String {
		var q:String = _query;
		Dice.All(_parameters, function(p:String, v:Dynamic) { q = StringTools.replace(q, ":" + p, v); });
		return q;
	}
	
}