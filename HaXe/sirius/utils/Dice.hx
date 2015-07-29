package sirius.utils;
import haxe.Log;

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
	 * @param	q			Target object
	 * @param	each		Parameter and Value handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail param and value
	 */
	public static function All(q:Dynamic, each:Dynamic, ?complete:Dynamic = null):Void {
		if (q != null) {
			var v:Dynamic = null;
			var p:Dynamic = null;
			var c:Bool = complete != null;
			var i:Bool = true;
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
			if (c) complete(p, v, i);
		}
	}
	
	/**
	 * For each object Param call each(paraName)
	 * @param	q			Target object
	 * @param	each		Parameter handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail parameter
	 */
	public static function Params(q:Dynamic, each:Dynamic, ?complete:Dynamic = null):Void {
		All(q, 
			function(p:Dynamic, v:Dynamic) { return each(p); }, 
			(complete != null ? function(p:Dynamic, v:Dynamic, i:Bool) { complete(p,i); } : null)
		);
	}
	
	/**
	 * For each object Value call each(value)
	 * @param	q			Target object
	 * @param	each		Value handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail value
	 */
	public static function Values(q:Dynamic, each:Dynamic, ?complete:Dynamic = null):Void {
		All(q, 
			function(p:Dynamic, v:Dynamic) { return each(v); }, 
			(complete != null ? function(p:Dynamic, v:Dynamic, i:Bool) { complete(v,i); } : null)
		);
	}
	
	/**
	 * Execute the method in all object list
	 * @param	q
	 * @param	method
	 * @param	args
	 */
	public static function Call(q:Dynamic, method:String, ?args:Array<Dynamic>):Void {
		if (args == null) args = [];
		All(q,
			function(p:Dynamic, v:Dynamic) {
				Reflect.callMethod(v, Reflect.field(v, method), args); 
			},
			null
		);
	}
	
	/**
	 * Call a method N(a) while (a<b; ++a)
	 * @param	from
	 * @param	to
	 * @param	each
	 * @param	complete
	 */
	public static function Count(from:Dynamic, to:Dynamic, each:Dynamic, ?complete:Dynamic = null):Void {
		var a:Float = Math.min(from, to);
		var b:Float = Math.max(from, to);
		while (a < b) {
			if (each(a++) == true)	break;
		}
		
		if(complete != null) complete(a, a != b);
		
	}
	
	#if !php
		/**
		 * For each Child element in an Object
		 * @param	of				Target container
		 * @param	each			h(e:Element|Node)
		 * @param	complete		c(LastIndex_INT)
		 */
		public static function Children(of:Element, each:Dynamic, ?complete:Dynamic = null):Void {
			Count(0, of.childNodes.length, function(i:Int) {
				return each(of.childNodes.item(i), i);
			}, complete);
		}
	
	#end
	
}