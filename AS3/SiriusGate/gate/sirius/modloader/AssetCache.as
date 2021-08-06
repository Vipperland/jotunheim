package gate.sirius.modloader {
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.system.ApplicationDomain;
	import gate.sirius.log.ULog;
	import gate.sirius.modloader.data.Mod;
	import gate.sirius.utils.Explorer;
	
	
	/**
	 * ...
	 * @author Rafael moreira
	 */
	public class AssetCache {
		
		private var _cached:Object;
		
		private var _textures:Object;
		
		private var _routines:Object;
		
		private var _swf:Explorer;
		
		private var _avoidDomain:Array;
		
		private var _base_matrix:Matrix;
		
		private var _uid:String;
		
		private function _addDefinition(mod:String, name:String, definition:Class, bitmap:BitmapData):Def {
			var route:String = _routines[name] || name;
			var def:Def = _cached[route] as Def;
			if (!def) {
				//ULog.GATE.pushMessage("Registering access:" + name + " to route:" + route);
				def = new Def(mod, name, definition, bitmap);
				_cached[name] = def;
			} else {
				ULog.GATE.pushWarning("Overriding resource @" + def.n + "&lt;-" + mod + " asset:" + name);
				def.w(mod, definition, bitmap);
			}
			return def;
		}
		
		public function AssetCache() {
			_cached = {};
			_textures = {};
			_routines = {};
			_base_matrix = new Matrix(1, 0, 0, 1, 0, 0);
			_swf = new Explorer();
			_uid = '$_'+new Date().getTime();
		}
		
		public function route(mod:Mod, definition:String, target:String):void {
			if (!mod){
				return;
			}
			definition = mod.id + "=" + definition;
			var def:Def = _getDefinition(definition);
			if (def) {
				if (def.m == mod.id) {
					_routines[target] = _routines[definition];
					delete _routines[definition];
					ULog.GATE.pushMessage("Routing " + definition + " to " + target);
				} else {
					ULog.GATE.pushWarning("Can't route " + definition + " to " + target + ". A mod can only route their our resources.");
				}
			} else {
				_routines[definition] = target;
			}
		}
		
		internal function register(mod:Mod, object:DisplayObject):void {
			var d:Def;
			var fClass:Class;
			var domain:ApplicationDomain = object.loaderInfo.applicationDomain;
			var definitions:Vector.<String> = domain.getQualifiedDefinitionNames();
			var domName:String;
			for each (var def:String in definitions) {
				domName = def.split(".").splice(0, 2).join(".");
				if (_avoidDomain.indexOf(domName) !== -1) {
					continue;
				}
				try {
					fClass = domain.getDefinition(def) as Class;
				} catch (e:Error) {
					fClass = null;
				}
				def = mod.id + "=" + def.split("::").pop();
				if (fClass) {
					d = _addDefinition(mod.id, def, fClass, null);
					if (d.x) {
						ULog.GATE.pushWarning("The mod [" + d.o + ":" + d.n + "] overwrite [" + d.m + ":" + d.n + "]");
					}
				}
			}
		}
		
		internal function registerImage(mod:Mod, name:String, content:BitmapData):void {
			var d:Def = _addDefinition(mod.id, name, null, content.clone());
			content.dispose();
			if (d.x) {
				ULog.GATE.pushWarning("The mod [" + d.o + ":" + d.n + "] overwrite [" + d.m + ":" + d.n + "]");
			}
		}
		
		private function _getDefinition(name:String):Def {
			return _cached[name] as Def;
		}
		
		public function getTexture(name:String):BitmapData {
			var def:Def = _getDefinition(name);
			if (def) {
				if (def.b) {
					return def.b;
				} else if (def.c) {
					return def.create();
				}
			}
			_logMissingAccess("getTexture", name);
			return null;
		}
		
		
		public function getTextures(names:Array):Vector.<BitmapData> {
			var result:Vector.<BitmapData> = new Vector.<BitmapData>();
			for each (var name:String in names) {
				var texture:BitmapData = getTexture(name);
				if (texture) {
					result[result.length] = texture;
				}
			}
			return result;
		}
		
		
		public function getInstance(name:String):* {
			var def:Def = _getDefinition(name);
			var CLASS:Class = def ? def.c : null;
			if (CLASS) {
				return new CLASS();
			}
			_logMissingAccess("getInstance", name);
			return null;
		}
		
		
		public function getDefinition(name:String):Class {
			var def:Def = _getDefinition(name);
			if (def) {
				return def.c;
			} else {
				_logMissingAccess("getDefinition", name);
			}
			return null;
		}
		
		
		public function avoidDomains(skipDomains:Array):void {
			_avoidDomain = skipDomains;
		}
		
		
		private function _logMissingAccess(type:String, name:String):void {
			ULog.GATE.pushWarning("Access to undefined " + type + "(" + name + ")");
		}
	
	
	}
}
import flash.display.BitmapData;


class Def {
	
	public var b:BitmapData;
	
	public var m:String;
	
	public var n:String;
	
	public var c:Class;
	
	public var o:String;
	
	
	public function Def(m:String, n:String, c:Class, b:BitmapData) {
		this.b = b;
		this.c = c;
		this.n = n;
		this.m = m;
	}
	
	
	public function w(m:String, c:Class, b:BitmapData):void {
		this.o = m;
		this.c = c;
		this.b = b;
	}
	
	
	public function create():BitmapData {
		this.b = new c();
		return this.b;
	}
	
	
	public function get x():Boolean {
		return this.m !== null && this.o !== null && this.m !== this.o;
	}
}