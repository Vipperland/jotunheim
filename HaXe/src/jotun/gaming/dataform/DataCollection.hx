package jotun.gaming.dataform;
import jotun.errors.Error;
import jotun.serial.Packager;
import jotun.tools.Key;
import jotun.utils.Dice;
#if js
	import js.Syntax;
#elseif php
	import php.Syntax;
#end

/**
 * ...
 * @author Rim Project
 */
@:expose("DataCollection")
class DataCollection {
	
	public static var BLOCK_SIZE:Int = 64;
	
	public static var ID_SIZE:Int = 32;
	
	private static var _dictio:Dynamic = {};
	
	public static function map(o:Dynamic, name:String, props:Array<String>):Void {
		Reflect.setField(_dictio, name, {'c':o == null ? DataObject : o, p:props});
	}
	
	public static function construct(name:String, r:Array<String>):DataObject {
		var o:DataObject = null;
		if (Reflect.hasField(_dictio, name)){
			var O:Dynamic = Reflect.field(_dictio, name);
			o = Syntax.construct(O.c, name, O.p);
		}
		if (o != null){
			if (r.length == 3){
				o.id = r[1];
				o.merge(r[2]);
			}else if (r.length == 2){
				o.id = Key.GEN(ID_SIZE);
				o.merge(r[1]);
			}
		}
		return o;
	}
	
	public static function properties(name:String):Array<String> {
		return Reflect.hasField(_dictio, name) ? Reflect.field(_dictio, name).p : null;
	}
	
	private var _list:Dynamic;
	
	private function _getOrCreate(name:String):DataList {
		var list:DataList = Reflect.field(_list, name);
		if (list == null){
			list = new DataList(name);
			Reflect.setField(_list, name, list);
		}
		return list;
	}
	
	public function new() {
		_list = {};
	}
	
	/**
	   
	   @param	o
	   @return
	**/
	public function add(o:DataObject):Bool {
		var name:String = o.getName();
		if(name != null && name.length > 0){
			var list:DataList = _getOrCreate(name);
			// Create an unique ID
			while (o.id == null && !list.exists(o.id)){
				o.id = Key.GEN(ID_SIZE);
			}
			list.insert(o);
		}else{
			o = null;
		}
		return o != null;
	}
	
	/**
	   
	   @param	o
	   @return
	**/
	public function exists(o:DataObject):Bool {
		return false;
	}
	
	/**
	   
	   @param	data
	**/
	public function parse(data:String):Int {
		if (data.substr(0, 1) == '#'){
			data = data.split('\n').join('');
			var key:String = data.substring(1, 33);
			var e:Int = Std.parseInt(data.substring(33, 34));
			data = data.substring(34, data.length);
			if (Packager.md5Encode(data) != key){
				throw new Error(1, 'Invalid data object');
			}
			while (e > 0){
				data += '=';
				--e;
			}
			data = Packager.decodeBase64(data);
		}
		var len:Int = 0;
		var i:Array<String> = data.split('\n');
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
							if (l.insert(o)){
								len += 1;
							}
						}
					}
					case '-' : {
						
					}
					default : {
						o = construct(v, r);
						if (exists(o)){
							
						}else if (add(o)){
							if (l != null){
								l.refresh();
							}
							l = o;
							len += 1;
						}else{
							l = null;
						}
					}
				}
			}
		});
		if (l != null){
			l.refresh();
		}
		return len;
	}
	
	private function _encode(r:String):String {
		var r:String = Packager.encodeBase64(r);
		var i:Int = 0;
		while (r.substr(r.length - 1, 1) == '='){
			r = r.substring(0, r.length - 1);
			++i;
		}
		r = '#' + Packager.md5Encode(r) + i + r;
		i = 0;
		var nr:String = '';
		var len:Int = r.length;
		while (i < len){
			nr += r.substr(i, BLOCK_SIZE) + '\n';
			i += BLOCK_SIZE;
		}
		return nr.substring(0, nr.length-1);
	}
	
	private function _toString(?encode:Bool, ?changes:Bool, ?name:String):String {
		var r:String = '';
		Dice.Values(_list, function(list:DataList){
			if (name == null || list.is(name)){
				r += list.toString(changes);
			}
		});
		if (encode){
			r = _encode(r);
		}
		return r;
	}
	
	/**
	   
	   @return
	**/
	public function toString(?encode:Bool, ?name:String):String {
		return _toString(encode, false, name);
	}
	
	/**
	   
	   @return
	**/
	public function toChangedString(?encode:Bool, ?name:String):String {
		return _toString(encode, true, name);
	}
	
	public function getList(?name:String):DataList {
		if (name != null){
			return Reflect.field(_list, name);
		}else{
			return _list;
		}
	}
	
	public function each(handler:DataList->Bool):Void {
		Dice.Values(_list, handler);
	}
	
	public function refresh(?name:String):Void {
		Dice.Values(_list, function(list:DataList){
			if (name == null || list.is(name)){
				list.refresh();
			}
		});
	}
	
	public function commit():Void {
		Dice.Values(_list, function(list:DataList){
			list.commit();
		});
	}
	
	public function clone():DataCollection {
		var o:DataCollection = new DataCollection();
		o.parse(toString(false));
		return o;
	}
	
}