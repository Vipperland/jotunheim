package jotun;

import haxe.macro.Expr;
import jotun.data.Logger;
import jotun.modules.ModLib;
import jotun.net.DataSource;
import jotun.net.Domain;
import jotun.net.IDomain;
import jotun.net.ILoader;
import jotun.net.IProgress;
import jotun.net.IRequest;
import jotun.net.Loader;
import jotun.tools.Utils;
import jotun.utils.Dice;

#if js
	import js.Browser;
	import js.html.Event;
	import jotun.utils.ITable;
	import jotun.utils.Table;
	import jotun.dom.Document;
	import jotun.dom.Displayable;
	import jotun.dom.Script;
	import jotun.dom.Style;
	import jotun.net.Broadcast;
	import jotun.signals.Observer;
	import jotun.timer.Timer;
	import jotun.tools.Agent;
	import jotun.tools.IAgent;
	import jotun.tools.DisplayCache;
#elseif php
	import php.Lib;
	import jotun.php.db.Gate;
	import jotun.php.db.IGate;
	import jotun.net.Header;
#end



/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose('Jotun')
class Jotun {
	
	/** @private */
	static private var _loaded:Bool = false;
	
	/// Global resource loader
	static public var resources:ModLib = new ModLib();
	
	/// Domain information
	static public var domain:IDomain = new Domain();
	
	
	static public var params:DataSource = null;
	
	/// Debug tools
	static public var logger:Logger = new Logger();
	
	
	#if js
		
		/** @private */
		static private var _initialized:Bool;
		
		static public function main():Void {
			if (!_initialized){
				_initialized = _preInit();
			}
		}
		
		/// Global resource loader
		static public var loader:ILoader = new Loader();
		
		/// Main document (if available)
		static public var document:Document;
		
		/// Main timer
		static public var timer:Timer = new Timer();
		
		/// Main timer
		static public var cache:DisplayCache = new DisplayCache();
		
		/// Main timer
		static public var observer:Observer = new Observer();
		
		/// Browser information
		static public var agent:IAgent = new Agent();
		
		/// 
		static public var broadcast:Broadcast = Broadcast.ME();
		
		/** @private */
		static private var _loadPool:Array<Dynamic>;
		
		/** @private */
		static private function _loadController(e:Event):Void {
			if (!_loaded){
				_loaded = true;
				agent.update();
				document.checkBody();
				log("Jotun API => READY", 1);
				Dice.Values(_loadPool, function(v:Dynamic) { if (v != null) v(); });
				_loadPool = null;
				Browser.document.removeEventListener("DOMContentLoaded", _loadController);
				Reflect.deleteField(Jotun, '_loadController');
				Reflect.deleteField(Jotun, '_loadPool');
				Reflect.deleteField(Jotun, 'main');
			}
		}
		
		/** @private */
		static private function _preInit():Bool {
			if (!_initialized) {
				(cast Browser.window).trace = js.Syntax.code("console.log");
				_initialized = true;
				_loadPool = [];
				document = Document.ME();
				Browser.document.addEventListener("DOMContentLoaded", _loadController);
				try {
					Reflect.deleteField(Jotun, '_preInit');
				}catch(e:Dynamic){}
				var state:String = Browser.document.readyState;
				if (state == 'complete' || state == 'interactive'){
					_loadController(null);
				}
			}
			return true;
		}
		
		/**
		 * QuerySelector a single display
		 * @param	q
		 * @param	t
		 * @param	h
		 * @return
		 */
		static public function one(?q:String = "*", ?t:Dynamic = null):Displayable {
			if (t == null){
				t = Browser.document.querySelector(q);
			} else{
				t = t.querySelector(q);
			}
			if (t != null){
				t = Utils.displayFrom(t);
			} else{
				log("Find => No result on selector (" + q + ")", 5);
			}
			return t;
		}
		
		/**
		 * Do a QuerySelectorAll and return a display Table
		 * @param	q
		 * @param	t
		 * @param	h
		 * @return
		 */
		static public function all(?q:String = "*", ?t:Dynamic = null):ITable {
			return Table.recycle(q, t);
		}

		/**
		 * Run method only if framework is Ready and DOM is loaded
		 * @param	handler
		 */
		static public function run(handler:Dynamic):Void {
			if (main != null){
				main();
			}
			if (handler != null) {
				if (!_loaded && _loadPool != null) 
					_loadPool[_loadPool.length] = handler;
				else
					handler();
			}
		}
		
		static public function inject(value:Dynamic, ?data:Dynamic, ?handler:Script->Void):Void {
			if (!Std.isOfType(value, Array)){
				value = [value];
			}
			Dice.Values(value, function(v:String){
				if (v.indexOf('.js') == -1){
					var o:Script = Script.fromString(v, data);
					if (handler != null){
						handler(o);
					}
				}else{
					Script.fromUrl(v, data, handler);
				}
			});
		}
		
		static public function stylish(value:String, ?data:Dynamic, ?handler:Style->Void):Void {
			if (value.indexOf('.css') == -1){
				Style.fromString(value, data);
			}else{
				Style.fromUrl(value, data, handler);
			}
		}
		
		/**
		 * Runtime status
		 */
		static private function status():IAgent {
			log("Jotun API => STATUS " + (_initialized ? 'READY ' : '') + Utils.toString(agent, true), 1);
			return agent;
		}
		
		/**
		 * Call a URL with POST/GET/BINARY capabilities
		 * @param	url
		 * @param	data
		 * @param	handler
		 * @param	method
		 */
		static public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null, ?progress:IProgress->Void = null, ?options:Dynamic):Void {
			run(function() { loader.request(url, data, method, handler, headers, progress, options); } );
		}
		
		/**
		 * Load an external or internal module content
		 * @param	file
		 * @param	content
		 * @param	handler
		 */
		static public function module(file:String, name:String, ?data:Dynamic, ?handler:IRequest->Void, ?progress:IProgress->Void = null):Void {
			if (name == null || !resources.exists(name)){
				loader.module(file, data, handler, progress);
			}else{
				handler(null);
			}
		}
		
		
		static public function create(html:String, ?data:Dynamic, ?at:Int):Displayable {
			return document.body.mount(html, data, at);
		}
		
	#elseif php
		
		static public function main() {  }
		
		static public var header:Header = new Header();
		
		static public var gate:IGate = new Gate();
		
		static public var loader:ILoader = new Loader();
		
		static public var time:UInt = php.Syntax.codeDeref('time()');
		
		static public function require(file:String):Void {
			php.Syntax.codeDeref('require_once({0})', file);
		}
		
		/**
		 * Load an external or internal module content
		 * @param	file
		 * @param	content
		 * @param	handler
		 */
		static public function module(file:String, ?content:Dynamic, ?handler:IRequest->Void):Void {
			if (file.indexOf("http") == -1) {
				resources.prepare(file);
			}else {
				loader.module(file, content, handler);
			}
		}
		
		
		/**
		 * Call a URL with POST/GET/BINARY capabilities
		 * @param	url
		 * @param	data
		 * @param	handler
		 * @param	method
		 */
		static public function request(url:String, ?data:Dynamic, ?method:String = 'post', ?handler:IRequest->Void, ?headers:Dynamic = null):Void {
			loader.request(url, data, method, handler, headers);
		}
		
	#end
	
	
	/**
	 * Level controlled log
	 * @param	q
	 * @param	level
	 * @param	type
	 */
	static public function log(q:Dynamic, type:UInt = -1):Void {
		logger.push(q, type);
	}
	
}