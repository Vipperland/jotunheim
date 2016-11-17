package sirius.utils;
import haxe.ds.ArraySort;
import sirius.tools.Utils;
import sirius.utils.IDiceRoll;

#if php
	import php.Lib;
	import php.NativeArray;
#elseif js
	import js.html.Element;
	import js.html.Node;
	import sirius.dom.IDisplay;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Dice")
class Dice {
	
	/**
	 * For each object Value and parameter, call each(paramName,value)
	 * @param	q		Target object
	 * @param	each		Parameter and Value handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail param and value
	 * @return	Last value
	 */
	public static function All(q:Dynamic, each:Dynamic, ?complete:IDiceRoll->Void = null):IDiceRoll {
		var v:Dynamic = null;
		var p:Dynamic = null;
		var i:Bool = true;
		var k:UInt = 0;
		if (q != null) {
			#if php
				// ==== Workaround with PHP Arrays
				if (Std.is(q, NativeArray) || Std.is(q, Array)) q = Lib.objectOfAssociativeArray(q);
				//Lib.dump(q);
			#end
			for (p in Reflect.fields(q)) {
				v = Reflect.field(q, p);
				#if php
					// ==== Skip object methods in PHP object
					if (Reflect.isFunction(v)) continue;
				#end
				if (each(p, v) == true) {
					i = false;
					break;
				}else {
					++k;
					p = null;
					v = null;
				}
			}
		}
		var r:IDiceRoll = cast { param:p, value:v, completed:i, object:q, keys:k };
		if (complete != null) complete(r);
		return r;
		
	}
	
	/**
	 * For each object Param call each(param)
	 * @param	q		Target object
	 * @param	each		Parameter handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail parameter
	 */
	public static function Params(q:Dynamic, each:Dynamic, ?complete:IDiceRoll->Void = null):IDiceRoll {
		return All(q, 
			function(p:Dynamic, v:Dynamic) { return each(p); }, 
			complete
		);
	}
	
	/**
	 * For each object Value call each(value)
	 * @param	q		Target object
	 * @param	each		Value handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail value
	 */
	public static function Values(q:Dynamic, each:Dynamic, ?complete:IDiceRoll->Void = null):IDiceRoll {
		return All(q, 
			function(p:Dynamic, v:Dynamic) { return each(v); }, 
			complete
		);
	}
	
	/**
	 * Execute the method in all object list (obj.method(...args))
	 * @param	q		Target object
	 * @param	method	Function name
	 * @param	args		Function arguments
	 */
	public static function Call(q:Array<Dynamic>, method:String, ?args:Array<Dynamic>):IDiceRoll {
		if (args == null) args = [];
		return All(q,
			function(p:Dynamic, v:Dynamic) {
				#if js
					untyped __js__("v[method].apply(q,args)");
				#elseif php
					Reflect.callMethod(v, Reflect.field(v, method), args); 
				#end
			},
			null
		);
	}
	
	/**
	 * Call a method f(a,b,a==b) while (a<b; ++a)
	 * @param	from
	 * @param	to
	 * @param	each
	 * @param	complete
	 */
	public static function Count(from:Dynamic, to:Dynamic, each:Int->Int->Bool->Null<Bool>, ?complete:IDiceRoll->Void = null, ?increment:UInt = 1):IDiceRoll {
		var a:Float = Math.min(from, to);
		var b:Float = Math.max(from, to);
		if (increment == null || increment < 1) increment = 1;
		while (a < b) {
			if (each(cast a, cast b, (a += increment) == b) == true)
				break;
		}
		var c:Bool = a == b;
		var r:IDiceRoll = cast { from:from, to:b, completed:c, value:a-increment };
		if (complete != null) complete(r);
		return r;
	}
	
	/**
	 * Return the first valid value, if no one found, will return an alternative value
	 * @param	from
	 * @param	alt
	 * @return
	 */
	public static function One(from:Dynamic, ?alt:Dynamic):IDiceRoll {
		if (Std.is(from, Array)) {
			Values(from, function(v:Dynamic) {
				from = v;
				return from == null;
			});
		}
		return cast { value:Utils.isValid(from) ? from : alt, object:from };
	}
	
	/**
	 * Ammount of values that fit in a table
	 * @param	list
	 * @param	values
	 * @return
	 */
	public static function Match(table:Array<Dynamic>, values:Dynamic, ?limit:UInt = 0):Int {
		if (!Std.is(values, Array)) values = [values];
		var r:Int = 0;
		Dice.Values(values, function(v:Dynamic) {
			if (Lambda.indexOf(table, v) != -1) ++r;
			if (limit > 0) return --limit == 0;
			return false;
		});
		return r;
	}
	
	/**
	 * Concat all mixed data into one array
	 * @param	data
	 * @return
	 */
	public static function Mix(data:Array<Dynamic>):Array<Dynamic> {
		var r:Array<Dynamic> = [];
		Dice.Values(data, function(v:Dynamic) {	r = r.concat(v); });
		return r;
	}
	
	/**
	 * Sort all data in a vector by key
	 * @param	data
	 * @param	key
	 * @param	numeric
	 * @return
	 */
	public static function Table(data:Array<Dynamic>, ?key:String, ?numeric:Bool = false, ?copy:Bool = false):Dynamic {
		var r:Array<Dynamic> = copy == true ? [].concat(data) : data;
		if (numeric) {
			// INT objA.key < INT objB.key
			if(key != null)
				ArraySort.sort(r, function (a:Int, b:Int):Int {
					return Reflect.field(a, key) < Reflect.field(b, key) ? -1 : 1;
				});
			// INT a < INT b
			else
				ArraySort.sort(r, function (a:Int, b:Int):Int {
					return a < b ? -1 : 1;
				});
		}
		// objA.key < objB.key
		else if(key != null)
			ArraySort.sort(r, function (a:Dynamic, b:Dynamic):Int {
				return Reflect.compare(SearchTag.convert(Reflect.field(a, key)),SearchTag.convert(Reflect.field(b, key)));
			});
		// STR a < STR b
		else
			ArraySort.sort(r, function (a:Int, b:Int):Int {
				return Reflect.compare(SearchTag.convert(a),SearchTag.convert(b));
			});
		return r;
	}
	
	#if !php
		/**
		 * For each Child element in an Object
		 * @param	of				Target container
		 * @param	each			h(e:Element|Node)
		 * @param	complete		c(LastIndex_INT)
		 */
		public static function Children(of:Dynamic, each:Node->Int->Null<Bool>, ?complete:IDiceRoll->Void = null):IDiceRoll {
			var r:IDiceRoll = cast { children:[] };
			var l:Int = 0;
			var c:Element;
			if (of != null) {
				if (Std.is(of, IDisplay)) of = of.element;
				Count(0, of.childNodes.length, function(i:Int,j:Int,k:Bool) {
					c = cast of.childNodes.item(i);
					r.children[l] = c;
					return each(c, i);
				}, complete);
			}
			return r;
		}
	
	#end
	
}