package jotun.data;
import jotun.dom.Img;
import jotun.utils.Dice;
import js.html.Blob;
import js.html.URL;

/**
 * ...
 * @author Rafael Moreira
 */
@:expose('BlobCache')
class BlobCache {

	private static var _BlobRefs:List<IBlobInfo> = new List<IBlobInfo>();
	
	public static function create(name:String, data:Blob, weakRef:Bool = true):String {
		revoke(name);
		Reflect.setField(_BlobRefs, name, {
			blob: data,
			url: URL.createObjectURL(data),
			usage: 0,
			weak: weakRef,
		});
		return name;
	}
	
	public static function setWeak(name:String):Void {
		var blob:IBlobInfo = Reflect.field(_BlobRefs, name);
		if (blob != null){
			
		}
	}
	
	public static function revoke(name:String):Void {
		if(Reflect.hasField(_BlobRefs, name)){
			URL.revokeObjectURL(Reflect.field(_BlobRefs, name).url);
			Reflect.deleteField(_BlobRefs, name);
		}
	}
	
	public static function load(name:String):String {
		var blob:IBlobInfo = Reflect.field(_BlobRefs, name);
		if(blob != null){
			++blob.usage;
			return blob.url;
		}else{
			return null;
		}
	}
	
	public static function unload(name:String):Void {
		var blob:IBlobInfo = Reflect.field(_BlobRefs, name);
		if(blob != null){
			if(--blob.usage <= 0){
				blob.usage = 0;
				if(blob.weak){
					revoke(name);
				}
			}
		}
	}
	
	public static function flush():Void {
		Dice.All(_BlobRefs, function(p:String, v:IBlobInfo):Void {
			revoke(p);
		});
	}
	
	public static function image(name:String):Img {
		return new Img().blob(name);
	}
	
}
private interface IBlobInfo {
	var blob:Blob;
	var url:String;
	var usage:Int;
	var weak:Bool;
}