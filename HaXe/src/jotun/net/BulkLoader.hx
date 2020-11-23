package jotun.net;
import jotun.errors.Error;
import jotun.errors.IError;
import jotun.signals.ISignals;
import jotun.signals.Signals;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose("J_BulkLoader")
class BulkLoader {

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
	
	public function add(files:Dynamic):Void {
		if (!Std.is(files, Array)){
			files = [files];
		}
		if (files != null && files.length > 0) {
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
	
}