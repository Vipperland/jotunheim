package sirius.utils;
import haxe.Log;
import sirius.dom.IDisplay;
import sirius.tools.Utils;
import utils.IDice;

#if php
	import php.Lib;
#elseif !php
	import js.html.Element;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.utils.Dice")
class Dice {
	
	/**
	 * For each object Value and parameter, call each(paramName,value)
	 * @param	q		Target object
	 * @param	each		Parameter and Value handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail param and value
	 * @return	Last value
	 */
	public static function All(q:Dynamic, each:Dynamic, ?complete:Dynamic = null):IDice {
		var v:Dynamic = null;
		var p:Dynamic = null;
		var c:Bool = complete != null;
		var i:Bool = true;
		if (q != null) {
			
			#if php
				// ==== Workaround with PHP Arrays
				if(Std.is(q, Array)) q = Lib.objectOfAssociativeArray(q);
			#end
			for (p in Reflect.fields(q)) {
				v = Reflect.field(q, p);
				#if php
					// ==== Skip object methods on PHP object
					if (Reflect.isFunction(v)) continue;
				#end
				if (each(p, v) == true) {
					i = false;
					break;
				}else {
					p = null;
					v = null;
				}
			}
			
		}
		var r:IDice = cast { param:p, value:v, completed:i };
		if (c) complete(r);
		return r;
		
	}
	
	/**
	 * For each object Param call each(param)
	 * @param	q		Target object
	 * @param	each		Parameter handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail parameter
	 */
	public static function Params(q:Dynamic, each:Dynamic, ?complete:Dynamic = null):IDice {
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
	public static function Values(q:Dynamic, each:Dynamic, ?complete:Dynamic = null):IDice {
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
	public static function Call(q:Dynamic, method:String, ?args:Array<Dynamic>):IDice {
		if (args == null) args = [];
		return All(q,
			function(p:Dynamic, v:Dynamic) {
				Reflect.callMethod(v, Reflect.field(v, method), args); 
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
	public static function Count(from:Dynamic, to:Dynamic, each:Dynamic, ?complete:Dynamic = null, ?increment:UInt = 1):IDice {
		var a:Float = Math.min(from, to);
		var b:Float = Math.max(from, to);
		if (increment == null || increment < 1) {
			increment = 1;
		}
		while (a < b) {
			if (each(a,b,(a+=increment)==b) == true) break;
		}
		var c:Bool = a == b;
		var r:IDice = cast { from:from, to:b, completed:c, value:a };
		if (c) complete(r);
		return r;
	}
	
	/**
	 * Return the first valid value, if no one found, will return an alternative value
	 * @param	from
	 * @param	alt
	 * @return
	 */
	public static function One(from:Dynamic, ?alt:Dynamic):IDice {
		if (Std.is(from, Array)) {
			Values(from, function(v:Dynamic) {
				from = v;
				return from == null;
			});
		}
		return cast { value:Utils.isValid(from) ? from : alt };
	}
	
	/**
	 * Ammount of values that fit in a table
	 * @param	list
	 * @param	values
	 * @return
	 */
	public static function Match(table:Array<Dynamic>, values:Dynamic):Int {
		if (!Std.is(values, Array)) values = [values];
		var r:Int = 0;
		Dice.Values(values, function(v:Dynamic) {
			if (Lambda.indexOf(table, v) != -1) ++r;
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
		public static function Children(of:Dynamic, each:Dynamic, ?complete:Dynamic = null):IDice {
			var r:IDice = cast { children:[] };
			var l:Int = 0;
			var c:Element;
			if (of != null) {
				if (Std.is(of, IDisplay)) of = of.element;
				Count(0, of.childNodes.length, function(i:Int) {
					c = cast of.childNodes.item(i);
					r.children[l] = c;
					return each(c, i);
				}, complete);
			}
			return r;
		}
	
	#end
	
}