package jotun.db;
import jotun.utils.Dice;

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
		return { param:param, condition:"{{p}} LIKE ?", value:value };
	}
	
	/**
	 * IF B not in A
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function NOT_LIKE(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}} NOT LIKE ?", value:value };
	}
	
	/**
	 * IF id=A
	 * @param	value
	 * @return
	 */
	static public function ID(value:Dynamic):Dynamic {
		return { param:"id", condition:"{{p}}=?", value:value };
	}
	
	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function EQUAL(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}=?", value:value };
	}
	
	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function DIFFERENT(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}!=?", value:value };
	}
	
	/**
	   Add a custom condition
	   @param	condition
	   @return
	**/
	static public function CUSTOM(condition:String):Dynamic {
		return { param:"", condition:condition, value:null, skip:true };
	}
	
	/**
	 * If A contains B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function IS_NULL(param:String):Dynamic {
		return { param:param, condition:"{{p}} IS NULL", value:null, skip:true };
	}
	
	/**
	 * If A contains B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function NOT_NULL(param:String):Dynamic {
		return { param:param, condition:"{{p}} != NULL", value:null, skip:true };
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
			Dice.All(values, function(p:String, v:Dynamic){ q[q.length] = "?"; });
			return { param:param, condition:"{{p}} IN (" + q.join(',') + ")", value:values };
		}else{
			return { param:param, condition:"{{p}} IN (?)", value:values };
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
			Dice.All(values, function(p:String, v:Dynamic){ q[q.length] = "?"; });
			return { param:param, condition:"{{p}} NOT IN (" + q.join(',') + ")", value:values };
		}else{
			return { param:param, condition:"{{p}} NOT IN (?)", value:values };
		}
	}
	
	/**
	 * IF A=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function REGEXP(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}} REGEXP ?", value:value };
	}
	
	/**
	 * IF A=1
	 * @param	param
	 * @return
	 */
	static public function TRUE(param:String):Dynamic {
		return { param:param, condition:"{{p}}=?", value:true };
	}
	
	/**
	 * IF A=0
	 * @param	param
	 * @return
	 */
	static public function FALSE(param:String):Dynamic {
		return { param:param, condition:"{{p}}=?", value:false };
	}
	
	/**
	 * IF A!=B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function DIFF(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}!=?", value:value };
	}
	
	/**
	 * IF A<[=]B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function LESS(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}<?", value:value };
	}
	
	/**
	 * IF A<=B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function LESS_OR(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}<=?", value:value };
	}
	
	/**
	 * IF A>B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function GREATER(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}>?", value:value };
	}
	
	/**
	 * IF A>B
	 * @param	param
	 * @param	value
	 * @param	or
	 * @return
	 */
	static public function GREATER_OR(param:String, value:Dynamic):Dynamic {
		return { param:param, condition:"{{p}}>=?", value:value };
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
		return { param:param, condition:"{{p}} & ?", value:value };
	}
	
	/**
	 * IF A&~B
	 * @param	param
	 * @param	value
	 * @return
	 */
	static public function BIT_NOT(param:String, value:UInt):Dynamic {
		return { param:param, condition:"~{{p}} & ?", value:value };
	}
	
	/**
	 * 
	 * @return
	 */
	public function joiner():String {
		return _joiner;
	}
	
}