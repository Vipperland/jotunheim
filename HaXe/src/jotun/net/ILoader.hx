package jotun.net;

/**
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */

interface ILoader {
	
	#if js 
		/**
		 * Load a module not in queue
		 * @param	file
		 * @param	data
		 * @param	handler
		 * @param	progress
		 */
		public function module(file:String, ?data:Dynamic, ?handler:IRequest->Void, ?progress:IProgress->Void):Void;
	
	#elseif php
		/**
		 * Load a module not in queue
		 * @param	file
		 * @param	data
		 * @param	handler
		 */
		public function module(file:String, ?data:Dynamic, ?handler:IRequest->Void):Void;
	#end
	
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