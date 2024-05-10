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
		
		/**
		 * Use Request/response style for js
		 * @param	url
		 * @param	data
		 * @param	handler
		 * @return
		 */
		public function fetch(url:String, ?data:Null<js.html.RequestInit>, ?handler:Null<IRequestHandler>):IRequestHandler;
	
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
		 * Call an url
		 * @param	url
		 * @param	data
		 * @param	method
		 * @param	handler
		 * @param	headers
		 * @param	progress
		 * @param	options
		 */
		public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null, ?progress:IProgress->Void = null, ?options:Dynamic = null):Void;
		
	#elseif php
		/**
		 * Call an url
		 * @param	url
		 * @param	data
		 * @param	handler
		 * @param	method
		 */
		public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null):Void;
		
	#end

}