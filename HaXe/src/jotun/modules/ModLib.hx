package jotun.modules;
import haxe.Json;
import jotun.serial.Packager;
import jotun.utils.Dice;
import jotun.utils.Filler;
import jotun.Jotun;

#if js
	import js.html.Image;
	import jotun.dom.Style;
	import jotun.dom.IDisplay;
	import jotun.dom.Display;
	import jotun.dom.Script;
#elseif php
	import php.Lib;
	import sys.FileSystem;
	import sys.io.File;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose('J_ModLib')
class ModLib {
	
	private static var CACHE:Dynamic = { };
	
	private static var DATA:Dynamic = { };
	
	#if js
		
		public var assets:IDisplay = cast new Display();
		
		private var _onMount:Array<IDisplay->String->Void> = [];
		
		private function _afterMount(object:IDisplay, module:String):Void {
			Dice.Values(_onMount, function(v:IDisplay->String->Void) { v(object, module); } );
		}
		
		public function onMount(handler:IDisplay->String->Void):Void {
			if (Lambda.indexOf(_onMount, handler) == -1){
				_onMount[_onMount.length] = handler;
			}
		}
		
	#end
	
	private var _predata:Array<String->Dynamic->Dynamic>;
	
	private function _sanitize(name:String, data:Dynamic):Dynamic {
		Dice.Values(_predata, function(v:String->Dynamic->Dynamic) { data = v(name, data); } );
		return data;
	}
	
	public var data:Dynamic;
	
	public function new() {
		data = DATA;
		_predata = [];
	}
	
	/**
	 * Pre filter input data
	 * @param	handler
	 */
	public function onDataOut(handler:String->Dynamic->Dynamic):Void {
		if (Lambda.indexOf(_predata, handler) == -1){
			_predata[_predata.length] = handler;
		}
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
	public function register(file:String, content:String, ?data:Dynamic):Void {
		content = content.split("[module:{").join("[!MOD!]");
		content = content.split("[Module:{").join("[!MOD!]");
		var sur:Array<String> = content.split("[!MOD!]");
		if (sur.length > 1) {
			Jotun.log("ModLib => PARSING " + file, 1);
			#if js 
				var mountAfter:Array<IMod> = [];
			#end
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
							Jotun.log("		ModLib => NAME " + path, 1);
						}
						if (exists(mod.name)){
							Jotun.log("	ModLib => OVERRIDE " + path, 2);
						}
						var end:Int = v.indexOf("/EOF;");
						content = StringTools.trim(v.substring(i + 2, end == -1 ? v.length : end));
						if (mod.type == null || mod.type == 'null' || mod.type == "html") {
							content = content.split('\r\n').join('\r').split('\n').join('\r');
							while (content.substr(0, 1) == '\r'){
								content = content.substring(1, content.length);
							}
							while (content.substr( -1) == '\r'){
								content = content.substring(0, content.length - 1);
							}
						}
						if (mod.require != null) {
							Jotun.log("	ModLib => " + path + " INCLUDING MODULES...", 1);
							Dice.Values(mod.require, function(v:String) {
								if (exists(v)){
									content = content.split("{{@include:" + v + "}}").join(get(v));
								} else{
									Jotun.log("		ModLib => MISSING '" + v + "'", 2);
								}
							});
						}
						if (mod.inject != null) {
							var injection:String = mod.inject;
							Jotun.log("	ModLib => " + path + " INJECTING MODULES...", 1);
							if (exists(injection)){
								content = get(injection).split("{{@injection}}").join(content);
							}else{
								Jotun.log("		ModLib => MISSING '" + v + "'", 2);
							}
						}
						if (mod.data != null){
							mod.data = Json.parse(mod.data);
							content = Filler.to(content, mod.data);
						}
						if (mod.wrap != null){
							content = content.split('\r\n').join(mod.wrap).split('\n').join(mod.wrap).split('\r').join(mod.wrap);
						}
						#if js
							// ============================= JS ONLY =============================
							if (mod.type != null) {
								if (mod.type == 'data'){
									try {
										Reflect.setField(data, mod.name, Json.parse(content));
									}catch (e:Dynamic){ }
								}else if (mod.type == 'style' || mod.type == 'css' || mod.type == 'script' || mod.type == 'javascript') {
									Jotun.document.head.bind(content, mod.type, mod.id);
									content = '';
								}else if (mod.type.substring(0,6)  == 'image/') {
									var img:Image = new Image();
									img.src = "data:" + mod.type + "," +Packager.encodeBase64(content);
								}
							}
							if (mod.target != null) {
								mountAfter[mountAfter.length] = mod;
							}
							// ***
						#end
						var n:String = mod.name.toLowerCase();
						Reflect.setField(CACHE, n, content);
						Reflect.setField(CACHE, '@' + n, path);
					}else {
						Jotun.log("	ModLib => CONFIG ERROR " + file + "("  + v.substr(0, 15) + "...)", 3);
					}
				}
			});
			#if js 
				if (mountAfter.length > 0){
					Dice.Values(mountAfter, function(v:IMod){
						var o:IDisplay = Jotun.one(v.target);
						if (o != null){
							o.mount(v.name, v.data);
						}
					});
				}
			#end
		}else {
			#if js
				var ext:String = file.split('.').pop();
				switch(ext){
					case 'png', 'jpg', 'jpeg', 'gif', 'bmp', 'ico' : {
						var img:Image = new Image();
						img.setAttribute('data-url', file);
						img.src = file;
						assets.element.appendChild(img);
					}
					case 'css' : {
						var dom:Style = new Style();
						dom.attribute('data-url', file);
						dom.writeHtml(content);
						dom.publish();
					}
					case 'js' : {
						var dom:Script = new Script();
						dom.attribute('data-url', file);
						dom.type('text/javascript');
						dom.writeText(content);
						dom.addToBody();
					}
					default : {
						Reflect.setField(CACHE, file.toLowerCase(), content);
					}
				}
			#else
				Reflect.setField(CACHE, file.toLowerCase(), content);
			#end
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
		if (!exists(name)) {
			return "<span style='color:#ff0000;font-weight:bold;'>Undefined [Module:" + name + "]</span><br/>";
		}
		var content:String = Reflect.field(CACHE, name);
		data = _sanitize(name, data);
		return (data != null) ? Filler.to(content, data) : content;
	}
	
	public function getObj(name:String, ?data:Dynamic):Dynamic {
		var val:String = get(name, data);
		if (val != null){
			try {
				return Json.parse(val);
			}catch (e:Dynamic){
				trace("Parsing error for MOD:[" + name+"]");
			}
		}
		return null;
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
		public function print(name:String, ?data:Dynamic):Void {
			Lib.print(get(name, data));
		}
		
	#elseif js
		
		// ============================= JS ONLY =============================
		/**
		 * Write module in a DOM element
		 * @param	module
		 * @param	data
		 * @return	The display created from Module
		 */
		public function build(module:String, ?data:Dynamic):IDisplay {
			if (Jotun.agent.mobile && exists(module + '::mobile')){
				module += '::mobile';
			}
			var signature:String = Reflect.field(CACHE, '@' + module.toLowerCase());
			var result:IDisplay = new Display().writeHtml(get(module, data));
			result.children().attribute('sru-mod', signature);
			if (data != null){
				result.react(data);
			}
			_afterMount(result, module);
			return result;
		}
		
	#end;
	
}

/*
	[Module:{
		"type"		:"css|js|style|script|json|data",		// Unique module identifier
		"name"		:"testModule",						// Unique module identifier
		"target"		:"selector",							// Auto append module in target selector
		"require"	:["modA","modB","...","modN"],			// Dependencies that will be writed in module
		"inject"		:"modName",							// Inject this content in another module and override with the result
	}]
*/