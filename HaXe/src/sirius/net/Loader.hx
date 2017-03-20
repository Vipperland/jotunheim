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
		return new HttpRequest(u + (_noCache ? "" : "?t=" + Date.now().getTime()));
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
	
	private function _changed(file:String, status:String, ?data:String):Void {
		signals.call(status, { file:file, data:data } );
	}
	
	private function _loadNext():Void {
		if (_toload.length > 0) {
			var f:String = _toload.shift();
			var r:HttpRequest = _getReq(f);
			_changed(f, 'started');
			#if js
				r.async = true;
			#end
			r.onError = function(e) {
				_changed(f, 'error', e);
				++totalLoaded;
				_loadNext();
			}
			r.onData = function(d) {
				_changed(f, 'loaded', d);
				++totalLoaded;
				Sirius.resources.register(f, d);
				_loadNext();
			}
			#if js
				r.request(false, _onLoadProgress);
			#else
				r.request(false);
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
	public function async(file:String, #if js ?target:Dynamic, #end ?data:Dynamic, ?handler:IRequest->Void #if js, ?progress:IProgress->Void #end):Void {
	#elseif php
	public function async(file:String, ?data:Dynamic, ?handler:IRequest->Void):Void {
	#end
		var h:Array<String> = file.indexOf("#") != -1 ? file.split("#") : [file];
		var r:HttpRequest = _getReq(h[0]);
		#if js 
			r.async = true; 
		#end
		_changed(file, 'started');
		r.onData = function(d) {
			_changed(file, 'loaded', d);
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
			_changed(file, 'error', d);
			if (handler != null) 
				handler(new Request(false, null, new Error(-1, d), file)); 
		}
		#if js
			if (progress == null){
				r.request(false);
			}else{
				var pro:IProgress = cast {loaded:0,total:0,file:file};
				r.request(false, cast function(u:String, a:Int, b:Int):Void{
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
	public function request(url:String, ?data:Dynamic, ?handler:IRequest->Void, ?method:String = 'POST', ?headers:Dynamic = null, ?progress:IProgress->Void):Void {
	#elseif php
	public function request(url:String, ?data:Dynamic, ?handler:IRequest->Void, ?method:String = 'POST', ?headers:Dynamic = null):Void {
	#end
		var setpost:Bool = method == null || method.toUpperCase() == 'POST';
		var setjson:Bool = !setpost && method.toUpperCase() == 'JSON';
		if (!setpost && !setjson && data != null){
			var ps:Array<String> = url.split('?');
			if (ps.length == 1 || ps[1].length == 0){
				ps[1] = Utils.paramsOf(data);
			}else{
				ps[1] += '&' + Utils.paramsOf(data);
			}
			url = ps.join('?');
		}
		var r:HttpRequest = _getReq(url);
		_changed(url, 'started');
		#if js
			r.async = true;
		#end
		if (!setjson && setpost && data != null) {
			#if js
				Dice.All(data, r.addParameter);
			#else
				Dice.All(data, r.setParameter);
			#end
		}
		if (headers != null){
			Dice.All(headers, function(p:String, v:Dynamic){
				if (p == 'auth' && !Std.is(v, String)){
					p = 'Authorization';
					v = 'Basic ' + IOTools.encodeBase64(v.user + ':' + v.password);
				}else if (p == 'oauth'){
					p = 'Authorization';
					v = 'OAuth ' + v;
				}
				r.setHeader(p, v);
			});
		}
		r.onData = function(d) { 
			_changed(url, 'loaded', d);
			if (handler != null) 
				handler(new Request(true, d, null)); 
		}
		r.onError = function(d) { 
			_changed(url, 'error', d);
			if (handler != null) 
				handler(new Request(false, null, new Error(-1, d))); 
		}
		#if js
			var pro:IProgress = cast {loaded:0,total:0,file:url};
			r.request(setjson ? data : setpost, progress != null ? cast function(u:String, a:Int, b:Int):Void{
				pro.loaded = a;
				pro.total = b;
				pro.file = u;
				progress(pro);
			} : null);
		#elseif php
			r.request(setpost);
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