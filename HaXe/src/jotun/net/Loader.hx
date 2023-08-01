package jotun.net;
import jotun.Jotun;
import jotun.errors.Error;
import jotun.net.HttpRequest;
import jotun.net.Request;
import jotun.tools.Utils;
import jotun.utils.Dice;

#if js
	import js.html.FileReader;
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