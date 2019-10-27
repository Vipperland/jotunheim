package jotun.net;
import jotun.errors.IError;
import jotun.errors.Error;
import jotun.net.HttpRequest;
import jotun.signals.ISignals;

#if js
	import jotun.dom.IDisplay;
#end

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface ILoader {
	
	/**
	 * Last error info
	 */
	public var lastError:IError;
	
	/**
	 * Total files in queue
	 */
	public var totalFiles:Int;
	
	/**
	 * Total of loaded files
	 */
	public var totalLoaded:Int;
	
	/**
	 * Loader signals
	 */
	public var signals:ISignals;
	
	/**
	 * Total Load Progress
	 * @return
	 */
	public function progress():Float;
	
	/**
	 * Read the content of an loaded module
	 */
	public function get (module:String, ?data:Dynamic = null) : String;
	
	#if js
		
		/**
		 * Draws a module in a DOMElement
		 * @param	module
		 * @param	data
		 * @return
		 */
		public function build (module:String, ?data:Dynamic = null, ?each:IDisplay->IDisplay = null) : IDisplay;
		
	#end
	
	#if js 
		/**
		 * Load a module not in queue
		 * @param	file
		 * @param	data
		 * @param	handler
		 * @param	progress
		 */
		public function async(file:String, ?target:Dynamic, ?data:Dynamic, ?handler:IRequest->Void, ?progress:IProgress->Void ):Void;
	#elseif php
		/**
		 * Load a module not in queue
		 * @param	file
		 * @param	data
		 * @param	handler
		 */
		public function async(file:String, ?data:Dynamic, ?handler:IRequest->Void):Void;
	#end
	
	/**
	 * Load a list of files
	 * @param	files
	 * @param	complete
	 * @param	error
	 * @return
	 */
	public function add (files:Dynamic):ILoader;
	
	/**
	 * Init Loader proccess
	 * @return
	 */
	public function start () : ILoader;
	
	#if js 
		/**
		 * Call a url
		 * @param	url
		 * @param	data
		 * @param	handler
		 * @param	method
		 * @param	progress
		 */
		public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null, ?progress:IProgress->Void = null, ?options:Dynamic = null):Void;
		
	#elseif php
		/**
		 * Call a url
		 * @param	url
		 * @param	data
		 * @param	handler
		 * @param	method
		 */
		public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null):Void;
		
	#end
	
	

}