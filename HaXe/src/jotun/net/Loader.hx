package jotun.net;
import haxe.Json;
import jotun.Jotun;
import jotun.errors.Error;
import jotun.errors.IError;
import jotun.net.Request;
import jotun.net.HttpRequest;
import jotun.serial.IOTools;
import jotun.signals.ISignals;
import jotun.signals.Signals;
import jotun.tools.Utils;
import jotun.utils.Dice;

#if js
	import jotun.dom.IDisplay;
	import js.html.FileReader;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("jtn.modules.Loader")
class Loader implements ILoader {
	
	private var _toload:Array<String> = [];
	private var _isBusy:Bool;
	#if js
	private var _fileProgress:Float;
	#end
	public var totalFiles:Int;
	
	public var totalLoaded:Int;
	
	public var lastError:IError;
	
	public var signals:ISignals;
	
	private function _getReq(u:String):HttpRequest {
		return new HttpRequest(u);
	}
	
	public function new(){
		signals = new Signals(this);
		totalLoaded = 0;
		totalFiles = 0;
		#if js
		_fileProgress = 0;
		#end
	}
	
	public function progress():Float {
		#if js
		return (totalLoaded + (_fileProgress < 1 ? _fileProgress : 0)) / totalFiles;
		#else
		return totalLoaded / totalFiles;
		#end
	}
	
	public function add(files:Dynamic):ILoader {
		if (!Std.is(files, Array)){
			files = [files];
		}
		if (files != null && files.length > 0) {
			_toload = _toload.concat(files);
			totalFiles += files.length;
		}
		return this;
	}
	
	public function start():ILoader {
		if (!_isBusy) {
			_isBusy = true;
			_loadNext();
		}
		return this;
	}
	
	private function _changed(file:String, status:String, ?data:String, ?request:HttpRequest):Void {
		signals.call(status, { file:file, data:data, request:request } );
	}
	
	private function _loadNext():Void {
		if (_toload.length > 0) {
			var f:String = _toload.shift();
			var r:HttpRequest = _getReq(f);
			_changed(f, 'started', null, r);
			#if js
				r.async = true;
			#end
			r.onError = function(e) {
				++totalLoaded;
				_changed(f, 'error', e, r);
				_loadNext();
			}
			r.onData = function(d) {
				++totalLoaded;
				Jotun.resources.register(f, d);
				_changed(f, 'loaded', d, r);
				_loadNext();
			}
			#if js
				r.request('GET', null, _onLoadProgress);
			#else
				r.request(null);
			#end
		}else {
			_isBusy = false;
			_complete();
		}
	}
	
	#if js
	private function _onLoadProgress(file:String, loaded:Int, total:Int):Void {
		_fileProgress = loaded / total;
		signals.call('progress', {file:file, loaded:loaded, total:total, progress:_fileProgress});
	}
	#end
	
	private function _error(e:Dynamic):Void {
		lastError = Std.is(e, String) ? new Error( -1, e, this) : new Error( -1, "Unknow", { content:e, loader:this } );
		signals.call('error', lastError);
	}
	
	private function _complete():Void {
		signals.call('completed');
	}
	
	#if js 
	public function module(file:String, ?data:Dynamic, ?handler:IRequest->Void, ?progress:IProgress->Void):Void {
	#elseif php
	public function module(file:String, ?data:Dynamic, ?handler:IRequest->Void):Void {
	#end
		var r:HttpRequest = _getReq(file);
		#if js 
			r.async = true; 
		#end
		_changed(file, 'started', data, r);
		r.onData = function(d) {
			Jotun.resources.register(file, d);
			_changed(file, 'loaded', d, r);
			if (handler != null) {
				handler(new Request(true, d, null, file)); 
			}
		}
		r.onError = function(d) {
			_changed(file, 'error', d, r);
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
	#elseif php
	public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null):Void {
	#end
		if (method != null){
			method = method.toUpperCase();
		}
		var is_post:Bool = method == 'POST';
		var is_get:Bool = method == 'GET';
		var is_data:Bool = Std.is(data, String);
		// Build URL for GET parameters 
		if (is_get && data != null){
			url += ((url.indexOf('?') == -1) ? '?' : '&') + Utils.paramsOf(data);
		}
		// Create request object
		var r:HttpRequest = _getReq(url);
		_changed(url, 'started', data, r);
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
			Dice.All(headers, function(p:String, v:Dynamic){
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
								_changed(url, 'loaded', d, r);
								handler(new Request(true, e.target.result, null, url, hdrs));
							}
							f.readAsDataURL(cast d);
							return;
						}
					}else{
						_changed(url, 'loaded', d, r);
						handler(new Request(true, d, null, url, hdrs)); 
					}
				#else 
					_changed(url, 'loaded', d, r);
					handler(new Request(true, d, null, url, hdrs)); 
				#end
			}
		}
		r.onError = function(d) { 
			_changed(url, 'error', d, r);
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
	
	public function get(module:String, ?data:Dynamic):String {
		return Jotun.resources.get(module, data);
	}
	
}


/*
	[Module:{
		"name"		:"testModule",				// Unique module identifier
		"target"		:"selector",					// Auto append module in target selector
		"require"	:"modA;modB;...;modN",			// Dependencies that will be writed in module
		"filler"		:"myFunctionName"			// Call this function and write returned data in module
	}]
*/