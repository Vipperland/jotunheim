package sirius.modules;
import haxe.Http;
import sirius.modules.ModLib;
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
	
	public var lastError:Dynamic;
	
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
	
	public function listen(?complete:Dynamic, ?error:Dynamic):ILoader {
		if (error != null && Lambda.indexOf(_onError, error) == -1) {
			_onError[_onError.length] = error;
		}
		if (complete != null && Lambda.indexOf(_onComplete, complete) == -1) {
			_onComplete[_onComplete.length] = complete;
		}
		return this;
	}
	
	public function add(files:Array<String>, ?complete:Dynamic, ?error:Dynamic):ILoader {
		listen(complete, error);
		if (files != null && files.length > 0) {
			_toload = _toload.concat(files);
			totalFiles += files.length;
		}
		return this;
	}
	
	public function start(?complete:Dynamic, ?error:Dynamic):ILoader {
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
				if (_error != null) {
					_error(e);
				}
				_loadNext();
			}
			r.onData = function(d) {
				++totalLoaded;
				ModLib.register(f, d);
				_loadNext();
			}
			r.request(false);
		}else {
			_isBusy = false;
			_complete();
		}
	}
	
	private function _error(e:Dynamic):Void {
		lastError = e;
		Dice.Values(_onError, function(v:Dynamic) {
			if (v != null) v(this);
		});
	}
	
	private function _complete():Void {
		Dice.Values(_onComplete, function(v:Dynamic) {
			if (v != null) v(this);
		});
		_onComplete = [];
		_onError = [];
	}
	
	#if js
	
		public function build(module:String, ?data:Dynamic):IDisplay {
			return ModLib.build(module, data);
		}
		
		public function async(file:String, ?target:String, ?data:Dynamic, ?handler:Dynamic):Void {
			var r:Http = new Http(file + (_noCache ? "" : "?t=" + Date.now().getTime()));
			r.async = true;
			r.onData = function(d) {
				ModLib.register(file, d);
				if (target != null) {
					var d:IDisplay = Sirius.one(target, null, function(t:IDisplay) {
						if (!Std.is(data, Array)) data = [data];
						Dice.All(data, function(p:Int, v:Dynamic) {
							Reflect.setField(v, '%i', p);
							t.addChild(build(file, v));
						});
					});
				}
				if (handler != null) handler(file, d);
			}
			r.request(false);
		}
		
	#end
	
	public function get(module:String, ?data:Dynamic):String {
		return ModLib.get(module, data);
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