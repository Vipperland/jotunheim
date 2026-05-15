package jotun.net;
import jotun.signals.Signals;
import jotun.utils.Dice;

#if js
	import jotun.Jotun;
	import js.html.AbortController;
#else
	import haxe.Http;
#end

/**
 * Asset manager and loader. Loads any content type, stores results
 * by alias, and auto-registers module content with Jotun.resources.
 *
 * Usage:
 *   var bundle = new BundleLoader();
 *   bundle.addManifest({
 *       config: "data/config.json",
 *       hero:   "textures/hero.png",
 *       ui:     { url: "modules/ui.html", module: true }
 *   }).start();
 *   bundle.signals.get('completed').add(function(_) {
 *       var cfg = bundle.get('config');
 *       var sounds = bundle.getAll('audio/');
 *   });
 *
 * @author Rafael Moreira
 */

typedef BundleItem = {
	var url:String;
	var ?as:String;
	var ?module:Bool;
	var ?type:String;
	var ?linked:Dynamic;
	var ?on:BundleResult->Void;
}

typedef BundleResult = {
	var file:String;
	var as:String;
	var data:Dynamic;
	var linked:Dynamic;
	var success:Bool;
}

typedef BundleEntry = {
	var alias:String;
	var file:Dynamic;
	var type:String;
}

@:expose("Jtn.BundleLoader")
class BundleLoader {

	public static var EVENT_STARTED:String   = "started";
	public static var EVENT_LOADED:String    = "loaded";
	public static var EVENT_ERROR:String     = "error";
	public static var EVENT_PROGRESS:String  = "progress";
	public static var EVENT_COMPLETED:String = "completed";
	public static var EVENT_RESET:String     = "reset";

	private var _toload:Array<BundleItem>;
	private var _store:Map<String, Dynamic>;
	private var _types:Map<String, String>;

	#if js
	private var _active:Array<AbortController>;
	#else
	private var _active:Array<Http>;
	#end

	private var _isBusy:Bool;
	private var _current:BundleItem;

	public var totalFiles:Int;
	public var totalLoaded:Int;
	public var signals:Signals;
	public var concurrency:Int = 6;

	public function new() {
		signals = new Signals(this);
		_store = [];
		_types = [];
		_active = [];
		reset();
	}

	public function add(item:Dynamic):BundleLoader {
		var bundle:BundleItem = Std.isOfType(item, String) ? { url: cast item } : cast item;
		_toload.push(bundle);
		++totalFiles;
		return this;
	}

	public function addManifest(manifest:Dynamic):BundleLoader {
		Dice.All(manifest, function(alias:String, item:Dynamic):Void {
			if (Std.isOfType(item, String)) {
				add({ url: cast item, as: alias });
			} else {
				if (item.as == null) item.as = alias;
				add(item);
			}
		});
		return this;
	}

	public function get(alias:String):Dynamic {
		return _store.get(alias);
	}

	public function exists(alias:String):Bool {
		return _store.exists(alias);
	}

	public function getAll(type:String):Array<BundleEntry> {
		var result:Array<BundleEntry> = [];
		for (alias => data in _store) {
			var t:String = _types.get(alias);
			if (t != null && t.indexOf(type) != -1) {
				result.push({ alias: alias, file: data, type: t });
			}
		}
		return result;
	}

	public function progress():Float {
		return totalFiles > 0 ? totalLoaded / totalFiles : 0;
	}

	public function start():BundleLoader {
		if (!_isBusy) {
			_isBusy = true;
			_pumpRequests();
		}
		return this;
	}

	private function _key(item:BundleItem):String {
		return item.as != null ? item.as : item.url;
	}

	private function _typeFromUrl(url:String):String {
		var ext:String = url.split('?')[0].split('.').pop().toLowerCase();
		return switch(ext) {
			case 'json':        'application/json';
			case 'html','htm':  'text/html';
			case 'css':         'text/css';
			case 'js':          'text/javascript';
			case 'png':         'image/png';
			case 'jpg','jpeg':  'image/jpeg';
			case 'gif':         'image/gif';
			case 'webp':        'image/webp';
			case 'svg':         'image/svg+xml';
			case 'mp3':         'audio/mpeg';
			case 'ogg':         'audio/ogg';
			case 'wav':         'audio/wav';
			case 'mp4':         'video/mp4';
			case 'webm':        'video/webm';
			default:            'application/octet-stream';
		};
	}

	private function _emit(status:String, item:BundleItem, data:Dynamic, success:Bool):Void {
		var result:BundleResult = { file: item.url, as: _key(item), data: data, linked: item.linked, success: success };
		if (item.on != null) item.on(result);
		signals.call(status, result);
	}

	private function _pumpRequests():Void {
		while (_active.length < concurrency && _toload.length > 0) {
			_startOne(_toload.shift());
		}
		if (_active.length == 0 && _toload.length == 0) {
			_current = null;
			_isBusy = false;
			signals.call(EVENT_COMPLETED, {});
		}
	}

	private function _store_or_register(item:BundleItem, data:Dynamic, type:String):Void {
		var key:String = _key(item);
		if (item.module == true) {
			Jotun.resources.register(key, data);
		} else {
			_store.set(key, data);
			_types.set(key, type);
		}
	}

	private function _afterLoad(item:BundleItem, data:Dynamic, success:Bool, ?type:String):Void {
		++totalLoaded;
		_current = item;
		if (success) _store_or_register(item, data, type != null ? type : _typeFromUrl(item.url));
		_emit(success ? EVENT_LOADED : EVENT_ERROR, item, data, success);
		signals.call(EVENT_PROGRESS, { loaded: totalLoaded, total: totalFiles, progress: progress() });
		_pumpRequests();
	}

	private function _startOne(item:BundleItem):Void {
		_current = item;
		signals.call(EVENT_STARTED, { file: item.url, as: _key(item), linked: item.linked });

		#if js
		var controller:AbortController = new AbortController();
		_active.push(controller);
		Jotun.loader.fetch(item.url, cast { method: 'GET', signal: controller.signal }, {
			type: item.type,
			complete: function(r:jotun.net.Response):Void {
				_active.remove(controller);
				var type:String = r.response != null ? r.response.headers.get('Content-Type') : null;
				_afterLoad(item, r.success ? r.data : r.error, r.success, type);
			}
		});
		#else
		var r:Http = new Http(item.url);
		_active.push(r);
		r.onData  = function(d) { _active.remove(r); _afterLoad(item, d, true); }
		r.onError = function(e) { _active.remove(r); _afterLoad(item, e, false); }
		r.request(false);
		#end
	}

	public function reset():Void {
		_toload = [];
		_store = [];
		_types = [];
		totalLoaded = 0;
		totalFiles = 0;
		if (_active != null && _active.length > 0) {
			var inflight = _active;
			_active = [];
			#if js
			for (c in inflight) c.abort();
			#else
			for (r in inflight) { r.onData = function(_) {}; r.onError = function(_) {}; }
			#end
		}
		_isBusy = false;
		signals.call(EVENT_RESET);
	}

}
