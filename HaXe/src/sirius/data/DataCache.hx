package sirius.data;
import haxe.crypto.Base64;
import haxe.io.Bytes;
import haxe.Json;
#if js
	import js.Cookie;
#elseif php
	import php.Lib;
	import sys.FileSystem;
	import sys.io.File;
	import sys.io.FileInput;
#end
import haxe.Log;
import sirius.tools.Utils;
import sirius.utils.Dice;
import sirius.utils.Criptog;


/**
 * ...
 * @author Rafael Moreira
 */
class DataCache implements IDataCache {
	
	private var _DB:Dynamic;
	
	public var _path:String;
	
	public var _name:String;
	
	private var _expire:Int;
	
	private var _loaded:Bool;
	
	private var __time__:Float;
	
	private function _now():Float {
		return Date.now().getTime();
	}
	
	public function new(?name:String, ?path:String, ?expire:Int = 0) {
		_name = name;
		_path = path;
		_expire = expire;
		clear();
	} 
	
	#if php
		
		private var _validated:Bool = false;
		
		private function _checkPath() {
			var p:Array<String> = _path.split("\\").join("/").split("/");
			if (p.length > 0) {
				var t:Array<String> = [];
				Dice.Values(p, function(v:String) {
					if (Utils.isValid(v)) {
						t[t.length] = v;
						v = t.join("/");
						if (!FileSystem.exists(v)) FileSystem.createDirectory(v);
						return false;
					}
					return true;
				});
			}
			_name = _path + "/" + _name + ".sru.cache";
			_validated = true;
		}
		
		private function _fixData():Dynamic {
			var data:Dynamic = { };
			_fixParams(_DB, data);
			Lib.dump(data);
			return data;
		}
		
		function _fixParams(from:Dynamic, data:Dynamic) {
			var i:Dynamic;
			Dice.All(from, function(p:Dynamic, v:Dynamic) {
				if (Std.is(v, Float) || Std.is(v, Bool) || Std.is(v, String) || Std.is(v, Int)) { 
					Reflect.setField(data, p, v);	
				}else if (Std.is(v, Array)) {
					v = Lib.toPhpArray(v);	
				}else if (Std.is(v, Dynamic)) { 
					v = Lib.associativeArrayOfObject(v);	
				}
				Reflect.setField(data, p, v);
			});
		}
		
	#end
	
	public function clear(?p:String):IDataCache {
		if (p != null) {
			Reflect.deleteField(_DB, p);
		}else if (p != '__time__'){
			_DB = { '__time__':_now() };
			#if js
				Cookie.remove(_name, _path);
			#elseif php
				FileSystem.deleteFile(_path);
			#end
		}
		return this;
	}
	
	public function set(p:String, v:Dynamic):IDataCache {
		Reflect.setField(_DB, p, v);
		return this;
	}
	
	public function merge(p:String, v:Dynamic):IDataCache {
		if (Std.is(v, Array) && Reflect.hasField(_DB, _name)) {
			var t:Array<Dynamic> = get(p);
			if (Std.is(t, Array)) {
				return set(p, t.concat(v));
			}
		}
		Reflect.setField(_DB, p, v);
		return this;
	}
	
	public function get(?id:String):Dynamic {
		var d:Dynamic = id != null ? Reflect.field(_DB, id) : null;
		if (d == null) {
			d = { };
			set(id, d);
		}
		return d;
	}
	
	public function exists(?name:String):Bool {
		if (name != null) {
			return Reflect.hasField(_DB, _name);
		}else {
			return _loaded;
		}
	}
	
	public function save():DataCache {
		#if js
			Cookie.set(_name, Criptog.encodeBase64(_DB), 0, _path);
		#elseif php
			if (!_validated) _checkPath();
			_sign(true);
			File.saveContent(_name, Criptog.encodeBase64(_DB));
			_sign(false);
		#end
		return this;
	}
	
	private function _sign(add:Bool) {
		if (add) {
			_DB.__time__ = _now();
		}else {
			__time__ = _DB.__time__;
			Reflect.deleteField(_DB, '__time__');
		}
	}
	
	public function load():IDataCache {
		_DB = null;
		#if js
			if (Cookie.exists(_name)) {
				_DB = Criptog.decodeBase64(Cookie.get(_name), true);
			}
		#elseif php
			if (!_validated) _checkPath();
			if (FileSystem.exists(_name)) {
				var c:String =  File.getContent(_name);
				_DB = Criptog.decodeBase64(c, true);
			}
		#end
		if (_DB == null || (_expire != 0 && (_DB.__time__ == null || _now() - _DB.__time__ >= _expire))) {
			_DB = { };
			_loaded = false;
		}else {
			_sign(false);
			_loaded = true;
		}
		return this;
	}
	
	public function refresh():DataCache {
		__time__ = _now();
		return this;
	}
	
	public function getData():Dynamic {
		return _DB;
	}
	
	public function json(?print:Bool):String {
		var result:String = Json.stringify(_DB);
		if (print) #if php Lib.print(result); #elseif js if (print) Log.trace(result); #end
		return result;
	}
	
	public function base64(?print:Bool):String {
		var result:String = Criptog.encodeBase64(_DB);
		if (print) #if php Lib.print(result); #elseif js if (print) Log.trace(result); #end
		return result;
	}
	
}