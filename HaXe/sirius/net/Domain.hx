package sirius.net;
import js.Browser;
import js.html.Location;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
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
	
	
	public function new() {
		_parseURI();
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