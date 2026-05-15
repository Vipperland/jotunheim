package jotun.data;
import jotun.dom.Img;
import js.html.Blob;
import js.html.URL;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('BlobCache')
class BlobCache {

	private static var _BlobRefs:Map<String, IBlobInfo> = new Map<String, IBlobInfo>();

	public static function create(name:String, data:Blob, weakRef:Bool = true):String {
		revoke(name);
		_BlobRefs.set(name, {
			blob: data,
			url: URL.createObjectURL(data),
			usage: 0,
			weak: weakRef,
		});
		return name;
	}

	public static function setWeak(name:String):Void {
		var blob:IBlobInfo = _BlobRefs.get(name);
		if (blob != null) {
			blob.weak = true;
			if (blob.usage == 0) revoke(name);
		}
	}

	public static function revoke(name:String):Void {
		var blob:IBlobInfo = _BlobRefs.get(name);
		if (blob != null) {
			URL.revokeObjectURL(blob.url);
			_BlobRefs.remove(name);
		}
	}

	public static function load(name:String):String {
		var blob:IBlobInfo = _BlobRefs.get(name);
		if (blob != null) {
			++blob.usage;
			return blob.url;
		}
		return null;
	}

	public static function unload(name:String):Void {
		var blob:IBlobInfo = _BlobRefs.get(name);
		if (blob != null) {
			if (--blob.usage <= 0) {
				blob.usage = 0;
				if (blob.weak) revoke(name);
			}
		}
	}

	public static function flush():Void {
		for (blob in _BlobRefs) {
			URL.revokeObjectURL(blob.url);
		}
		_BlobRefs.clear();
	}

	public static function image(name:String):Img {
		return new Img().blob(name);
	}

}

private typedef IBlobInfo = {
	var blob:Blob;
	var url:String;
	var usage:Int;
	var weak:Bool;
}
