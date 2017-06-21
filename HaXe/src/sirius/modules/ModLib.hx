package sirius.modules;
import haxe.Json;
import sirius.utils.Dice;
import sirius.utils.Filler;
import sirius.Sirius;

#if js
	import sirius.css.Automator;
	import sirius.dom.IDisplay;
	import sirius.dom.Display;
	import sirius.dom.Div;
	import sirius.dom.Script;
#elseif php
	import php.Lib;
	import sys.FileSystem;
	import sys.io.File;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose('sru.modules.ModLib')
class ModLib {
	
	private static var CACHE:Dynamic = { };
	
	private var _predata:Array<String->Dynamic->Dynamic>;
	
	private function _sanitize(name:String, data:Dynamic):Dynamic {
		Dice.Values(_predata, function(v:String->Dynamic->Dynamic) { data = v(name, data); } );
		return data;
	}
	
	public function new() {
		_predata = [];
	}
	
	/**
	 * Pre filter input data
	 * @param	handler
	 */
	public function onModuleRequest(handler:String->Dynamic->Dynamic):Void {
		if (Lambda.indexOf(_predata, handler) == -1)
			_predata[_predata.length] = handler;
	}
	
	/**
	 * Check if a plugins exists
	 * @param	module
	 * @return
	 */
	public function exists(module:String):Bool {
		module = module.toLowerCase();
		return Reflect.hasField(CACHE, module);
	}
	
	public function remove(module:String):Void {
		if (exists(module)){
			Reflect.deleteField(CACHE, module);
		}
	}
	
	/**
	 * Register a module
	 * @param	file
	 * @param	content
	 */
	public function register(file:String, content:String):Void {
		content = content.split("[module:{").join("[!MOD!]");
		content = content.split("[Module:{").join("[!MOD!]");
		var sur:Array<String> = content.split("[!MOD!]");
		if (sur.length > 1) {
			Sirius.log("ModLib => PARSING " + file, 1);
			Dice.All(sur, function(p:Int, v:String) {
				if(p > 0){
					var i:Int = v.indexOf("}]");
					if (i != -1) {
						var mod:IMod = Json.parse("{" + v.substr(0, i) + "}");
						var path:String = file;
						if (mod.name == null){
							mod.name = file;
						}else{
							path += '#' + mod.name;
							Sirius.log("		ModLib => NAME " + path, 1);
						}
						if (exists(mod.name))
							Sirius.log("	ModLib => OVERRIDE " + path, 2);
						var end:Int = v.indexOf("/EOF;");
						content = v.substring(i + 2, end == -1 ? v.length : end);
						if (mod.type == null || mod.type == 'null' || mod.type == "html") {
							content = content.split('\r\n').join('\r').split('\n').join('\r');
							while (content.substr(0, 1) == '\r')
								content = content.substring(1, content.length);
							while (content.substr( -1) == '\r')
								content = content.substring(0, content.length - 1);
						}
						if (mod.require != null) {
							var dependencies:Array<String> = mod.require.split(";");
							Sirius.log("	ModLib => " + path + " VERIFYING...", 1);
							Dice.Values(dependencies, function(v:String) {
								var set:String = Reflect.field(CACHE, v.toLowerCase());
								if (set == null) 
									Sirius.log("		ModLib => REQUIRED " + v, 2);
								else
									content = content.split("{{@include:" + v + "}}").join(set);
							});
						}
						if (mod.data != null){
							content = Filler.to(content, mod.data);
						}
						if (mod.wrap != null){
							content = content.split('\r\n').join(mod.wrap).split('\n').join(mod.wrap).split('\r').join(mod.wrap);
						}
						#if js
							// ============================= JS ONLY =============================
							if (mod.type != null) {
								if (mod.type == 'cssx') {
									Automator.build(content);
									content = '';
								}else if (mod.type == 'style' || mod.type == 'css' || mod.type == 'script' || mod.type == 'javascript') {
									Sirius.document.head.bind(content, mod.type, mod.id);
									content = '';
								}
							}
							if (mod.target != null) {
								var t:IDisplay = Sirius.one(mod.target);
								if (t != null)
									t.addChild(build(mod.name));
							}
							// ***
						#end
						var n:String = mod.name.toLowerCase();
						Reflect.setField(CACHE, n, content);
						Reflect.setField(CACHE, '@' + n, path);
					}else {
						Sirius.log("	ModLib => CONFIG ERROR " + file + "("  + v.substr(0, 15), 3) + "...)";
					}
			}
			});
		}else {
			Reflect.setField(CACHE, file.toLowerCase(), content);
		}
	}
	
	/**
	 * Get module content
	 * @param	name
	 * @param	data
	 * @return
	 */
	public function get(name:String, ?data:Dynamic):String {
		name = name.toLowerCase();
		if (!exists(name)) return "<span style='color:#ff0000;font-weight:bold;'>Undefined [Module:" + name + "]</span><br/>";
		var content:String = Reflect.field(CACHE, name);
		data = _sanitize(name, data);
		return (data != null) ? Filler.to(content, data) : content;

	}
	
	/**
	 * Write a content in module
	 * @param	module
	 * @param	data
	 * @param	sufix
	 * @return
	 */
	public function fill(module:String, data:Dynamic, ?sufix:String = null):String {
		return Filler.to(get(module), data, sufix);
	}
	
	#if php
		
		// ============================= PHP ONLY =============================
		/**
		 * Cache a file to post write
		 * @param	file
		 * @return
		 */
		public function prepare(file:String):Bool {
			if (file != null && FileSystem.exists(file)) {
				register(file, File.getContent(file));
				return true;
			}
			return false;
		}
		
		/**
		 * Write module and fill with custom data in the flow
		 * @param	name
		 * @param	data
		 * @param	repeat
		 * @param	sufix
		 */
		public function print(name:String, ?data:Dynamic, ?repeat:Bool, ?sufix:String = null):Void {
			if (repeat) {
				var module:String = get(name);
				Dice.Values(data, function(v:Dynamic) {
					Lib.print(Filler.to(module, v, sufix));
				});
			}else {
				Lib.print(fill(name, data, sufix));
				
			}
		}
		
	#elseif js
		
		// ============================= JS ONLY =============================
		/**
		 * Write module in a DOM element
		 * @param	module
		 * @param	data
		 * @return
		 */
		public function build(module:String, ?data:Dynamic, ?each:IDisplay->IDisplay = null):IDisplay {
			var d:IDisplay = null;
			var signature:String = Reflect.field(CACHE, '@' + module.toLowerCase());
			if (each != null && Std.is(data, Array)) {
				d = new Div();
				Dice.Values(data, function(v:Dynamic) {
					v = new Display().write(get(module, v));
					v = each(v);
					if (v != null && Std.is(v, IDisplay)) {
						d.attribute('sru-mod', signature);
						d.addChild(v);
					}
				});
			}else {
				d = new Display().write(get(module, data));
				d.children().attribute('sru-mod', signature);
			}
			return d;
		}
		
		public function buildIn(module:String, target:String, ?data:Dynamic, ?each:IDisplay->IDisplay = null):IDisplay {
			var display:IDisplay = Sirius.one(target);
			if (display != null)
				display.addChild(build(module, data, each));
			return display;
		}
		
	#end;
	
}