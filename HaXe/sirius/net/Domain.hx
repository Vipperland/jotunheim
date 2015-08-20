package sirius.net;
import haxe.Log;
import js.Browser;
import js.html.Location;
import sirius.data.DataCache;
import sirius.dom.Display;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Domain {
	
	public var host:String;
	
	public var port:String;
	
	public var fragments:Array<String>;
	
	public var hash:String;
	
	public var firstFragment:String;
	
	public var lastFragment:String;
	
	public var directory:String;
	
	public var extension:String;
	
	public var tempData:DataCache;
	
	public var cachedData:DataCache;
	
	public function new() {
		_parseURI();
		cachedData = Display.PERSISTENT = new DataCache('persistent', 2592000, 'http://' + host + '/');
		tempData = Display.TEMP = new DataCache('temporary', 360, 'http://' + host + '/');
	}
	
	private function _parseURI():Void {
		var l:Location = Browser.window.location;
		host = l.hostname;
		port = l.port;
		fragments = Utils.fixArray(l.pathname.split("/"));
		firstFragment = fragment(0, "");
		lastFragment = fragment(fragments.length - 1, firstFragment);
		extension = lastFragment.split(".").pop();
		hash = l.hash.substr(1);
	}
	
	public function fragment(i:Int, ?a:String):String {
		return i >= 0 && i < fragments.length ? fragments[i] : a;
	}
	
	public function reload(?force:Bool=false):Void {
		Browser.window.location.reload(force);
	}
	
	
}