package sirius.modules;

#if js
	import sirius.dom.IDisplay;
#end

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface ILoader {
	
	/**
	 * Last error info
	 */
	public var lastError : Dynamic;
	
	/**
	 * Total files in queue
	 */
	public var totalFiles:Int;
	
	/**
	 * Total of loaded files
	 */
	public var totalLoaded:Int;
	
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
		public function build (module:String, ?data:Dynamic = null, ?each:Dynamic = null) : IDisplay;
		
		/**
		 * Load a module not in queue
		 * @param	file
		 * @param	target *js only
		 * @param	data
		 * @param	handler
		 */
		public function async(file:String, #if js ?target:Dynamic #end, ?data:Dynamic, ?handler:Dynamic):Void;
		
	#elseif php
		
		/**
		 * Load a module not in queue
		 * @param	file
		 * @param	target
		 * @param	data
		 * @param	handler
		 */
		public function async(file:String, ?data:Dynamic, ?handler:Dynamic):Void;
		
	#end
	
	/**
	 * Load a list of files
	 * @param	files
	 * @param	complete
	 * @param	error
	 * @return
	 */
	public function add (files:Array<String>, ?complete:Dynamic, ?error:Dynamic):ILoader;
	
	/**
	 * Init Loader proccess
	 * @return
	 */
	public function start (?complete:Dynamic, ?error:Dynamic) : ILoader;
	
	/**
	 * Add listeners to load complete and laod error
	 * @param	complete
	 * @param	error
	 * @return
	 */
	public function listen (?complete:Dynamic, ?error:Dynamic) : ILoader;
	
	/**
	 * Call a url
	 * @param	url
	 * @param	data
	 * @param	handler
	 * @param	method
	 */
	public function request(url:String, ?data:Dynamic, ?handler:Dynamic, method:String = 'post'):Void;


}