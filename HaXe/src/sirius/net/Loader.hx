package sirius.net;
import haxe.Json;
import sirius.Sirius;
import sirius.errors.Error;
import sirius.errors.IError;
import sirius.net.Request;
import sirius.net.HttpRequest;
import sirius.serial.IOTools;
import sirius.signals.ISignals;
import sirius.signals.Signals;
import sirius.tools.Utils;
import sirius.utils.Dice;

#if js
	import sirius.dom.IDisplay;
#end

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("sru.modules.Loader")
class Loader implements ILoader {
	
	private static var FILES:Dynamic = { };
	
	private var _toload:Array<String> = [];
	private var _isBusy:Bool;
	private var _noCache:Bool;
	#if js
	private var _fileProgress:Float;
	#end
	public var totalFiles:Int;
	
	public var totalLoaded:Int;
	
	public var lastError:IError;
	
	public var signals:ISignals;
	
	private function _getReq(u:String):HttpRequest {
		// baseurl[?|&]_t=timestr
		return new HttpRequest(u);// + (u.indexOf('?') == -1 ? '?' : '&') + '_t=' + (Date.now().getTime()));
	}
	
	public function new(?noCache:Bool = false){
		_noCache = noCache;
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
	
	public function add(files:Array<String>):ILoader {
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
				_changed(f, 'error', e, r);
				++totalLoaded;
				_loadNext();
			}
			r.onData = function(d) {
				_changed(f, 'loaded', d, r);
				++totalLoaded;
				Sirius.resources.register(f, d);
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
	
		public function build(module:String, ?data:Dynamic, ?each:IDisplay->IDisplay = null):IDisplay {
			return Sirius.resources.build(module, data, each);
		}
	
	#end
	
	#if js 
	public function async(file:String, #if js ?target:Dynamic, #end ?data:Dynamic, ?handler:IRequest->Void, ?progress:IProgress->Void):Void {
	#elseif php
	public function async(file:String, ?data:Dynamic, ?handler:IRequest->Void):Void {
	#end
		var h:Array<String> = file.indexOf("#") != -1 ? file.split("#") : [file];
		var r:HttpRequest = _getReq(h[0]);
		#if js 
			r.async = true; 
		#end
		_changed(file, 'started', data, r);
		r.onData = function(d) {
			_changed(file, 'loaded', d, r);
			Sirius.resources.register(file, d);
			#if js
				if (target != null) {
					if(Std.is(target, String)) {
						var e:IDisplay = Sirius.one(target, null);
						if (e != null) {
							if (!Std.is(data, Array)) 
								data = [data];
							e.addChild(build(file, data));
						}
					}else {
						try {
							build(file, data, target);
						}catch (e:Dynamic) {
							Sirius.log(e, 3);
						}
					}
				}
			#end
			if (handler != null) 
				handler(new Request(true, d, null, file)); 
		}
		r.onError = function(d) {
			_changed(file, 'error', d, r);
			if (handler != null) 
				handler(new Request(false, null, new Error(-1, d), file)); 
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
	public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null, ?progress:IProgress->Void):Void {
	#elseif php
	public function request(url:String, ?data:Dynamic, ?method:String = 'POST', ?handler:IRequest->Void, ?headers:Dynamic = null):Void {
	#end
		if (method == null || method == '') {
			method = 'POST';
		}else{
			method = method.toUpperCase();
		}
		var is_post:Bool = method == 'POST';
		var is_get:Bool = method == 'GET';
		var is_json:Bool = Std.is(data, String);
		// Build URL for GET parameters
		if (method == 'GET'){
			var ps:Array<String> = url.split('?');
			if (ps.length == 1 || ps[1].length == 0){
				ps[1] = Utils.paramsOf(data);
			}else{
				ps[1] += '&' + Utils.paramsOf(data);
			}
			url = ps.join('?');
		}
		// Create request object
		var r:HttpRequest = _getReq(url);
		_changed(url, 'started', data, r);
		#if js
			r.async = true;
		#end
		// Parse parameters
		if (!is_json && data != null) {
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
			_changed(url, 'loaded', d, r);
			if (handler != null) 
				handler(new Request(true, d, null)); 
		}
		r.onError = function(d) { 
			_changed(url, 'error', d, r);
			if (handler != null) 
				handler(new Request(false, null, new Error(-1, d))); 
		}
		#if js
			var pro:IProgress = cast {loaded:0,total:0,file:url};
			r.request(method, data, progress != null ? cast function(u:String, a:Int, b:Int):Void{
				pro.loaded = a;
				pro.total = b;
				pro.file = u;
				progress(pro);
			} : null);
		#elseif php
			r.request(is_post);
		#end
		
	}
	
	public function get(module:String, ?data:Dynamic):String {
		return Sirius.resources.get(module, data);
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