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
	var request:HttpRequest;
}

typedef BulkLoaderFlow = {
	public var data:BulkLoaderSignal;
	public var pipe:Pipe;
}
/**
 * ...
 * @author Rafael Moreira
 */
@:expose("Crab.BulkLoader")
class BulkLoader {

	public static var EVENT_STARTED:String = "started";
	
	public static var EVENT_LOADED:String = "loaded";
	
	public static var EVENT_ERROR:String = "error";
	
	public static var EVENT_PROGRESS:String = "progress";
	
	public static var EVENT_COMPLETED:String = "completed";
	
	public static var EVENT_RESET:String = "reset";
	
	private var _toload:Array<String>;
	
	private var _isBusy:Bool;
	#if js
		private var _fileProgress:Float;
	#end
	public var totalFiles:Int;
	
	public var totalLoaded:Int;
	
	public var lastError:ErrorDescriptior;
	
	public var signals:Signals;
	
	public var options:DynamicAccess<Dynamic>;
	
	private var _req:HttpRequest;
	
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
		reset();
	}
	
	public function progress():Float {
		#if js
			return (totalLoaded + (_fileProgress < 1 ? _fileProgress : 0)) / totalFiles;
		#else
			return totalLoaded / totalFiles;
		#end
	}
	
	public function add(files:Rest<String>):Void {
		if (files.length > 0) {
			_toload = _toload.concat(files);
			totalFiles += files.length;
		}
	}
	
	public function start():Void {
		if (!_isBusy) {
			_isBusy = true;
			_loadNext();
		}
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
				_req = null;
				++totalLoaded;
				_changed(f, 'error', e, r);
				_loadNext();
			}
			r.onData = function(d) {
				_req = null;
				++totalLoaded;
				//jotun.resources.register(f, d);
				_changed(f, 'loaded', d, r);
				_loadNext();
			}
			#if js
				r.request('GET', null, _onLoadProgress, options);
			#else
				r.request(null);
			#end
			_req = r;
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
	
	public function toImage(file:HttpRequest):Img {
		return Img.fromBlob(cast file.data);
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
		if(_isBusy && _req != null){
			_req.cancel();
			_req = null;
		}
		_isBusy = false;
		lastError = null;
		signals.call('reset');
	}
	
}