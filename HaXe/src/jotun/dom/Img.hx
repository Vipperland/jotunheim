package jotun.dom;
import jotun.Jotun;
import jotun.data.BlobCache;
import js.Browser;
import js.lib.Error;
import js.html.Blob;
import js.html.ImageElement;
import js.html.AbortController;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("Jtn.Img")
class Img extends Display {

	private var _blob:String;

	static public function get(q:String):Img {
		return cast Jotun.one(q);
	}

	static public function urlToBlob(url:String):Img {
		var img:Img = new Img();
		img.loadBinary(url);
		return img;
	}

	static public function fromBlob(blob:Blob):Img {
		var img:Img = new Img();
		img.src(Utils.fileToURL(blob));
		return img;
	}

	private var _loader:AbortController;

	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createImageElement();
		super(q, null);
	}

	public function blob(name:String):Img {
		src(BlobCache.load(name));
		return this;
	}

	public function src(?value:Dynamic):String {
		if (_blob != null){
			BlobCache.revoke(_blob);
			_blob = null;
		}
		var a:ImageElement;
		if (value != null) {
			var src:String = null;
			var evt:Dynamic = {};
			if (Std.isOfType(value, Blob)){
				_blob = BlobCache.create('blob:' + id(), value, true);
			}else if (value.indexOf('<svg') != -1 && value.indexOf('</svg>') != -1){
				_blob = BlobCache.create('blob:' + id(), new Blob([value], {type: 'image/svg-xml'}), true);
			}else{
				src = value;
			}
			if(_blob != null){
				src = BlobCache.load(_blob);
			}
			value = (cast element).src;
			if (src != value){
				evt.src = src;
				(cast element).src = src;
				events.change().call(false, true, evt);
			}
			return value;
		}else{
			return (cast element).src;
		}
	}

	public function alt(?value:String):String {
		if (value != null) (cast element).alt = value;
		return (cast element).alt;
	}

	public function loadBinary(url:String):Void {
		abort();
		_loader = new AbortController();
		Jotun.loader.fetch(url, cast { method: 'GET' }, {
			abort: _loader,
			complete: function(r:jotun.net.Response):Void {
				_loader = null;
				if (r.success) {
					src(r.data.content);
					events.progress().call(false, true, { completed: true });
				} else {
					events.error().call(false, true, r.error);
				}
			}
		});
	}

	private function abort():Void {
		if (_loader != null) {
			_loader.abort();
			_loader = null;
		}
	}

	override public function dispose():Void {
		abort();
		if(cast (element, ImageElement).src.indexOf('blob:') == 0){
			if(_blob != null){
				BlobCache.revoke(_blob);
			}
		}
		super.dispose();
	}

}
