package jotun;

import haxe.Log;
import jotun.data.Logger;
import jotun.errors.IError;
import jotun.net.IProgress;
import jotun.net.IRequest;
import jotun.modules.ModLib;
import jotun.net.ILoader;
import jotun.net.Loader;
import jotun.net.Domain;
import jotun.net.IDomain;
import jotun.signals.IFlow;
import jotun.signals.ISignals;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.utils.Filler;

#if js
	import js.Browser;
	import js.JQuery;
	import js.html.Element;
	import js.html.Event;
	import jotun.css.XCode;
	import jotun.css.CSSGroup;
	import jotun.dom.Body;
	import jotun.dom.Display;
	import jotun.dom.Document;
	import jotun.dom.IDisplay;
	import jotun.dom.Script;
	import jotun.seo.SEOTool;
	import jotun.tools.IAgent;
	import jotun.tools.Agent;
	import jotun.transitions.Animator;
	import jotun.transitions.Ease;
	import jotun.utils.ITable;
	import jotun.utils.Pixel;
	import jotun.utils.SearchTag;
	import jotun.utils.Table;
	import jotun.gaming.actions.Events;
#elseif php
	import php.Lib;
	import jotun.data.DataCache;
	import jotun.db.Gate;
	import jotun.db.IGate;
	import jotun.php.data.Cache;
	import jotun.net.Header;
#end



/**
 * 191104010157
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
	
	/// Debug tools
	static public var logger:Logger = new Logger();
	
	
	#if js
		
		/** @private */
		static private var _initialized:Bool = main();
		
		static public function main():Bool { return _initialized || _preInit(); }
		
		/// Global resource loader
		static public var loader:ILoader = new Loader();
		
		/// Main document (if available)
		static public var document:Document;
		
		/// Browser information
		static public var agent:IAgent = new Agent();
		
		/// SEO Tools
		static public var seo:SEOTool = new SEOTool();
		
		/// External Plugins
		static public var plugins:Dynamic = { };
		
		/** @private */
		static private var _loadPool:Array<Dynamic>;
		
		/** @private */
		static private function _loadController(e:Event):Void {
			if (!_loaded){
				_loaded = true;
				document.checkBody();
				agent.update();
				Ease.update();
				Dice.Values(_loadPool, function(v:Dynamic) { if (v != null) v(); });
				_loadPool = null;
				updatePlugins();
				log("Jotun => READY", 1);
				Browser.document.removeEventListener("DOMContentLoaded", _loadController);
				Reflect.deleteField(Jotun, '_loadController');
				Reflect.deleteField(Jotun, '_loadPool');
				Reflect.deleteField(Jotun, 'main');
				document.body.autoLoad();
			}
		}
		
		static private function _preInit():Bool {
			if (!_initialized) {
				(cast Browser.window).trace = untyped __js__("console.log");
				_initialized = true;
				_loadPool = [];
				document = Document.ME();
				Browser.document.addEventListener("DOMContentLoaded", _loadController);
				//Automator._init();
				//log("Jotun => LOADING...", 1);
				Reflect.deleteField(Jotun, '_preInit');
				var state:String = Browser.document.readyState;
				if (state == 'complete' || state == 'interactive'){
					_loadController(null);
				}
			}
			return true;
		}
		
		static public function updatePlugins():Void {
			if(_loaded){
				var plist:Dynamic = untyped __js__("window.jtn ? window.jtn.plugins : null");
				Dice.All(plist, function(p:String, v:Dynamic) {
					Reflect.setField(plugins, p, v);
					Reflect.deleteField(plist, p);
					if (Reflect.hasField(v, 'onload')) {
						v.onload();
						log("Plugin => " + p + "::onload()", 1);
					}else{
						log("Plugin => " + p + " ADDED", 1);
					}
				});
			}
		}
		
		/**
		 * QuerySelector a single display
		 * @param	q
		 * @param	t
		 * @param	h
		 * @return
		 */
		static public function one(?q:String = "*", ?t:Dynamic = null):IDisplay {
			if (t == null)
				t = Browser.document.querySelector(q);
			else
				t = t.querySelector(q);
			if (t != null)
				t = Utils.displayFrom(t);
			else
				log("Find => No result on selector (" + q + ")", 5);
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
		 * JQuery integration
		 * @param	q
		 * @return
		 */
		static public function jQuery(?q:Dynamic = "*"):Dynamic {
			return untyped __js__("$(q);");
		}
		
		/**
		 * Run method only if framework is Ready and DOM is loaded
		 * @param	handler
		 */
		static public function run(handler:Dynamic):Void {
			if (handler != null) {
				if (!_loaded && _loadPool != null) 
					_loadPool[_loadPool.length] = handler;
				else
					handler();
			}
		}
		
		static public function inject(url:Dynamic, ?handler:Void->Void):Void {
			if (!Std.is(url, Array)) url = [url];
			Script.require(url, handler);
		}
		
		static public function stylish(url:Dynamic, ?handler:Void->Void):Void {
			if (!Std.is(url, Array)) url = [url];
			//Style.require(url, handler);
		}
		
		/**
		 * Runtime status
		 */
		static private function status():IAgent {
			log("Jotun => STATUS " + (_initialized ? 'READY ' : '') + Utils.toString(agent, true), 1);
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
		static public function module(file:String, name:String, ?data:Dynamic, ?handler:IRequest->Void):Void {
			if (!resources.exists(name)){
				loader.module(file, data, handler);
			}else{
				handler(null);
			}
		}
		
		
	#elseif php
		
		static public function main() {  }
		
		static public var header:Header = new Header();
		
		static public var gate:IGate = new Gate();
		
		static public var loader:ILoader = new Loader();
		
		static public var tick:UInt = untyped __php__('time()');
		
		static public function require(file:String):Void {
			untyped __call__('require_once', file);
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

	/*
	 * 	=================== SELECTORS =============================================================================================================
	 *  .class					.intro					Selects all elements with class="intro"
	 *	#id						#firstname				Selects the element with id="firstname"
	 *	*						*						Selects all elements
	 *	element					p						Selects all <p> elements
	 *	element,element			div, p					Selects all <div> elements and all <p> elements
	 *	element element			div p					Selects all <p> elements inside <div> elements
	 *	element>element			div > p					Selects all <p> elements where the parent is a <div> element
	 *	element+element			div + p					Selects all <p> elements that are placed immediately after <div> elements
	 *	element1~element2			p ~ ul					Selects every <ul> element that are preceded by a <p> element
	 *	[attribute]				[target]					Selects all elements with a target attribute
	 *	[attribute=value]			[target=_blank]			Selects all elements with target="_blank"
	 *	[attribute~=value]		[title~=flower]			Selects all elements with a title attribute containing the word "flower"
	 *	[attribute|=value]		[lang|=en]				Selects all elements with a lang attribute value starting with "en"
	 *	[attribute^=value]		a[href^="https"]			Selects every <a> element whose href attribute value begins with "https"
	 *	[attribute$=value]		a[href$=".pdf"]			Selects every <a> element whose href attribute value ends with ".pdf"
	 *	[attribute*=value]		a[href*="w3schools"]		Selects every <a> element whose href attribute value contains the substring "w3schools"
	 *	:active					a:active					Selects the active link
	 *	::after					p::after					Insert content after every <p> element
	 *	::before					p::before				Insert content before the content of every <p> element
	 *	:checked					input:checked				Selects every checked <input> element
	 *	:disabled				input:disabled			Selects every disabled <input> element
	 *	:empty					p:empty					Selects every <p> element that has no children (including text nodes)
	 *	:enabled					input:enabled				Selects every enabled <input> element
	 *	:first-child				p:first-child				Selects every <p> element that is the first child of its parent
	 *	::first-letter			p::first-letter			Selects the first letter of every <p> element
	 *	::first-line				p::first-line				Selects the first line of every <p> element
	 *	:first-of-type			p:first-of-type			Selects every <p> element that is the first <p> element of its parent
	 *	:focus					input:focus				Selects the input element which has focus
	 *	:hover					a:hover					Selects links on mouse over
	 *	:in-range				input:in-range			Selects input elements with a value within a specified range
	 *	:invalid					input:invalid				Selects all input elements with an invalid value
	 *	:lang(language)			p:lang(it)				Selects every <p> element with a lang attribute equal to "it" (Italian)
	 *	:last-child				p:last-child				Selects every <p> element that is the last child of its parent
	 *	:last-of-type				p:last-of-type			Selects every <p> element that is the last <p> element of its parent
	 *	:link					p:link					Selects all unvisited links
	 *	:not(selector)			:not(p)					Selects every element that is not a <p> element
	 *	:nth-child(n)				p:nth-child(2)			Selects every <p> element that is the second child of its parent
	 *	:nth-last-child(n)		p:nth-last-child(2)		Selects every <p> element that is the second child of its parent, counting from the last child
	 *	:nth-last-of-type(n)		p:nth-last-of-type(2)		Selects every <p> element that is the second <p> element of its parent, counting from the last child
	 *	:nth-of-type(n)			p:nth-of-type(2)			Selects every <p> element that is the second <p> element of its parent
	 *	:only-of-type				p:only-of-type			Selects every <p> element that is the only <p> element of its parent
	 *	:only-child				p:only-child				Selects every <p> element that is the only child of its parent
	 *	:optional				input:optional			Selects input elements with no "required" attribute
	 *	:out-of-range				input:out-of-range		Selects input elements with a value outside a specified range
	 *	:read-only				input:read-only			Selects input elements with the "readonly" attribute specified
	 *	:read-write				input:read-write			Selects input elements with the "readonly" attribute NOT specified
	 *	:required				input:required			Selects input elements with the "required" attribute specified
	 *	:root					:root					Selects the document's root element
	 *	::selection				::selection				Selects the portion of an element that is selected by a user					 
	 *	:target					#news:target				Selects the current active #news element (clicked on a URL containing that anchor name)
	 *	:valid					input:valid				Selects all input elements with a valid value
	 *	:visited					a:visited				Selects all visited links
	 * 
	 * 
	 * 
	 * 		Sirius unique attributes:
	 * 			jotun-id				For unique or shared data, all elements with same jotun-id share the same data.
	 * 			jotun-dom			For type idenfication and fast display conversion.
	 * 			jotun-load			Load and build an external module (sru="url#module")
	 * 			
	 */