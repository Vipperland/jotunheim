package jotun.utils;
import haxe.ds.ArraySort;
import jotun.tools.Key;
import jotun.tools.Utils;
import jotun.utils.IDiceRoll;

#if php
	import php.Lib;
	import php.NativeArray;
#elseif js
	import js.html.Element;
	import js.html.Node;
	import jotun.dom.IDisplay;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Dice")
class Dice {
	
	/**
	 * For each object Value and parameter, call each(paramName,paramValue)
	 * @param	q		Target object
	 * @param	each		Parameter and Value handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail param and value
	 * @return	Last value
	 */
	public static function All(q:Dynamic, each:Dynamic):IDiceRoll {
		var v:Dynamic = null;
		var p:Dynamic = null;
		var i:Bool = true;
		var k:UInt = 0;
		if (q != null) {
			#if php
				// ==== Workaround with PHP Arrays
				if (Std.isOfType(q, NativeArray) || Std.isOfType(q, Array)) {
					q = Lib.objectOfAssociativeArray(q);
				}
			#end
			for (p in Reflect.fields(q)) {
				v = Reflect.field(q, p);
				#if php
					// ==== Skip object methods in PHP object
					if (Reflect.isFunction(v)) {
						continue;
					}
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
		var r:IDiceRoll = cast {
			param:p,
			value:v, 
			completed:i,
			object:q, 
			keys:k 
		};
		return r;
		
	}
	
	/**
	 * For each object Param call each(param)
	 * @param	q		Target object
	 * @param	each		Parameter handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail parameter
	 */
	public static function Params(q:Dynamic, each:Dynamic):IDiceRoll {
		return All(q, function(p:Dynamic, v:Dynamic) { return each(p); } );
	}
	
	/**
	 * For each object Value call each(value)
	 * @param	q		Target object
	 * @param	each		Value handler, return true to stop propagation
	 */
	public static function Values(q:Dynamic, each:Dynamic):IDiceRoll {
		return All(q, function(p:Dynamic, v:Dynamic) { return each(v); } );
	}
	
	/**
	 * For each object Value call each(value, previous)
	 * @param	q		Target object
	 * @param	each		Value handler, return true to stop propagation
	 * @param	complete	On propagation stop handler, call it with fail value
	 */
	public static function Comparer(q:Dynamic, each:Dynamic->Dynamic->Bool):IDiceRoll {
		var prev:Dynamic = null;
		return All(q, 
			function(p:Dynamic, v:Dynamic) {
				var r = each(v, prev);
				prev = v;
				return r;
			}
		);
	}
	
	/**
	 * Extract properties from a object and return a new object with then
	 * @param	q		A valid object
	 * @param	fields	Named fields to extract
	 * @return
	 */
	public static function Extract(q:Dynamic, fields:Array<String>):Dynamic {
		var r:Dynamic = {};
		Values(fields, function(v:String){ Reflect.setField(r, v, Reflect.field(q, v)); } );
		return r;
	}
	
	/**
	 * Remove NULL elements from Array
	 * @param	q
	 * @param stopOnNull
	 * @return
	 */
	public static function nullSkip(q:Array<Dynamic>, ?stopOnNull:Bool):Array<Dynamic> {
		var r:Array<Dynamic> = [];
		Dice.Values(q, function(v:Dynamic){
			if (v != null && v != ''){
				r.push(v);
				return false;
			}else{
				return stopOnNull;
			}
		});
		return r;
	}
	
	/**
	 * Call a mthod for each null value in array
	 * @param	q
	 * @param	length
	 * @param	handler
	 * @return
	 */
	public static function nullFill(q:Array<Dynamic>, from:Int, length:Int, handler:Int->Dynamic):Array<Dynamic> {
		length = from + length;
		while (from < length){
			if (q[from] == null){
				q[from] = handler(from);
			}
			++from;
		}
		return q;
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
			function(p:Dynamic, v:Dynamic):Void {
				#if js
					js.Syntax.code("v[method].apply({0},{1})", q, args);
				#elseif php
					Reflect.callMethod(v, Reflect.field(v, method), args); 
				#end
			}
		);
	}
	
	/**
	 * Call a method f(a,b,a==b) while (a<b; ++a)
	 * @param	from
	 * @param	to
	 * @param	each
	 * @param	complete
	 */
	public static function Count(from:Dynamic, to:Dynamic, each:Dynamic, ?complete:IDiceRoll->Void = null, ?increment:UInt = 1):IDiceRoll {
		var a:Float = Math.min(from, to);
		var b:Float = Math.max(from, to);
		if (increment == null || increment < 1) increment = 1;
		while (a < b) {
			if (each(cast a, cast b, (a += increment) == b) == true){
				break;
			}
		}
		var c:Bool = a == b;
		var r:IDiceRoll = cast { from:from, to:b, completed:c, value:a-increment };
		if (complete != null) {
			complete(r);
		}
		return r;
	}
	
	/**
	 * Return the first valid value, if no one found, will return an alternative value
	 * @param	from
	 * @param	alt
	 * @return
	 */
	public static function One(from:Dynamic, ?alt:Dynamic):IDiceRoll {
		if (Std.isOfType(from, Array)) {
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
	public static function Match(table:Array<Dynamic>, values:Dynamic, ?limit:Int = 1):Int {
		if (!Std.isOfType(values, Array)) {
			values = [values];
		}
		var r:Int = 0;
		Dice.Values(values, function(v:Dynamic) {
			if (Lambda.indexOf(table, v) != -1) {
				++r;
			}
			return (--limit == 0);
		});
		return r;
	}
	
	/**
	 * 
	 * @param	table
	 * @param	values object(s) to remove or filter f(x)
	 * @param limit optional for filter function, max objects to remove
	 * @return List of removed targets
	 */
	public static function Remove(table:Array<Dynamic>, values:Dynamic, ?limit:Int = -1):Array<Dynamic> {
		var r:Array<Dynamic> = [];
		if(Reflect.isFunction(values)){
			Dice.Values(values, function(v:Dynamic) {
				if (values(v) == true){
					if (table.remove(v)){
						r[r.length] = v;
						if (limit > 0){
							--limit;
						}
					}
				}
				return limit == 0;
			});
		}else{
			if (!Std.isOfType(values, Array)) {
				values = [values];
			}
			Dice.Values(values, function(v:Dynamic) {
				if(table.remove(v)){
					r[r.length] = v;
				}
			});
		}
		return r;
	}
	
	/**
	 * 
	 * @param	table
	 * @param	values
	 */
	public static function Put(table:Array<Dynamic>, values:Dynamic):Void {
		if (!Std.isOfType(values, Array)) {
			values = [values];
		}
		Dice.Values(values, function(v:Dynamic) {
			var i:Int = Lambda.indexOf(table, v);
			if (i == -1) {
				table.push(v);
			}
		});
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
	 * Return a random value from the array
	 * @param	data
	 * @return
	 */
	public static function Random(data:Array<Dynamic>):Dynamic {
		return data[Std.int(Math.random() * data.length)];
	}
	
	/**
	 * Sort all data in a vector, case insensitive, special characteres of a string will be changed for better result (á=a,é=e,ñ=n,...etc)
	 * @param	data
	 * @param	key
	 * @param	numeric
	 * @return
	 */
	public static function Table(data:Array<Dynamic>, ?key:String, ?numeric:Bool = false, ?copy:Bool = false):Dynamic {
		var r:Array<Dynamic> = copy == true ? [].concat(data) : data;
		if (numeric) {
			// INT objA.key < INT objB.key
			if(key != null) {
				ArraySort.sort(r, function (a:Int, b:Int):Int {
					return Reflect.field(a, key) < Reflect.field(b, key) ? -1 : 1;
				});
			}
			// INT a < INT b
			else {
				ArraySort.sort(r, function (a:Int, b:Int):Int {
					return a < b ? -1 : 1;
				});
			}
		}else {
			// try to cache to minimize cpu usage
			var cache:Dynamic = { };
			function cached(q:String):String {
				if(!Reflect.hasField(cache, q)){
					Reflect.setField(cache, q, SearchTag.clear(q));
				}
				return Reflect.field(cache, q);
			}
			// objA.key < objB.key
			if (key != null){
				ArraySort.sort(r, function (a:Dynamic, b:Dynamic):Int {
					return Reflect.compare(cached(Reflect.field(a, key)), cached(Reflect.field(b, key)));
				});
			} 
			// STR a < STR b
			else {
				ArraySort.sort(r, function (a:Dynamic, b:Dynamic):Int {
					return Reflect.compare(cached(a),cached(b));
				});
			}
		}
		return r;
	}
	
	public static function List(data:Array<Dynamic>, ?a:UInt = 0, ?b:UInt):Array<Dynamic>{
		var copy:Array<Dynamic> = [];
		var len:UInt = data.length;
		if (b == null) b = data.length;
		if(a < b){
			while (a < b){
				if (a >= len) {
					break;
				}
				copy[copy.length] = data[a];
				++a;
			}
		}else if(a > b){
			while (a > b){
				if (a < len) {
					copy[copy.length] = data[a];
				}
				--a;
			}
		}
		return copy;
	}
	
	public static function Map(data:Array<Dynamic>, props:Array<String>):Array<Dynamic> {
		var mapped:Array<Dynamic> = [];
		Dice.Values(data, function(v:Dynamic):Void {
			var o:Dynamic = { };
			var f:Bool = false;
			Dice.Values(props, function(v2:String):Void {
				if(Reflect.hasField(v, v2)){
					Reflect.setField(o, v2, Reflect.field(v, v2));
					if (f == false){
						f = true;
						mapped.push(o);
					}
				}
			});
		});
		return mapped;
	}
	
	public static function Blend(objects:Dynamic, into:Dynamic, blendType:Int = 0):Dynamic {
		if (!Std.isOfType(objects, Array)){
			objects = [objects];
		}
		Dice.Values(objects, function(o:Dynamic):Void {
			Dice.All(o, function(p:Dynamic, v:Dynamic):Void {
				switch(blendType){
					case 0 : {
						Reflect.setField(into, p, v);
					}
					case 1 : {
						if (!Reflect.hasField(into, p)){
							Reflect.setField(into, p, v);
						}
					}
					case 2 : {
						if (Reflect.hasField(into, p)){
							var i:Int = 0;
							while(Reflect.hasField(into, p + '_' + i)){
								++i;
							}
							Reflect.setField(into, p, p + '_' + i);
						}else{
							Reflect.setField(into, p, v);
						}
					}
				}
			});
		});
		return into;
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
				if (Std.isOfType(of, IDisplay)) {
					of = of.element;
				}
				Count(0, of.childNodes.length, function(i:Int,j:Int,k:Bool) {
					c = cast of.childNodes.item(i);
					r.children[l] = c;
					return each(c, i);
				}, complete);
			}
			return r;
		}
	
	#end
	
	public var data:Array<Dynamic>;
	
	public var cursor:Int;
	
	public function new(data:Array<Dynamic>){
		this.data = data;
		reset();
	}
	
	public function next():Bool {
		return cursor++ < data.length;
	}
	
	public function current():Dynamic {
		return data[cursor];
	}
	
	public function reset():Void {
		cursor = -1;
	}
	
}