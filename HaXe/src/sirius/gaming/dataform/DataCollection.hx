package sirius.gaming.dataform;
import sirius.utils.Dice;

/**
 * ...
 * @author Rim Project
 */
class DataCollection {
	
	private static var _dictio:Dynamic = {};
	
	public static function register(o:Dynamic, name:String, props:Array<String>):Void {
		Reflect.setField(_dictio, name, {'c':o, n:name, p:props});
	}
	
	public static function construct(name:String, r:Array<String>):DataObject {
		var o:DataObject = null;
		if (Reflect.hasField(_dictio, name)){
			var d__:Dynamic = Reflect.field(_dictio, name);
			var C__:Dynamic = d__.c;
			#if js
				o = untyped __js__("new C__(d__.n,d__.p)");
			#elseif php
				o = untyped __php__("new C__(d__.n,d__.p)");
			#end
		}
		if (o != null){
			if (r.length == 3){
				o.id = r[1];
				o.merge(r[2]);
			}else if (r.length == 2){
				o.merge(r[1]);
			}
		}
		return o;
	}
	
	private var _list:Dynamic;
	
	public function new() {
		_list = {};
	}
	
	/**
	   
	   @param	o
	   @return
	**/
	public function add(o:DataObject):Bool {
		var ion:String = o.getION();
		if(ion != null && ion.length > 0){
			if (!Reflect.hasField(_list, ion)){
				Reflect.setField(_list, ion, {});
			}
			if (o.id != null){
				var ls:Dynamic = Reflect.field(_list, ion);
				Reflect.setField(ls, o.id, o);
			}else{
				o = null;
			}
		}else{
			o = null;
		}
		return o != null;
	}
	
	/**
	   
	   @param	data
	**/
	public function parse(data:String):Int {
		var len:Int = 0;
		var i:Array<String> = data.split('\r');
		var l:DataObject = null;
		Dice.Values(i, function(v:String){
			var r:Array<String> = v.split(' ');
			if (r.length > 0){
				v = r[0];
				var cmd:String = v.substring(0, 1);
				var o:DataObject = null;
				switch(cmd){
					case '@' : {
						if (l != null){
							v = v.substring(1, v.length);
							o = construct(v, r);
							if (l.insert(v, o)){
								len += 1;
							}
						}
					}
					default : {
						o = construct(v, r);
						if (add(o)){
							l = o;
							len += 1;
						}else{
							l = null;
						}
					}
				}
			}
		});
		return len;
	}
	
	/**
	   
	   @return
	**/
	public function stringify(?name:String):String {
		var r:String = '';
		Dice.Values(getList(name), function(v:Dynamic){
			Dice.Values(v, function(v1:DataObject){
				r += (r.length > 0 ? '\r' : '') + v1.stringify();
			});
		});
		return r;
	}
	
	public function getList(?name:String):Dynamic {
		if (name != null){
			return Reflect.field(_list, name);
		}else{
			return _list;
		}
	}
	
}