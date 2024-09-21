package jotun.modules;
import haxe.DynamicAccess;
import haxe.Json;
import jotun.Jotun;
import jotun.data.Logger;
import jotun.utils.Dice;
import jotun.utils.Filler;

#if js
	import js.lib.Error;
	import js.html.Image;
	import jotun.dom.Style;
	import jotun.dom.IDisplay;
	import jotun.dom.Display;
	import jotun.dom.Script;
	import jotun.modules.IMod.IModTarget;
	import jotun.utils.ITable;
#elseif php
	import php.Error;
	import php.Lib;
	import sys.FileSystem;
	import sys.io.File;
#end

private typedef DataCache = {
	var buffer:Array<String>;
	var objects:DynamicAccess<Dynamic>;
	var images:DynamicAccess<Dynamic>;
	var paths:DynamicAccess<Dynamic>;
}

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class ModLib {
	
	private static var _init:Bool;
	
	private static var CACHE:DynamicAccess<Dynamic> = { };
	
	private static var DATA:DataCache = {
		buffer:[],
		images:{},
		objects:{},
		paths:{},
	};
	
	#if js
		
		private var _onMount:Array<IDisplay->String->Void> = [];
		
		private function _afterMount(object:IDisplay, module:String):Void {
			Dice.Values(_onMount, function(v:IDisplay->String->Void) { v(object, module); } );
		}
		
		/**
		 * After successful create a dom object from ModLib
		 * @param	handler
		 */
		public function onMount(handler:IDisplay->String->Void):Void {
			if (Lambda.indexOf(_onMount, handler) == -1){
				_onMount[_onMount.length] = handler;
			}
		}
		
	#end
	
	public var onBufferRequest:String->String->String;
	
	private var _predata:Array<String->Dynamic->Dynamic>;
	
	private function _sanitize(name:String, data:Dynamic):Dynamic {
		Dice.Values(_predata, function(v:String->Dynamic->Dynamic) { data = v(name, data); } );
		return data;
	}
	
	public function new() {
		if (_init != true){
			_init = true;
			_predata = [];
		}else{
			throw new Error("Can't create instance of ModLib. Use Jotun.resources instead of new ModLib().");
		}
	}
	
	/**
	 * Pre filter all get data
	 * @param	handler
	 */
	public function onDataRequest(handler:String->Dynamic->Dynamic):Void {
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
		return CACHE.get(module.toLowerCase());
	}
	
	public function remove(module:String):Void {
		if (exists(module)){
			CACHE.remove(module);
		}
	}
	
	/**
	 * Register a module
	 * 	
	 * 	[Module:{
	 * 		"name":"unique mod name",
	 * 		"?type":"mod type",
	 * 		"?require":["modname",...],
	 * 		"?inject":["modname",...],
	 * 		"?data":{...},
	 * 		"?target":[{"query":"", "index":N },...]
	 *	}]
	 * 
	 * 	Include x Inject
	 * 		
	 * 	=== Inclusion, [Module:{"name":"IncludeModSample","require":["RequiredModName"]}]
	 * 		Will inject content of defined mods in THIS content
	 * 		THIS mod require the include tag for injection points:
	 * 		{{@include:RequiredModName,data:{...}}} or {{@include:RequiredModName}}
	 * 
	 * 		This = "Message: {{@include:RequiredModName}}"
	 * 		Include = "This is the content from RequiredModName"
	 * 		Result = "Message: This is the content from RequiredModName"
	 * 
	 * 	=== Injection, [Module:{"name":"InjectModSample","inject":["TargetModToInject"]}]
	 * 		Will include THIS mod in another, and will fill with custom data if defined
	 * 		Receiving mod require the include tag for injection points:
	 * 		{{@inject:InjectModSample,data:{...}}} or {{@inject:InjectModSample}}
	 * 
	 * 		This = "Message: {{@inject:TargetModToInject}}"
	 * 		Inject = "This is the content from TargetModToInject"
	 * 		Result = "Message: This is the content from RequiredModName"
	 * 
	 * @param	file
	 * @param	content
	 * @param	data
	 */
	public function register(file:String, content:String):Void {
		content = content.split("[module:{").join("[!MOD!]");
		content = content.split("[Module:{").join("[!MOD!]");
		var sur:Array<String> = content.split("[!MOD!]");
		var total:Int = sur.length - 1;
		var count:Int = 0;
		var errors:Int = 0;
		var fdata:Int = 0;
		var pdata:Int = 0;
		if (sur.length > 1) {
			Jotun.log("ModLib => PARSING " + file + " MODULES (~" + total + ")", Logger.MODULE);
			#if js 
				var mountAfter:Array<IMod> = [];
			#end
			Dice.All(sur, function(p:Int, v:String) {
				if (p > 0){
					++count;
					var i:Int = v.indexOf("}]");
					if (i != -1) {
						var mod:IMod = Json.parse("{" + v.substr(0, i) + "}");
						var path:String = file;
						if (mod.name == null){
							mod.name = file;
						}else if (mod.name == "[]"){
							path += '[]';
						}else {
							path += '#' + mod.name;
							if (mod.type != 'data'){
								Jotun.log("	@ BLOCK: " + mod.name + " (" + count + "/" + total + ")", Logger.MODULE);
							}
						}
						if (exists(mod.name)){
							Jotun.log("	ModLib => !!! OVERRIDING " + path, Logger.MODULE);
						}
						var end:Int = v.indexOf("/EOF;");
						content = StringTools.trim(v.substring(i + 2, end == -1 ? v.length : end));
						if (mod.type == null || mod.type == 'null' || mod.type == "html") {
							content = content.split('\r\n').join('\n').split('\r').join('\n');
							while (content.substr(0, 1) == '\r'){
								content = content.substring(1, content.length);
							}
							while (content.substr( -1) == '\n'){
								content = content.substring(0, content.length - 1);
							}
						}
						if (mod.require != null) {
							var incT:Int = mod.require.length;
							var incC:Int = 1;
							Jotun.log("		> INCLUDING MODULES IN '" + mod.name + "' (" + incT + ")", Logger.MODULE);
							Dice.Values(mod.require, function(v:String) {
								if (exists(v)){
									// inclusion with custom data
									Dice.All(content.split("{{@include:" + v + ",data:{"), function(p:Int, v2:String):Void {
										if (p > 0){
											var pieces:String = v2.split("}}}")[0];
											try {
												var data:DynamicAccess<Dynamic> = Json.parse('{' + pieces + '}');
												if(!Std.isOfType(data, Array)){
													data.set('@name', mod.name);
												}
												content = content.split("{{@include:" + v + ",data:{" + pieces + "}}}").join(get(v, data));
											}catch (e:Error){
												Jotun.log("			ERROR: Can't parse module include data for " + v + ".", Logger.ERROR);
											}
										}
									});
									// inclusion with no custom data
									content = content.split("{{@include:" + v + "}}").join(get(v));
									Jotun.log("			+ INCLUDED '" + v + "' #" + incC, Logger.MODULE);
								} else{
									Jotun.log("			- MISSING '" + v + "' #" + incC, Logger.ERROR);
								}
								++incC;
							});
						}
						if (mod.data != null){
							mod.data = Json.parse(mod.data);
							content = Filler.to(content, mod.data);
						}
						if (mod.replace != null){
							Dice.Values(mod.replace, function(v:Array<String>){
								content = content.split(v[0]).join(v[1]);
							});
						}
						if (mod.type != null) {
							if (mod.type == 'data'){
								try {
									if(onBufferRequest != null){
										content = onBufferRequest(file, content);
										if(content == null){
											return false;
										}
									}
									content = Json.parse(content);
									if (mod.name == '[]'){
										++pdata;
										Jotun.log("	@ PUSH: {...} (" + count + "/" + total + ")", Logger.MODULE);
										DATA.buffer.push(content);
									}else{
										++fdata;
										Jotun.log("	@ DATA:  {" + mod.name + "} (" + count + "/" + total + ")", Logger.MODULE);
										DATA.objects.set(mod.name, content);
									}
									return false;
								}catch (e:Dynamic){
									++errors;
									Jotun.log("		ERROR! Can't parse DATA.objects[" + mod.name + "] \n\n " + content + "\n\n" + e, Logger.ERROR);
								}
							}
							#if js
								// ============================= JS ONLY =============================
								else if (mod.type == 'style' || mod.type == 'css' || mod.type == 'script' || mod.type == 'javascript') {
									Jotun.document.head.bind(content, mod.type, mod.name);
									content = '';
								}
							#end
							else if (mod.type == 'image') {
								DATA.images.set(mod.name, content);
							}
						}
						#if js
							// ============================= JS ONLY =============================
							if (mod.target != null) {
								mountAfter[mountAfter.length] = mod;
							}
							// ***
						#end
						var n:String = mod.name.toLowerCase();
						CACHE.set(n, content);
						DATA.paths.set('@' + n, path);
					}else {
						Jotun.log("	ModLib => CONFIG ERROR " + file + "("  + v.substr(0, 15) + "...)", Logger.ERROR);
					}
				}
				return false;
			});
			#if js 
				// ============================= JS ONLY =============================
				if (mountAfter.length > 0){
					Dice.Values(mountAfter, function(v:IMod){
						Dice.Values(v.target, function(o:IModTarget):Void{
							Jotun.all(o.query).each(function(target:IDisplay):Void{
								target.mount(v.name, null, o.index);
							});
						});
					});
				}
			#end
			Jotun.log("	! PARSED: " + (count - errors) + "/" + total + ", Data: " + (fdata + pdata) + " ([]:" + pdata + ",@:" + pdata + "), Errors: " + errors, Logger.MODULE);
		}else {
			#if js
				// ============================= JS ONLY =============================
				var ext:String = file.split('.').pop();
				switch(ext){
					case 'css' : {
						var dom:Style = new Style();
						dom.attribute('data-url', file);
						dom.writeHtml(content);
						dom.addToBody();
					}
					case 'js' : {
						var dom:Script = new Script();
						dom.attribute('data-url', file);
						dom.type('text/javascript');
						dom.writeText(content);
						dom.addToBody();
					}
					default : {
						CACHE.set(file.toLowerCase(), content);
					}
				}
			#else
				CACHE.set(file.toLowerCase(), content);
			#end
		}
	}
	
	/**
	 * Get module content
	 * @param	name
	 * @param	data
	 * @param	alt
	 * @return
	 */
	public function get(name:String, ?data:Dynamic, ?alt:String):String {
		name = name.toLowerCase();
		if (!exists(name)) {
			return alt != null ? alt : "<span style='color:#ff0000;font-weight:bold;'>Undefined [Module:" + name + "]</span><br/>";
		}
		var content:String = CACHE.get(name);
		data = _sanitize(name, data);
		return (data != null) ? Filler.to(content, data) : content;
	}
	
	/**
	 * Get module content as json object
	 * @param	name
	 * @param	data
	 * @return
	 */
	public function object(name:String, ?data:Dynamic):Dynamic {
		if (DATA.objects.exists(name)){
			data = DATA.objects.get(name);
		}else{
			var val:String = get(name, data, '');
			if (val != null){
				try {
					data = Json.parse(val);
				}catch (e:Dynamic){
					Jotun.log("	ModLib => Can't create object for [Module:" + name + "]", Logger.ERROR);
					data = null;
				}
			}
		}
		return data;
	}
	
	public function image(name:String):String {
		return DATA.images.get(name);
	}
	
	public function buffer(?name:String):Dynamic {
		if(name != null && name != ''){
			return DATA.objects.get(name);
		}else{
			return DATA.buffer;
		}
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
		
		/**
		 * Write module with custom data in the flow to be imported by Jotun Client
		 * @param	name
		 * @param	data
		 * @param	repeat
		 * @param	sufix
		 */
		public function export(name:Dynamic, ?data:Dynamic):Void {
			Lib.print("<noscript jtn-module>");
			if (Std.isOfType(name, Array)){
				Dice.Values(name, function(v:Dynamic){
					if(Std.isOfType(v, String)){
						Lib.print('[Module:{"name":"' + name + '"}]\r');
						print(get(name, data));
					}else if(Reflect.hasField(v, 'info')){
						Lib.print('[Module:');
						Lib.print(Json.stringify(v.info));
						Lib.print(']\r');
						print(v.name, v.data);
					}
				});
			}else{
				Lib.print('[Module:{"name":"' + name + '"}]\r');
				get(name, data);
			}
			Lib.print("</noscript>");
		}
		
	#elseif js
		
		public function domImage(name:String):Image {
			var img:Image = new Image();
			img.src = image(name);
			return img;
		}
		
		// ============================= JS ONLY =============================
		/**
		 * Write module in a DOM element
		 * 
		 * @param	module
		 * @param	data
		 * @return	The display created from Module
		 */
		public function build(module:String, ?data:Dynamic):IDisplay {
			if (Jotun.agent.mobile && exists(module + '::mobile')){
				module += '::mobile';
			}
			var path:String = DATA.paths.get('@' + module.toLowerCase());
			var result:IDisplay = new Display().writeHtml(get(module, data));
			result.children().attribute('jtn-mod', path);
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
		"name": "",
		"type": "",
		"require": [],
		"replace": [],
		"data": {},
		"target": null,
	}]
*/