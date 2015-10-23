package hook;

/**
 * ...
 * @author Rafael Moreira
 */
@:native('Dice')
extern class Dice {
	/**
	 * For each object Value and parameter, call each(paramName,value)
	 * @param	q		Target object
	 * @param	each		Parameter and Value handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail param and value
	 * @return	Last value
	 */
	public static function All (q:Dynamic, each:Dynamic, ?complete:Dynamic->Void=null) : Dynamic;

	/**
	 * For each object Param call each(param)
	 * @param	q		Target object
	 * @param	each		Parameter handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail parameter
	 */
	public static function Params (q:Dynamic, each:Dynamic, ?complete:Dynamic->Void=null) : Dynamic;

	/**
	 * For each object Value call each(value)
	 * @param	q		Target object
	 * @param	each		Value handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail value
	 */
	public static function Values (q:Dynamic, each:Dynamic, ?complete:Dynamic->Void=null) : Dynamic;

	/**
	 * Execute the method in all object list (obj.method(...args))
	 * @param	q		Target object
	 * @param	method	Function name
	 * @param	args		Function arguments
	 */
	public static function Call (q:Dynamic, method:String, ?args:Array<Dynamic>) : Dynamic;

	/**
	 * Call a method f(a,b,a==b) while (a<b; ++a)
	 * @param	from
	 * @param	to
	 * @param	each
	 * @param	complete
	 */
	public static function Count (from:Dynamic, to:Dynamic, each:Int -> Int -> Bool -> Null<Bool>, ?complete:Dynamic->Void=null, ?increment:UInt=1) : Dynamic;

	/**
	 * Return the first valid value, if no one found, will return an alternative value
	 * @param	from
	 * @param	alt
	 * @return
	 */
	public static function One (from:Dynamic, ?alt:Dynamic) : Dynamic;

	/**
	 * Ammount of values that fit in a table
	 * @param	list
	 * @param	values
	 * @return
	 */
	public static function Match (table:Array<Dynamic>, values:Dynamic, ?limit:UInt=0) : Int;

	/**
	 * For each Child element in an Object
	 * @param	of				Target container
	 * @param	each			h(e:Element|Node)
	 * @param	complete		c(LastIndex_INT)
	 */
	public static function Children (of:Dynamic, each:Dynamic -> Int -> Null<Bool>, ?complete:Dynamic->Void = null) : Dynamic;
	
}
