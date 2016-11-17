package sirius.modules;
import sirius.Sirius;
import sirius.errors.Error;
import sirius.errors.IError;
import sirius.modules.Request;
import sirius.net.HttpRequest;
import sirius.signals.ISignals;
import sirius.signals.Signals;
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
	private var _onChange:Array<HttpRequest->String->String->String->Void>;
	private var _onComplete:Array<Dynamic>;
	private var _onError:Array<Dynamic>;
	private var _isBusy:Bool;
	private var _noCache:Bool;
	
	public var totalFiles:Int;
	
	public var totalLoaded:Int;
	
	public var lastError:IError;
	
	public var signals:ISignals;
	
	private function _getReq(u:String):HttpRequest {
		return new HttpRequest(u + (_noCache ? "" : "?t=" + Date.now().getTime()));
	}
	
	public function new(?noCache:Bool = false){
		_noCache = noCache;
		_onComplete = [];
		_onError = [];
		_onChange = [];
		signals = new Signals(this);
		totalLoaded = 0;
		totalFiles = 0;
	}
	
	public function progress():Float {
		return totalLoaded / totalFiles;
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
			r.request(false);
		}else {
			_isBusy = false;
			_complete();
		}
	}
	
	private function _error(e:Dynamic):Void {
		lastError = Std.is(e, String) ? new Error( -1, e, this) : new Error( -1, "Unknow", { content:e, loader:this } );
		signals.call('error', lastError);
	}
	
	private function _complete():Void {
		signals.call('complete');
		_onComplete = [];
		_onError = [];
	}
	
	#if js
	
		public function build(module:String, ?data:Dynamic, ?each:IDisplay->IDisplay = null):IDisplay {
			return Sirius.resources.build(module, data, each);
		}
	
	#end
	
	public function async(file:String, #if js ?target:Dynamic, #end ?data:Dynamic, ?handler:String->String->Void):Void {
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
				handler(file, d);
		}
		r.onError = function(d) {
			_changed(file, 'error', d);
			if (handler != null) 
				handler(null, d);
		}
		r.request(false);
	}
	
	public function request(url:String, ?data:Dynamic, ?handler:IRequest->Void, ?method:String = 'POST', ?headers:Dynamic = null):Void {
		var r:HttpRequest = _getReq(url);
		_changed(url, 'started');
		#if js
			r.async = true;
		#end
		if (data != null) {
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
			_changed(url, 'loaded', d);
			if (handler != null) 
				handler(new Request(true, d, null)); 
		}
		r.onError = function(d) { 
			_changed(url, 'error', d);
			if (handler != null) 
				handler(new Request(false, null, new Error(-1, d))); 
		}
		r.request(method == null || method.toLowerCase() == 'post');
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