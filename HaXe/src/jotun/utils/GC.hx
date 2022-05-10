package jotun.utils;
import jotun.dom.IDisplay;

/**
 * ...
 * @author 
 */
class GC {

	static public var pool:Dynamic = {};
	
	static public function clear(force:Bool):Void {
		if (force) {
			pool ={};
		}else{
			Dice.Values(pool, function(v:IDisplay) {
				var id:UInt = v.id();
				if (Jotun.one('[jtn-id=' + id + ']') == null) {
					Reflect.deleteField(pool, id + '');
				}
			});
		}
	}
	
	static public function put(o:IDisplay):Void {
		Reflect.setField(pool, o.id()+'', o);
	}
	
	static public function rem(id:Int):Void {
		Reflect.deleteField(pool, id + '');
	}
	
}