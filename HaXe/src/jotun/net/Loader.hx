package jotun.net;
import haxe.DynamicAccess;
import haxe.Json;
import jotun.Jotun;
import jotun.errors.Error;
import jotun.gaming.dataform.Pulsar;
import jotun.net.HttpRequest;
import jotun.net.Request;
import jotun.tools.Utils;
import jotun.utils.Dice;

#if js
	
	import jotun.data.BlobCache;
	import jotun.dom.Link;
	import jotun.dom.Style;
	import jotun.dom.Video;

	import js.Syntax;
	import js.html.AbortController;
	import js.html.Blob;
	import js.html.DOMError;
	import js.html.FileReader;
	import js.html.FormData;
	import js.html.RequestInit;
	import js.html.Response;
	import js.lib.Promise;
	
	typedef IBlobContent = {
		var blob:Bool;
		var content:Blob;
		var name:String;
	}
	
#end


/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Loader implements ILoader {
	
	private function _getReq(u:String):HttpRequest {
		return new HttpRequest(u);
	}
	
	public function new(){
	}
	
	#if js 
	
	private function _endFetch(request:js.html.Request, response:Response, handler:IRequestHandler):Void {
		if(handler.complete != null){
			handler.complete(new jotun.net.Response(request, response, handler.data, handler.error));
		}
	}
	
	private function _runFetch(request:js.html.Request, response:Response, handler:IRequestHandler):Void {
		if(handler.promise != null){
			handler.promise.then(function(data:Dynamic):Void {
				try{
					if(handler.before != null){
						handler.data = handler.before(data);
					}else{
						handler.data = data;
					}
					_endFetch(request, response, handler);
				}catch(e:Error){
					Promise.reject(e);
				}
			}).catchError(function(error:DOMError):Void{
				handler.error = error;
				_endFetch(request, response, handler);
			});
		}else{
			_endFetch(request, response, handler);
		}
	}
	
	private function _matchType(type:String, content:String, ...rest:String):Bool {
		return content.indexOf(type) != -1 || (type == null && !Dice.Values(rest, function(v:String):Bool {
			return v.indexOf(content) != -1;
		} ).completed);
	}
	
	/**
	 * 
	 * @param	url
	 * @param	data
	 * @param	handler
	 * @return
	 */
	public function fetch(url:String, ?data:Null<RequestInit>, ?handler:Null<IRequestHandler>):IRequestHandler {
		var forceType:String = null;
		if(data == null){
			data = cast { }
		}
		if (data.body != null){
			if(data.method != null){
				data.method = data.method.toUpperCase();
			}
			if(data.method == null || data.method == 'GET'){
				url = Utils.createQueryParams(url, data.body);
				Reflect.deleteField(data, 'body');
			}else if(data.method == 'POST'){
				if(!Std.isOfType(data.body, String)){
					data.body = Json.stringify(data.body);
				}
			}
		}
		if(handler == null){
			handler = { };
		}else{
			if(handler.type != null){
				handler.type == handler.type.toLowerCase();
			}
			if(handler.abort != null){
				data.signal = handler.abort.signal;
			}
		}
		handler.request = new js.html.Request(url, data);
		Syntax.code("fetch({0})", handler.request).then(function(response:Response):Void {
			if(!response.bodyUsed){
				var request:js.html.Request = handler.request;
				var content:String = response.headers.get('Content-Type');
				if (_matchType(handler.type, content, 'application/json')){
					// Parse JSON object
					handler.promise = response.json();
					_runFetch(request, response, handler);
				}else if (_matchType(handler.type, content, 'multipart/form-data')){
					// Parse FORMDATA
					handler.promise = response.formData();
					if (handler.before == null){
						handler.before = function(data:FormData):Dynamic {
							var res:DynamicAccess<Dynamic> = { };
							data.forEach(function(p:String, v:Dynamic):Void{
								res.set(p, v);
							});
							return res;
						}
					}
					_runFetch(request, response, handler);
				}else if (_matchType(handler.type, content, 'image/', 'audio/', 'video/')){
					handler.promise = response.blob();
					if (handler.before == null){
						handler.before = function(blob:Blob):IBlobContent {
							var name:String = request.url.split('/').pop().split('?')[0];
							BlobCache.create(name, blob, false);
							return { blob:true, content:blob, name:name };
						}
					} 
					_runFetch(request, response, handler, );
				}else if (_matchType(handler.type, content, 'text/css')){
					handler.promise = response.blob();
					if(handler.before == null){
						handler.before = Link.fromBlob;
					}
					_runFetch(request, response, handler);
				}else if (_matchType(handler.type, content, 'text/')){
					handler.promise = response.text();
					if (handler.before == null){
						handler.before = function(data:String):Dynamic {
							if(handler.module){
								Jotun.resources.register(url, data);
								return data;
							}else if (handler.pulsar){
								// Parse PULSAR instructions
								return Pulsar.create(data);
							}else {
								// Return plain text
								return data;
							}
						}
					}
					_runFetch(request, response, handler);
				}else {
					_runFetch(request, response, handler);
				}
			}
		});
		return handler;
	}
	
	public function module(file:String, ?data:Dynamic, ?handler:IRequest->Void, ?progress:IProgress->Void):Void {
	#else
	public function module(file:String, ?data:Dynamic, ?handler:IRequest->Void):Void {
	#end
		var r:HttpRequest = _getReq(file);
		#if js 
			r.async = true;
		#end
		r.onData = function(d) {
			Jotun.resources.register(file, d);
			if (handler != null) {
				handler(new Request(true, d, null, file)); 
			}
		}
		r.onError = function(d) {
			if (handler != null) {
				handler(new Request(false, null, new Error(-1, d), file)); 
			}
		}
		#if js
			if (progress == null){
				r.request('GET', null);
			}else{
				var pro:IProgress = cast {loaded:0,total:0,file:file};
				r.request('GET', null, cast function(u:String, a:Int, b:Int):Void{
					pro.loaded = a;
					pro.total = b;
					pro.file = u;
					progress(pro);
				});
			}
		#elseif php
			r.request(false);
		#end
	}
	
	#if js 
	public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null, ?progress:IProgress->Void = null, ?options:Dynamic = null):Void {
	#else
	public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null):Void {
	#end
	
		if (method != null){
			method = method.toUpperCase();
		}
		var is_post:Bool = method == 'POST';
		var is_get:Bool = method == 'GET';
		var is_data:Bool = Std.isOfType(data, String);
		// Build URL for GET parameters 
		if (is_get && data != null){
			url += ((url.indexOf('?') == -1) ? '?' : '&') + Utils.paramsOf(data);
		}
		// Create request object
		var r:HttpRequest = _getReq(url);
		#if js
			r.async = true;
		#end
		// Parse parameters
		if (!is_data && data != null) {
			#if js
				Dice.All(data, r.addParameter);
			#else
				Dice.All(data, r.setParameter);
			#end
		}
		if (headers != null){
			Dice.All(headers, function(p:String, v:Dynamic):Void {
				r.setHeader(p, v);
			});
		}
		r.onData = function(d) { 
			if (handler != null) {
				var hdrs:Dynamic = r.responseHeaders;
				#if js
					if (options != null){
						if (options.responseType == 'blob'){
							var f:FileReader = new FileReader();
							f.onloadend = function(e) {
								handler(new Request(true, e.target.result, null, url, hdrs));
							}
							f.readAsDataURL(cast d);
							return;
						}
					}else{
						handler(new Request(true, d, null, url, hdrs)); 
					}
				#else 
					handler(new Request(true, d, null, url, hdrs)); 
				#end
			}
		}
		r.onError = function(d) { 
			if (handler != null) {
				handler(new Request(false, null, new Error(-1, d))); 
			}
		}
		#if js
			var pro:IProgress = cast {loaded:0,total:0,file:url};
			r.request(method, data, progress != null ? cast function(u:String, a:Int, b:Int):Void{
				pro.loaded = a;
				pro.total = b;
				pro.file = u;
				progress(pro);
			} : null, options);
		#elseif php
			r.request(is_post);
		#end
		
	}
	
}