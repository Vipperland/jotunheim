package jotun.dom;
import jotun.Jotun;
import js.Browser;
import js.html.Blob;
import js.html.ImageElement;
import js.html.XMLHttpRequest;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose("J_dom_Img")
class Img extends Display {
	
	static public function get(q:String):Img {
		return cast Jotun.one(q);
	}
	
	static public function urlToBlob(url:String):Img {
		var img:Img = new Img();
		img.loadBinary(url);
		return img;
	}
	
	static public function blobToSrc(content:String):String {
		var blob:Blob = new Blob([content], {type: 'image/svg-xml'});
		return Utils.fileToURL(blob);
	}
	
	private var _loader:XMLHttpRequest;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createImageElement();
		super(q, null);
	}
	
	public function src(?value:Dynamic):String {
		var a:ImageElement;
		if (value != null) {
			var src:String = null;
			var evt:Dynamic = {};
			if (Std.is(value, Blob)){
				src = Utils.fileToURL(value);
				evt.blob = value;
			}else if (value.indexOf('<svg') != -1 && value.indexOf('</svg>') != -1){
				src = blobToSrc(value);
				evt.svg = value;
			}else{
				src = value;
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
		_loader = new XMLHttpRequest();
		_loader.open('GET', url, true);
		_loader.responseType = cast "arraybuffer";
		_loader.send(null);
		_loader.onload = function(e:Dynamic){
			var blob:Blob = new Blob([e.target.response], {type: 'image/svg-xml'});
			src(blob);
			events.progress().call(false, true, {completed:true});
			abort();
		}
		_loader.onprogress = function(e:Dynamic){
			events.progress().call(false, true, e);
		}
		_loader.onerror = function(e:Dynamic){
			events.error().call(false, true, e);
			abort();
		}
	}
	
	private function abort():Void {
		if (_loader != null){
			_loader.abort();
			_loader.onload = null;
			_loader.onprogress = null;
			_loader.onerror = null;
			_loader = null;
		}
	}
	
}