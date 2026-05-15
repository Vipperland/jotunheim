package jotun.net;
import haxe.DynamicAccess;
import haxe.Json;
import jotun.Jotun;
import jotun.errors.Error;
import jotun.net.Request;
import jotun.tools.Utils;
import jotun.utils.Dice;

#if js

import jotun.data.BlobCache;
import jotun.dom.Link;

import js.Syntax;
import js.html.AbortController;
import js.html.Blob;
import js.html.DOMError;
import js.html.FormData;
import js.html.RequestInit;
import js.html.Response;
import js.lib.Promise;

typedef IBlobContent = {
	var blob:Bool;
	var content:Blob;
	var name:String;
}

#elseif php

import haxe.Http;

#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Loader implements ILoader {

	public function new() {
	}

	#if js

	private function _endFetch(request:js.html.Request, response:Response, handler:IRequestHandler):Void {
		if (handler.complete != null) {
			handler.complete(new jotun.net.Response(request, response, handler.data, handler.error));
		}
	}

	private function _runFetch(request:js.html.Request, response:Response, handler:IRequestHandler):Void {
		if (handler.promise != null) {
			handler.promise.then(function(data:Dynamic):Void {
				try{
					if (handler.before != null) {
						handler.data = handler.before(data);
					} else{
						handler.data = data;
					}
					_endFetch(request, response, handler);
				} catch (e:Error) {
					Promise.reject(e);
				}
			}).catchError(function(error:DOMError):Void {
				handler.error = error;
				_endFetch(request, response, handler);
			});
		} else{
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
		if (data == null) {
			data = cast { }
		}
		if (data.body != null) {
			if (data.method != null) {
				data.method = data.method.toUpperCase();
			}
			if (data.method == null || data.method == 'GET') {
				url = Utils.createQueryParams(url, data.body);
				(cast data:DynamicAccess<Dynamic>).remove('body');
			} else if (data.method == 'POST') {
				if (!Std.isOfType(data.body, String)) {
					data.body = Json.stringify(data.body);
				}
			}
		}
		if (handler == null) {
			handler = { };
		} else{
			if (handler.type != null) {
				handler.type = handler.type.toLowerCase();
			}
			if (handler.abort != null) {
				data.signal = handler.abort.signal;
			}
		}
		handler.request = new js.html.Request(url, data);
		Syntax.code("fetch({0})", handler.request).then(function(response:Response):Void {
			if (!response.bodyUsed) {
				var request:js.html.Request = handler.request;
				var content:String = response.headers.get('Content-Type');
				if (_matchType(handler.type, content, 'application/json')) {
					// Parse JSON object
					handler.promise = response.json();
					_runFetch(request, response, handler);
				} else if (_matchType(handler.type, content, 'multipart/form-data')) {
					// Parse FORMDATA
					handler.promise = response.formData();
					if (handler.before == null) {
						handler.before = function(data:FormData):Dynamic {
							var res:DynamicAccess<Dynamic> = { };
							data.forEach(function(p:String, v:Dynamic):Void{
								res.set(p, v);
							});
							return res;
						}
					}
					_runFetch(request, response, handler);
				} else if (_matchType(handler.type, content, 'image/', 'audio/', 'video/')) {
					handler.promise = response.blob();
					if (handler.before == null) {
						handler.before = function(blob:Blob):IBlobContent {
							var name:String = request.url.split('/').pop().split('?')[0];
							BlobCache.create(name, blob, false);
							return { blob:true, content:blob, name:name };
						}
					}
					_runFetch(request, response, handler);
				} else if (_matchType(handler.type, content, 'text/css')) {
					handler.promise = response.blob();
					if (handler.before == null) {
						handler.before = Link.fromBlob;
					}
					_runFetch(request, response, handler);
				} else if (_matchType(handler.type, content, 'text/')) {
					handler.promise = response.text();
					if (handler.before == null) {
						handler.before = function(data:String):Dynamic {
							if (handler.module) {
								Jotun.resources.register(url, data);
								return data;
							} else {
								return data;
							}
						}
					}
					_runFetch(request, response, handler);
				} else {
					_runFetch(request, response, handler);
				}
			}
		});
		return handler;
	}

	#end

	public function module(file:String, ?data:Dynamic, ?handler:IRequest->Void):Void {
		#if js
		fetch(file, cast { method: 'GET' }, {
			module: true,
			complete: function(r:jotun.net.Response):Void {
				if (handler != null) handler(new Request(r.success, r.data, cast r.error, file));
			}
		});
		#elseif php
		var r:Http = new Http(file);
		r.onData = function(d) {
			Jotun.resources.register(file, d);
			if (handler != null) handler(new Request(true, d, null, file));
		}
		r.onError = function(d) {
			if (handler != null) handler(new Request(false, null, new Error(-1, d), file));
		}
		r.request(false);
		#end
	}

	public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null):Void {
		#if js
		var init:js.html.RequestInit = cast { method: method != null ? method.toUpperCase() : 'POST' };
		if (data != null) init.body = data;
		if (headers != null) init.headers = headers;
		fetch(url, init, {
			complete: function(r:jotun.net.Response):Void {
				if (handler != null) handler(new Request(r.success, r.data, cast r.error, url));
			}
		});
		#elseif php
		if (method != null) method = method.toUpperCase();
		var is_post:Bool = method == 'POST';
		var is_get:Bool = method == 'GET';
		var is_data:Bool = Std.isOfType(data, String);
		if (is_get && data != null) {
			url += ((url.indexOf('?') == -1) ? '?' : '&') + Utils.paramsOf(data);
		}
		var r:Http = new Http(url);
		if (!is_data && data != null) {
			Dice.All(data, r.setParameter);
		}
		if (headers != null) {
			Dice.All(headers, function(p:String, v:Dynamic):Void { r.setHeader(p, v); });
		}
		r.onData = function(d) {
			if (handler != null) {
				handler(new Request(true, d, null, url, cast r.responseHeaders));
			} 
		}
		r.onError = function(d) {
			if (handler != null) {
				handler(new Request(false, null, new Error(-1, d))); 
			}
		}
		r.request(is_post);
		#end
	}

}
