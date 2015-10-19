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
	
	public function new() {
		
	}
	
	/**
	 * Check if a plugins exists
	 * @param	module
	 * @return
	 */
	public function exists(module:String):Bool {
		return Reflect.hasField(CACHE, module);
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
		if(sur.length > 1){
			Dice.All(sur, function(p:Int, v:String) {
				if(p > 0){
					var i:Int = v.indexOf("}]");
					if (i != -1) {
						var mod:IMod = Json.parse("{" + v.substr(0, i) + "}");
						if (mod.name == null) mod.name = file;
						Sirius.log("Sirius->ModLib.load[ " + mod.name + " ]", 10, 1);
						var end:Int = v.indexOf("/EOF;");
						content = v.substring(i + 2, end == -1 ? v.length : end);
						if (mod.require != null) {
							var dependencies:Array<String> = mod.require.split(";");
							Sirius.log("	Sirius->ModLib->dependency::check[ FOR " + mod.name + " ]", 10, 1);
							Dice.Values(dependencies, function(v:String) {
								var set:String = Reflect.field(CACHE, v.toLowerCase());
								if (set == null) {
									Sirius.log("		Sirius->ModLib->dependency::status[ MISSING " + v + " ]", 10, 2);
								}else {
									Sirius.log("		Sirius->ModLib->dependency::status[ OK " + v + " ]", 10, 1);
									content = content.split("<import " + v + "/>").join(set);
								}
							});
						}
						#if js
							// ============================= JS ONLY =============================
							if (mod.type != null) {
								if (mod.type == 'cssx') {
									Automator.build(content);
									Sirius.log("Sirius->ModLib.build[ " + mod.name + " CSX/AUTOMATOR ]", 10, 1);
									content = null;
								}else if (mod.type == 'style' || mod.type == 'css') {
									Sirius.document.head.addScript(content);
									Sirius.log("Sirius->ModLib.build[ " + mod.name + " CSS/SCRIPT ]", 10, 1);
									content = null;
								}else if (mod.type == 'script' || mod.type == 'js') {
									Sirius.document.head.addScript(content);
									Sirius.log("Sirius->ModLib.build[ " + mod.name + " JS/SCRIPT ]", 10, 1);
									content = null;
								}
							}
							if (mod.target != null) {
								var t:IDisplay = Sirius.one(mod.target);
								if (t != null) {
									t.addChild(build(mod.name));
								}
							}
							// ***
						#end
						if (content != null) Reflect.setField(CACHE, mod.name.toLowerCase(), content);
					}else {
						Sirius.log("	Sirius->ModLib::status [ MISSING MODULE END IN " + file + "("  + v.substr(0, 15) + "...) ]", 10, 3);
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
				Lib.print(get(name, data));
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
			if (each != null && Std.is(data, Array)) {
				var d:IDisplay = new Div();
				Dice.Values(data, function(v:Dynamic) {
					v = new Display().build(get(module, v));
					v = each(v);
					if(v != null && Std.is(v, IDisplay)) d.addChild(v);
				});
				return d;
			}else {
				return new Display().build(get(module, data));
			}
		}
		
		// ***
		
	#end;
	
}