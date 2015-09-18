package sirius;

import haxe.Log;
import sirius.data.DataCache;
import sirius.modules.ModLib;
import sirius.modules.ILoader;
import sirius.modules.Loader;
import sirius.net.Domain;
import sirius.net.IDomain;
import sirius.tools.Utils;
import sirius.utils.Dice;

#if js
	import js.Browser;
	import js.JQuery;
	import js.html.Element;
	import js.html.Event;
	import sirius.css.Automator;
	import sirius.css.CSSGroup;
	import sirius.dom.Body;
	import sirius.dom.Display;
	import sirius.dom.Document;
	import sirius.dom.IDisplay;
	import sirius.seo.SEOTool;
	import sirius.tools.IAgent;
	import sirius.tools.Agent;
	import sirius.transitions.Animator;
	import sirius.utils.ITable;
	import sirius.utils.Table;
#elseif php
	import php.Lib;
	import sirius.db.Gate;
	import sirius.db.IGate;
	import sirius.php.data.Cache;
	import sirius.php.utils.Header;
#end



/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose('Sirius')
class Sirius {
	
	/** @private */
	static private var _loglevel:UInt = 12;
	
	/** @private */
	static private var _initialized:Bool = false;
	
	/// Global resource loader
	static public var resources:ModLib = new ModLib();
	
	/// Domain information
	static public var domain:IDomain = new Domain();
	
	#if js
		
		/// Global resource loader
		static public var loader:ILoader = new Loader();
		
		/// Main document (if available)
		static public var document:Document;
		
		/// Main body (if available)
		static public var body:Body;
		
		/// Browser information
		static public var agent:IAgent = new Agent();
		
		/// SEO Tools
		static public var seo:SEOTool = new SEOTool();
		
		/** @private */
		static private var _loadPool:Array<Dynamic>;
		
		/** @private */
		static private function _loadController(e:Event):Void {
			agent.update();
			Dice.Values(_loadPool, function(v:Dynamic) { if(Utils.isValid(v)) v(); });
			Browser.document.removeEventListener("DOMContentLoaded", _loadController);
			_loadPool = null;
		}
		
		/** @private */
		static private function _onLoaded():Void {
			if (loader.totalFiles > 0) {
				log("Sirius->Resources::status [ MODULES (" + loader.totalLoaded + "/" + loader.totalFiles + ") ]", 10, 1);
			}
			if(document == null) log("Sirius->Core::status[ INITIALIZED ] ", 10, 1);
			body = new Body(Browser.document.body);
			document = new Document();
			loader.start();
		}
		
		/**
		 * QuerySelector a single display
		 * @param	q
		 * @param	t
		 * @param	h
		 * @return
		 */
		static public function one(?q:String = "*", ?t:Dynamic = null, ?h:IDisplay->Void = null):IDisplay {
			t = (t == null ? Browser.document : t).querySelector(q);
			if (t != null) {
				t = Utils.displayFrom(t);
				if (h != null) h(t);
				return t;
			}else {
				log("Sirius->Table::status[ EMPTY (" + q + ") ]", 20, 3);
				return null;
			}
		}
		
		/**
		 * Do a QuerySelectorAll and return a display Table
		 * @param	q
		 * @param	t
		 * @return
		 */
		static public function all(?q:String = "*", ?t:Dynamic = null):ITable {
			return new Table(q, t);
		}
		
		/**
		 * JQuery integration
		 * @param	q
		 * @return
		 */
		static public function j(?q:Dynamic = "*"):JQuery {
			return untyped __js__("$(q);");
		}
		
		/**
		 * Run method only if framework is Ready and DOM is loaded
		 * @param	handler
		 */
		static public function run(handler:Dynamic):Void {
			if (!_initialized) {
				init(handler);
			}else if(handler != null){
				if (Browser.document.readyState == "complete") {
					handler();
				}else {
					if (_loadPool == null) {
						_loadPool = [];
						Browser.document.addEventListener("DOMContentLoaded", _loadController);
					}
					_loadPool[_loadPool.length] = handler;
				}
			}
		}
		
		/**
		 * Init Sirius Framework
		 * @param	handler
		 * @param	files
		 */
		static public function init(?handler:Dynamic, ?files:Array<String> = null):Void {
			if (!_initialized) {
				_initialized = true;
				loader.add(files, handler, _fileError);
				log("Sirius->Core.init[ LOADING... ]", 10, 1);
				run(_onLoaded);
			}else{
				log("Sirius->Core.init[ " + (body == null ? "Waiting for DOM Loading Event..." : "READY") + " ]", 10, 2);
				if (handler != null) run(handler);
			}
		}
		
		/**
		 * Runtime status
		 */
		static private function status():Void {
			log("Sirius->Core::status[ " + (_initialized ? 'READY ' : '') + Utils.toString(agent, true) + " ] ", 10, 1);
		}
		
		/** @private */
		static private function _fileError(error:String) {
			log("Sirius->Resources::status[ " + error + " ]", 10, 3);
		}
		
	#elseif php
		
		public static var header:Header = new Header();
		
		public static var gate:IGate = new Gate();
		
		static public var cache:Cache = new Cache();
		
		static public var loader:ILoader = new Loader();
		
	#end
	
	/**
	 * Load and fill a external content
	 * @param	file
	 * @param	target
	 * @param	content
	 * @param	handler
	 */
	static public function module(file:String, ?target:String, ?content:Dynamic, ?handler:Dynamic):Void {
		#if js
			var f:Dynamic = (_initialized ? run : init);
			f(function() { loader.async(file, target, content, handler); } );
		#elseif php
			loader.async(file, content, handler);
		#end
	}
	
	static public function request(url:String, ?data:Dynamic, ?handler:Dynamic, method:String = 'post'):Void {
		#if js
			var f:Dynamic = (_initialized ? run : init);
			f(function() { loader.request(url, data, handler, method); } );
		#elseif php
			loader.request(url, data, handler, method);
		#end
	}
	
	/**
	 * Level controlled log
	 * @param	q
	 * @param	level
	 * @param	type
	 */
	static public function log(q:Dynamic, level:UInt = 10, type:UInt = -1):Void {
		if (level <= _loglevel) {
			var t:String = switch(type) {
				case -1 : "";
				case 0 : "[MESSAGE] ";
				case 1 : "[>SYSTEM] ";
				case 2 : "[WARNING] ";
				case 3 : "[!ERROR!] ";
				case 4 : "[//TODO:] ";
				default : "";
			}
			#if js
				Log.trace(t + q);
			#elseif php
				Lib.dump(q);
			#end
			
		}
	}
	
	/**
	 * Change log level
	 * @param	q
	 */
	static public function logLevel(q:UInt):Void {
		_loglevel = q;
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
	 * 			sru-id				For unique or shared data, all elements with same sru-id shared the same data.
	 * 			
	 */