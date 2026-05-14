package jotun.net;
import haxe.DynamicAccess;
import haxe.Rest;
import jotun.errors.Error;
import jotun.errors.ErrorDescriptior;
import jotun.signals.Pipe;
import jotun.signals.Signals;
import jotun.tools.Utils;

#if js
	import jotun.dom.Img;
#end

typedef BulkLoaderSignal = {
	var file:String;
	var data:Dynamic;
	var linked:Dynamic;
	var request:HttpRequest;
}

typedef BulkLoaderFlow = {
	public var data:BulkLoaderSignal;
	public var pipe:Pipe;
}

typedef SingleFile = {
	public var url:String;
	public var ?data:Dynamic;
}
/**
 * ...
 * @author Rafael Moreira
 */
@:expose("Siri.BulkLoader")
class BulkLoader {

	public static var EVENT_STARTED:String = "started";

	public static var EVENT_LOADED:String = "loaded";

	public static var EVENT_ERROR:String = "error";

	public static var EVENT_PROGRESS:String = "progress";

	public static var EVENT_COMPLETED:String = "completed";

	public static var EVENT_RESET:String = "reset";

	private var _toload:Array<Dynamic>;

	private var _active:Array<HttpRequest>;

	private var _isBusy:Bool;
	#if js
		private var _fileProgress:Float;
	#end
	public var totalFiles:Int;

	public var totalLoaded:Int;

	public var lastError:ErrorDescriptior;

	public var signals:Signals;

	public var options:DynamicAccess<Dynamic>;

	public var concurrency:Int = 6;

	private var _current:SingleFile;

	private function _getReq(u:String):HttpRequest {
		return new HttpRequest(u);
	}

	/**
	 * options.responseType = 'blob';
	 * @param	options
	 */
	public function new(?options:DynamicAccess<Dynamic>){
		signals = new Signals(this);
		this.options = options;
		_active = [];
		reset();
	}

	public function progress():Float {
		return totalFiles > 0 ? totalLoaded / totalFiles : 0;
	}

	public function add(files:Rest<Dynamic>):Void {
		if (files.length > 0) {
			_toload = _toload.concat(files);
			totalFiles += files.length;
		}
	}

	public function start():Void {
		if (!_isBusy) {
			_isBusy = true;
			_pumpRequests();
		}
	}

	private function _onLoaded(data:Dynamic, request:HttpRequest):Void {
		_changed('loaded', data, request);
		_pumpRequests();
	}

	private function _changed(status:String, ?data:String, ?request:HttpRequest):Void {
		signals.call(status, { file:_current.url, data:data, request:request, linked:_current.data } );
	}

	private function _loadNext():Void {
		_pumpRequests();
	}

	private function _pumpRequests():Void {
		while (_active.length < concurrency && _toload.length > 0) {
			_startOne(_toload.shift());
		}
		if (_active.length == 0 && _toload.length == 0) {
			_current = null;
			_isBusy = false;
			_complete();
		}
	}

	private function _startOne(item:Dynamic):Void {
		var single:SingleFile = Std.isOfType(item, String) ? { url: cast item } : cast item;
		var f:String = single.url;
		var r:HttpRequest = _getReq(f);
		_active.push(r);
		_current = single;
		_changed('started', null, r);
		#if js
			r.async = true;
		#end
		r.onError = function(e) {
			_active.remove(r);
			++totalLoaded;
			_current = single;
			_changed('error', e, r);
			_pumpRequests();
		}
		r.onData = function(d) {
			_active.remove(r);
			++totalLoaded;
			_current = single;
			_onLoaded(d, r);
		}
		#if js
			r.request('GET', null, _onLoadProgress, options);
		#else
			r.request(null);
		#end
	}

	#if js

	private function _onLoadProgress(file:String, loaded:Int, total:Int):Void {
		_fileProgress = total > 0 ? loaded / total : 0;
		signals.call('progress', {file:file, loaded:loaded, total:total, progress:_fileProgress});
	}

	#end

	private function _error(e:Dynamic):Void {
		lastError = Std.isOfType(e, String) ? new Error( -1, e, this) : new Error( -1, "Unknow", { content:e, loader:this } );
		signals.call('error', lastError);
	}

	private function _complete():Void {
		signals.call('completed', { });
	}

	public function reset():Void {
		_toload = [];
		totalLoaded = 0;
		totalFiles = 0;
		#if js
		_fileProgress = 0;
		#end
		if(_active != null && _active.length > 0){
			var inflight = _active;
			_active = [];
			for (r in inflight){
				r.onData = function(_){};
				r.onError = function(_){};
				r.cancel();
			}
		}
		_isBusy = false;
		lastError = null;
		signals.call('reset');
	}

}
