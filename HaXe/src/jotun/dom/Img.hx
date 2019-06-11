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
@:expose("jtn.dom.Img")
class Img extends Display {
	
	static public function get(q:String):Img {
		return cast Jotun.one(q);
	}
	
	public var object:ImageElement;
	
	public function new(?q:Dynamic) {
		if (q == null) q = Browser.document.createImageElement();
		super(q, null);
		object = cast element;
	}
	
	public function src(?value:String):String {
		var a:ImageElement;
		if (value != null) object.src = value;
		return object.src;
	}
	
	public function alt(?value:String):String {
		if (value != null) object.alt = value;
		return object.alt;
	}
	
	public function loadBinary(url:String):Void {
		var req:XMLHttpRequest = new XMLHttpRequest();
		var url:String = url;
		req.open('GET', url, true);
		req.responseType = cast "arraybuffer";
		req.send(null);
		req.onload = function(e:Dynamic){
			var blob = new Blob([e.target.response]);
			src(Utils.fileToURL(cast blob));
			events.progress().call(false, true, {completed:true});
		}
		req.onprogress = function(e:Dynamic){
			events.progress().call(false, true, e);
		}
		req.onerror = function(e:Dynamic){
			events.error().call(false, true, e);
		}
	}
	
}