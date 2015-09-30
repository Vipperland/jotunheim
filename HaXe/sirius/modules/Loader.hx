package sirius.modules;
import haxe.Http;
import haxe.Log;
import sirius.errors.Error;
import sirius.errors.IError;
import sirius.modules.Request;
import sirius.modules.ModLib;
import sirius.Sirius;
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
	private var _onComplete:Array<Dynamic>;
	private var _onError:Array<Dynamic>;
	private var _isBusy:Bool;
	private var _noCache:Bool;
	
	public var totalFiles:Int;
	
	public var totalLoaded:Int;
	
	public var lastError:IError;
	
	public function new(?noCache:Bool = false){
		_noCache = noCache;
		_onComplete = [];
		_onError = [];
		totalLoaded = 0;
		totalFiles = 0;
	}
	
	public function progress():Float {
		return totalLoaded / totalFiles;
	}
	
	public function listen(?complete:ILoader->Void, ?error:IError->Void):ILoader {
		if (error != null && Lambda.indexOf(_onError, error) == -1) {
			_onError[_onError.length] = error;
		}
		if (complete != null && Lambda.indexOf(_onComplete, complete) == -1) {
			_onComplete[_onComplete.length] = complete;
		}
		return this;
	}
	
	public function add(files:Array<String>, ?complete:ILoader->Void, ?error:IError->Void):ILoader {
		listen(complete, error);
		if (files != null && files.length > 0) {
			_toload = _toload.concat(files);
			totalFiles += files.length;
		}
		return this;
	}
	
	public function start(?complete:ILoader->Void, ?error:IError->Void):ILoader {
		if (!_isBusy) {
			listen(complete, error);
			_isBusy = true;
			_loadNext();
		}
		return this;
	}
	
	private function _loadNext():Void {
		if (_toload.length > 0) {
			var f:String = _toload.shift();
			var r:Http = new Http(f + (_noCache ? "" : "?t=" + Date.now().getTime()));
			#if js
				r.async = true;
			#end
			r.onError = function(e) {
				++totalLoaded;
				if (_error != null) _error(e);
				_loadNext();
			}
			r.onData = function(d) {
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
		Dice.Values(_onError, function(v:IError->Void) {
			if (v != null) v(lastError);
		});
	}
	
	private function _complete():Void {
		Dice.Values(_onComplete, function(v:ILoader->Void) {
			if (v != null) v(this);
		});
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
		var r:Http = new Http(h[0] + (_noCache ? "" : "?t=" + Date.now().getTime()));
		#if js 
			r.async = true; 
		#end
		r.onData = function(d) {
			Sirius.resources.register(file, d);
			file = h.length == 2 ? h[1] : file;
			#if js
				if (target != null) {
					if(Std.is(target, String)) {
						var e:IDisplay = Sirius.one(target, null);
						if (e != null) {
							if (!Std.is(data, Array)) data = [data];
							e.addChild(build(file, data));
						}
					}else {
						try {
							build(file, data, target);
						}catch (e:Dynamic) {
							Sirius.log(e, 10, 3);
						}
					}
				}
			#end
			if (handler != null) handler(file, d);
		}
		r.request(false);
	}
	
	public function request(url:String, ?data:Dynamic, ?handler:IRequest->Void, method:String = 'post'):Void {
		var r:Http = new Http(url + (_noCache ? "" : "?t=" + Date.now().getTime()));
		#if js
			r.async = true;
		#end
		if (data != null) Dice.All(data, r.setParameter);
		r.onData = function(d) { if (handler != null) handler(new Request(true, d, null)); }
		r.onError = function(d) { if (handler != null) handler(new Request(false, null, new Error(-1, d))); }
		r.request(method != null && method.toLowerCase() == 'post');
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
		"filler"		:"myFunctionName",			// Call this function and write returned data in module
		"repeat"		: true | false				// Repeat module structure for each property in filler result
	}]
*/