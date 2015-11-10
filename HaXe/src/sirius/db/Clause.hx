package sirius.db;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Clause {
	
	private var _joiner:String;
	
	public var conditions:Dynamic;
	
	public function new(conditions:Dynamic, joiner:String) {
		_joiner = joiner;
		this.conditions = conditions;
	}
	
	static public function OR(conditions:Array<Dynamic>):Clause {
		return new Clause(conditions, " || ");
	}
	
	static public function AND(conditions:Array<Dynamic>):Clause {
		return new Clause(conditions, " && ");
	}
	
	static public function LIKE(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}} LIKE :in_{{p}}", value:value };
	}
	
	static public function NOT_LIKE(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}} NOT LIKE :in_{{p}}", value:value };
	}
	
	static public function EQUAL(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}=:in_{{p}}", value:value };
	}
	
	static public function NOT_EQUAL(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}!=:in_{{p}}", value:value };
	}
	
	static public function LESS(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}<:in_{{p}}", value:value };
	}
	
	static public function LESS_EQUAL(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}<=:in_{{p}}", value:value };
	}
	
	static public function GREATER(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}>:in_{{p}}", value:value };
	}
	
	static public function GREATER_EQUAL(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}>=:in_{{p}}", value:value };
	}
	
	public function joiner():String {
		return _joiner;
	}
	
}