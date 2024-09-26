package jotun.utils;
import haxe.Rest;
import haxe.macro.Expr;
#if js
	import js.Syntax;
#elseif php 
	import php.Syntax;
#end

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("Jtn.Recycler")
class Recycler {
	
	private var _cache:Array<Dynamic> = [];
	
	private var _Object:Dynamic;
	
	public function new(Object:Dynamic):Void {
		_Object = Object;
	}
	
	public function drop(object:IRecyclable):Void {
		if(!object.isDisposed){
			object.dispose();
		}
		_cache[_cache.length] = object;
	}
	
	public function get(...rest:Dynamic):Dynamic {
		var object:IRecyclable = null;
		if(_cache.length == 0){
			object = Syntax.construct(_Object, rest);
		}else{
			object = _cache.pop();
			Reflect.callMethod(object, object.build, rest);
		}
		return object;
	}
	
}