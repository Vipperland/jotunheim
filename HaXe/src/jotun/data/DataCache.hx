package jotun.data;
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
	import jotun.net.Header;
#end
import haxe.Log;
import jotun.serial.JsonTool;
import jotun.tools.Flag;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.serial.IOTools;


/**
 * ...
 * @author Rafael Moreira
 */
@:expose("jtn.data.DataCache")
class DataCache implements IDataCache {
	
	private var _DB:Dynamic;
	
	public var _path:String;
	
	public var _name:String;
	
	private var _expire:Int;
	
	private var _loaded:Bool;
	
	private var _base64:Bool;
	
	private var __time__:Float;
	
	public var data(get, null):Dynamic;
	
	private function get_data():Dynamic {
		return _DB;
	}
	
	private function _now():Float {
		return Date.now().getTime();
	}
	
	public function new(?name:String, ?path:String, ?expire:Int = 0, ?base64:Bool) {
		_name = name;
		_path = path;
		_expire = expire;
		_base64 = base64;
		clear();
	} 
	
	#if php
		
		private var _validated:Bool = false;
		
		private function _checkPath() {
			var p:Array<String> = _path.split("/");
			if (p.length > 0) {
				var t:Array<String> = [];
				if (p[0] == "") t[0] = "/";
				else if (p[0] == ".") t[0] = "./";
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
			_name = _path + "/" + _name;
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
			if (p != '__time__') Reflect.deleteField(_DB, p);
		}else {
			_DB = { };
			if (_expire > 0) _DB.__time__ = _now();
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
			if (Std.is(t, Array)) return set(p, t.concat(v));
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
			return Reflect.hasField(_DB, name);
		}else {
			return _loaded;
		}
	}
	
	public function save():DataCache {
		#if js
			var data:String = IOTools.encodeBase64(_DB);
			Cookie.set(_name, data, _expire > 0 ? _expire : 2592000, _path);
		#elseif php
			var data:String = _base64 ? IOTools.encodeBase64(_DB) : json(false);
			if (!_validated) _checkPath();
			if(_expire > 0) _sign(true);
			File.saveContent(_name, data);
			if(_expire > 0) _sign(false);
		#end
		return this;
	}
	
	private function _sign(add:Bool) {
		if (add) {
			_DB.__time__ = _now();
		}else {
			__time__ = _expire > 0 ? _DB.__time__ : 0;
			Reflect.deleteField(_DB, '__time__');
		}
	}
	
	public function load():Bool {
		_DB = null;
		#if js
			if (Cookie.exists(_name)) {
				var a:Dynamic = Base64.decode(Cookie.get(_name));
				trace(a);
				_DB = IOTools.decodeBase64(Cookie.get(_name), true);
				trace(_DB);
			}
		#elseif php
			if (!_validated) _checkPath();
			if (FileSystem.exists(_name)) {
				var c:String =  File.getContent(_name);
				_DB = _base64 ? IOTools.decodeBase64(c, true) : Json.parse(c);
			}
		#end
		if (_DB == null || (_expire != 0 && (_DB.__time__ == null || _now() - _DB.__time__ >= _expire))) {
			_DB = { };
			_loaded = false;
		}else {
			_sign(false);
			_loaded = true;
		}
		return _loaded;
	}
	
	public function refresh():DataCache {
		__time__ = _now();
		return this;
	}
	
	public function json(?print:Bool):String {
		var result:String = JsonTool.stringify(_DB, null, " ");
		if (print) #if php Lib.print(result); #elseif js if (print) Log.trace(result); #end
		return result;
	}
	
	public function base64(?print:Bool):String {
		var result:String = IOTools.encodeBase64(_DB);
		if (print) #if php Lib.print(result); #elseif js if (print) Log.trace(result); #end
		return result;
	}
	
}