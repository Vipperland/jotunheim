package jotun.net;
import haxe.DynamicAccess;
import jotun.Jotun;
import jotun.data.BlobCache;
import jotun.dom.Link;
import jotun.dom.Style;
import jotun.dom.Video;
import jotun.errors.Error;
import jotun.gaming.dataform.Pulsar;
import jotun.net.HttpRequest;
import jotun.net.Request;
import jotun.tools.Utils;
import jotun.utils.Dice;
import js.html.Blob;

#if js
	import js.Syntax;
	import js.html.DOMError;
	import js.html.FileReader;
	import js.html.FormData;
	import js.html.Response;
	import js.lib.Promise;
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
	
	private function _complete(request:js.html.Request, response:Response, promise:Promise<Dynamic>, handler:jotun.net.Response->Void, ?before:Null<Dynamic->Dynamic>):Void {
		promise.then(function(data:Dynamic):Void {
			handler(new jotun.net.Response(request, response, before != null ? before(data) : data, null));
		}).catchError(function(error:DOMError):Void{
			handler(new jotun.net.Response(request, response, null, error));
		});
	}
	
	public function fetch(url:String, ?data:Null<Dynamic>, ?method:String = 'GET', ?handler:Null<jotun.net.Response->Void>, ?headers:Null<Dynamic>):js.html.Request {
		if(method == null){
			method = 'GET';
		}
		if(method.toUpperCase() == 'GET'){
			if (data != null){
				url = Utils.createQueryParams(url, data);
				data = null;
			}
		}
		var request:js.html.Request = new js.html.Request(url, {
			body: data,
			headers: headers,
			method: method,
		});
		Syntax.code("fetch({0})", request).then(function(response:Response):Void {
			if (handler != null){
				var content:String = response.headers.get('Content-Type');
				if (content.indexOf('application/json') != -1){
					// Parse JSON object
					_complete(request, response, response.json(), handler);
				}else if (content.indexOf('multipart/form-data') != -1){
					// Parse FORMDATA
					_complete(request, response, response.formData(), handler, function(data:FormData):Dynamic {
						var res:DynamicAccess<Dynamic> = { };
						data.forEach(function(p:String, v:Dynamic):Void{
							res.set(p, v);
						});
						return res;
					});
				}else if (content.indexOf('image/') != -1 || content.indexOf('audio/') != -1 || content.indexOf('video/') != -1){
					_complete(request, response, response.blob(), handler, function(blob:Blob):{ name:String, blob:Blob } {
						var name:String = request.url.split('/').pop().split('?')[0];
						BlobCache.create(name, blob, false);
						return { name:name, blob:blob };
					});
				}else if (content.indexOf('text/css') != -1){
					_complete(request, response, response.blob(), handler, Link.fromBlob);
				}else if(content.indexOf('text/') != -1){
					var isPulsar:Bool = content.indexOf('text/pulsar') != -1;
					_complete(request, response, response.text(), handler, function(data:String):Dynamic {
						if (isPulsar){
							// Parse PULSAR instructions
							return Pulsar.create(data);
						}else {
							// Return plain text
							return data;
						}
					});
				}else{
					handler(new jotun.net.Response(request, response, null, null));
				}
			}
		});
		return request;
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
	
		return;
	
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