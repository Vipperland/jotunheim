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
import sirius.tools.Utils;
import sirius.utils.Dice;


/**
 * ...
 * @author Rafael Moreira
 */
class DataCache implements IDataCache {
	
	private var _DB:Dynamic;
	
	public var _path:String;
	
	public var _name:String;
	
	private var _expire:Int;
	
	private function _now():Float {
		return Date.now().getTime();
	}
	
	#if js
		
		public function new(?name:String, ?path:String, ?expire:Int) {
			_name = name;
			_expire = expire;
			_path = path;
			clear();
		} 
		
		public function json():String {
			return Json.stringify(_DB);
		}
		
	#elseif php
		
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
			_name = _path + "/" + _name + ".cache";
		}
		
		public function new(name:String, path:String, ?expire:Int = 0) {
			_name = name;
			_expire = expire;
			_path = path;
			clear();
		}
		
		public function json(?print:Bool):String {
			var result:String = untyped __php__("json_encode($this,256)");
			if (print) Lib.print(result);
			return result;
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
		if (Std.is(v, Array) && Reflect.hasField(_DB, _name)) {
			var t:Dynamic = get(p);
			if (Std.is(t, Array)) {
				Reflect.setField(_DB, p, t.concat(v));
				return this;
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
	
	public function exists(name:String):Bool {
		return Reflect.hasField(_DB, _name);
	}
	
	public function save():DataCache {
		#if js
			Cookie.set(_name, base64(), 0, _path);
		#elseif php
			if (!_validated) _checkPath();
			_DB.__exists__ = true;
			File.saveContent(_name, base64());
		#end
		return this;
	}
	
	public function load():IDataCache {
		#if js
			if (Cookie.exists(_name)) {
				var s:String = Cookie.get(_name);
				_DB = (s != null && s.length > 1) ? Json.parse(Base64.decode(s).toString()) : null;
				
			}
		#elseif php
			if (!_validated) _checkPath();
			if (FileSystem.exists(_name)) {
				var c:String =  File.getContent(_name);
				if(c.length > 0) c = Base64.decode(c).toString();
				if (c != null && c.length > 1) _DB = Json.parse(c);
			}
		#end
		if (_DB.__time__ == null || _now() - _DB.__time__ >= _expire) _DB = { __time__ : _now(), __exists__:false };
		return this;
	}
	
	public function refresh():DataCache {
		if(_DB.__exists__) _DB.__time__ = _now();
		return this;
	}
	
	public function getData():Dynamic {
		return _DB;
	}
	
	public function base64():String {
		return Base64.encode(Bytes.ofString(json()));
	}
	
	public function isExpired():Bool {
		return _DB != null && _DB.__exists__ == true;
	}
	
}