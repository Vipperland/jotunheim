package jotun.net;
import haxe.DynamicAccess;
import jotun.net.BulkLoader;
import jotun.net.HttpRequest;
import jotun.net.Request;

/**
 * ...
 * @author Rafael Moreira
 */
class ModBulkLoader extends BulkLoader {

	override function _onLoaded(data:Dynamic, request:HttpRequest):Void {
		Jotun.resources.register(_current.url, data);
		super._onLoaded(data, request);
	}
	
	public function new(?options:DynamicAccess<Dynamic>) {
		super(options);
	}
	
}