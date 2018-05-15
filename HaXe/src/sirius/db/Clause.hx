package sirius.db;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Clause {
	
	static private var _IDX:UInt = 0;
	
	private var _joiner:String;
	
	/**
	 * Inner conditions
	 */
	public var conditions:Dynamic;
	
	/**
	 * 
	 * @param	conditions
	 * @param	joiner
	 */
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
		return { param:param, condition:"{{p}} LIKE :in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF B not in A
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function NOT_LIKE(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}} NOT LIKE :in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF id=A
	 * @param	value
	 * @return
	 */
	static public function ID(value:Dynamic):Dynamic {
		return { param:"id", condition:"{{p}}=:in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function EQUAL(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}=:in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function DIFFERENT(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}!=:in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * If A contains B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function IS_NULL(param:String):Dynamic {
		return { param:param, condition:"{{p}} :in_"+_IDX+"_", value:"$IS NULL", i:_IDX++ };
	}
	
	/**
	 * If A contains B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function NOT_NULL(param:String):Dynamic {
		return { param:param, condition:"{{p}} != :in_"+_IDX+"_", value:"$NULL", i:_IDX++ };
	}
	
	/**
	 * IF A In (B,B,...)
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function IN(param:String, values:Dynamic):Dynamic {
		if (Std.is(values, Array)){ 
			var q:Array<String> = [];
			Dice.All(values, function(p:String, v:Dynamic){ q[q.length] = ":in_" + _IDX + "x" + p + "_"; });
			return { param:param, condition:"{{p}} IN (" + q.join(',') + ")", value:values, i:_IDX++ };
		}else{
			return { param:param, condition:"{{p}} IN (:in_" + _IDX + ")", value:values, i:_IDX++ };
		}
	}
	
	/**
	 * IF A NOT IN (B,B,...))
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function NOT_IN(param:String, values:Dynamic):Dynamic {
		if (Std.is(values, Array)){ 
			var q:Array<String> = [];
			Dice.All(values, function(p:String, v:Dynamic){ q[q.length] = ":in_" + _IDX + "x" + p + "_"; });
			return { param:param, condition:"{{p}} NOT IN (" + q.join(',') + ")", value:values, i:_IDX++ };
		}else{
			return { param:param, condition:"{{p}} NOT IN (:in_" + _IDX + ")", value:values, i:_IDX++ };
		}
	}
	
	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function REGEXP(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}} REGEXP :in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF A=1
	 * @param	param
	 * @return
	 */
	static public function TRUE(param:String):Dynamic {
		return { param:param, condition:"{{p}}=:in_"+_IDX+"_", value:true, i:_IDX++ };
	}
	
	/**
	 * IF A=0
	 * @param	param
	 * @return
	 */
	static public function FALSE(param:String):Dynamic {
		return { param:param, condition:"{{p}}=:in_"+_IDX+"_", value:false, i:_IDX++ };
	}
	
	/**
	 * IF A!=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function DIFF(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}!=:in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF A<[=]B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function LESS(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}<:in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF A<=B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function LESS_OR(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}<=:in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF A>B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function GREATER(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}>:in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF A>B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function GREATER_OR(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}>=:in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF A>=B && A<=C
	 * @param	param
	 * @param	from
	 * @param	to
	 * @return
	 */
	static public function IN_RANGE(param:String, from:UInt, to:UInt):Clause {
		return Clause.AND([Clause.GREATER(param, from), Clause.LESS(param, to)]);
	}
	
	/**
	 * IF A<=B && A>=C
	 * @param	param
	 * @param	from
	 * @param	to
	 * @return
	 */
	static public function OUT_RANGE(param:String, from:UInt, to:UInt):Clause {
		return Clause.OR([Clause.LESS(param, from), Clause.GREATER(param, to)]);
	}
	
	/**
	 * IF A|1 AND A|2 AND A|...N [NEED ALL]
	 * @param	param
	 * @param	flags
	 * @param	any		IF A|1 OR A|2 OR A|...N [NEED ANY]
	 * @return
	 */
	static public function FLAGS(param:String, flags:Array<UInt>, any:Bool = false):Clause {
		var a:Array<Dynamic> = [];
		Dice.Values(flags, function(v:UInt):Void { a[a.length] = Clause.BIT(param, v); });
		return any ? Clause.OR(a) : Clause.AND(a);
	}
	
	/**
	 * IF A&B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function BIT(param:String, value:UInt):Dynamic {
		return { param:param, condition:"{{p}} & :in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * IF A&~B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function BIT_NOT(param:String, value:UInt):Dynamic {
		return { param:param, condition:"~{{p}} & :in_"+_IDX+"_", value:value, i:_IDX++ };
	}
	
	/**
	 * 
	 * @return
	 */
	public function joiner():String {
		return _joiner;
	}
	
}