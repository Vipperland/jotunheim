package gate.sirius.modloader.data {
	import flash.display.BitmapData;
	import gate.sirius.file.zip.IZip;
	import gate.sirius.modloader.AssetCache;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class Mod {
		
		private var _path:String;
		
		private var _dependencies:Array;
		
		private var _version:String;
		
		private var _id:String;
		
		public var files:int;
		
		public var loaded:int;
		
		private var _errors:Vector.<String>;
		
		private var _enabled:Boolean;
		
		public var onload:String;
		
		public var initialized:*;
		
		public var compressed:IZip;
		
		private var _info:ModInfo;
		
		private var _cache:AssetCache;
		
		
		public function Mod(id:String, version:String, dependencies:Array, path:String, cache:AssetCache) {
			_cache = cache;
			_path = path;
			_dependencies = dependencies;
			_version = version || "0.0.0";
			_id = id;
			files = 0;
			loaded = 0;
			_errors = new Vector.<String>();
			_info = new ModInfo();
		}
		
		
		private function _getVrs(from:String):int {
			return int(from.split(".").join(""));
		}
		
		
		public function compare(version:String, dependencies:Array, path:String):Boolean {
			var result:Boolean = _getVrs(version) > _getVrs(_version);
			if (result) {
				_path = path;
				_dependencies = dependencies;
			}
			return result;
		}
		
		
		public function setAuthor(value:String):void {
			_info.author = value;
		}
		
		
		public function setDescription(value:String):void {
			_info.description = value;
		}
		
		
		public function get info():ModInfo {
			return _info;
		}
		
		
		public function get path():String {
			return _path;
		}
		
		
		public function get dependencies():Array {
			return _dependencies;
		}
		
		
		public function get version():String {
			return _version;
		}
		
		
		public function get id():String {
			return _id;
		}
		
		
		public function get errors():Vector.<String> {
			return _errors;
		}
		
		
		public function get enabled():Boolean {
			return _enabled;
		}
		
		
		public function get cache():AssetCache {
			return _cache;
		}
		
		
		public function getTexture(name:String):BitmapData {
			return _cache.getTexture(_id + "=" + name);
		}
		
		
		public function getInstance(name:String):* {
			return _cache.getInstance(_id + "=" + name);
		}
		
		
		public function getDefinition(name:String):Class {
			return _cache.getDefinition(_id + "=" + name);
		}
		
		
		public function setStatus(access:Boolean):void {
			_enabled = access;
		}
		
		public function isLoaded():Boolean {
			return files == loaded;
		}
		
	}

}