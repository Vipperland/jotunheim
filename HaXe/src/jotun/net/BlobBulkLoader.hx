package jotun.net;
import haxe.DynamicAccess;
import jotun.dom.Img;
import jotun.gaming.SpritesheetLibrary;
import jotun.net.BulkLoader;
import jotun.net.new;
import jotun.signals.Flow;
import js.html.Blob;

typedef SpriteData = {
	var name:String;
	var cropData:Array<Dynamic>;
}

/**
 * ...
 * @author Rafael Moreira
 */
class BlobBulkLoader extends BulkLoader {

	public static var EVENT_CROPPING:String = "cropping";
	
	public var library:SpritesheetLibrary;
	
	override function _onLoaded(data:Dynamic, request:HttpRequest):Void {
		var spriteData:SpriteData = _current.data;
		library.add(spriteData.name, data, spriteData.frames);
		super._onLoaded(data, request);
	}
	
	public function new(?options:DynamicAccess<Dynamic>) {
		if(options == null){
			options = { };
		}
		options.set('responseType', 'blob');
		library = new SpritesheetLibrary();
		library.signals.add(SpritesheetLibrary.EVENT_COMPLETED, _onSpriteComplete);
		library.signals.add(SpritesheetLibrary.EVENT_PROGRESS, _onSpriteProgress);
		super(options);
	}
	
	public function addSprite(url:String, data:SpriteData):Void {
		add({
			url: url,
			data: data
		});
	}
	
	private function _onSpriteComplete(signal:Signal):Void {
		if (_toload.length == 0){
			super._complete();
		}
	}
	
	
	private function _onSpriteProgress(signal:Signal):Void {
		signals.call(EVENT_CROPPING, { progress: signal.data.progress });
	}
	
	override function _complete():Void {
		if(library.isLoaded()){
			super._complete();
		}
	}
	
}