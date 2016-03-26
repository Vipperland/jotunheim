package sirius.db;

/**
 * ...
 * @author Rafael Moreira
 */
class Clause {
	
	private var _joiner:String;
	
	/**
	 * Inner conditions
	 */
	public var conditions:Dynamic;
	
	public function new(conditions:Dynamic, joiner:String) {
		_joiner = joiner;
		this.conditions = conditions;
	}
	
	/**
	 * Group by entries by (A || B || ... || N)
	 * @param	conditions
	 * @return
	 */
	static public function OR(conditions:Array<Dynamic>):Clause {
		return new Clause(conditions, " || ");
	}
	
	/**
	 * Group by entries by (A && B && ... && N)
	 * @param	conditions
	 * @return
	 */
	static public function AND(conditions:Array<Dynamic>):Clause {
		return new Clause(conditions, " && ");
	}
	
	/**
	 * If A contains B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function LIKE(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}} LIKE :in_{{p}}", value:value };
	}
	
	/**
	 * IF B not in A
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function UNLIKE(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}} NOT LIKE :in_{{p}}", value:value };
	}
	
	/**
	 * IF id=A
	 * @param	value
	 * @return
	 */
	static public function ID(value:Dynamic):Dynamic {
		return { param:"id", condition:"{{p}}=:in_{{p}}", value:value };
	}
	
	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function EQUAL(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}=:in_{{p}}", value:value };
	}
	
	/**
	 * IF A=1
	 * @param	param
	 * @return
	 */
	static public function TRUE(param:String):Dynamic {
		return { param:param, condition:"{{p}}=:in_{{p}}", value:true };
	}
	
	/**
	 * IF A=0
	 * @param	param
	 * @return
	 */
	static public function FALSE(param:String):Dynamic {
		return { param:param, condition:"{{p}}=:in_{{p}}", value:false };
	}
	
	/**
	 * IF A!=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function UNEQUAL(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}!=:in_{{p}}", value:value };
	}
	
	/**
	 * IF A<[=]B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function LESS(param:String, value:Dynamic, ?or:Bool=true):Dynamic {
		return { param:param, condition:"{{p}}<" + (or ? "=" : "") + ":in_{{p}}", value:value };
	}
	
	/**
	 * IF A>[=]B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function GREATER(param:String, value:Dynamic, ?or:Bool=true):Dynamic {
		return { param:param, condition:"{{p}}>" + (or ? "=" : "") + ":in_{{p}}", value:value };
	}
	
	/**
	 * IF A&B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function BIT(param:String, value:UInt):Dynamic {
		return { param:param, condition:"{{p}} & :in_{{p}}", value:value };
	}
	
	/**
	 * IF A&~B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function BIT_NOT(param:String, value:UInt):Dynamic {
		return { param:param, condition:"{{p}} & ~:in_{{p}}", value:value };
	}
	
	public function joiner():String {
		return _joiner;
	}
	
}