package sirius.php.utils;
import php.Boot;
import php.Web;

/**
 * ...
 * @author Rafael Moreira
 */
class Header{
	
	static public var HTML:String = 'text/html;charset=utf-8';
	
	static public var TEXT:String = 'text/plain;charset=utf-8';
	
	static public var JSON:String = 'application/json;charset=utf-8';
	
	static public var JSONP:String = 'application/javascript;charset=utf-8';
	
	public function new() {
		
	}
	
	public function access(origin:String = '*', ?methods:String = 'GET,POST,OPTIONS', ?headers:String = 'Origin,Content-Type,Accept,Authorization,X-Request-With', ?credentials:Bool = true):Void {
		Web.setHeader('Access-Control-Allow-Origin', origin);
		Web.setHeader('Access-Control-Allow-Methods', methods);
		Web.setHeader('Access-Control-Allow-Headers', headers);
		Web.setHeader('Access-Control-Allow-Credentials', Std.string(credentials));
	}
	
	public function content(type:String):Void {
		Web.setHeader('content-type:', type);
	}
	
	public function setJSON():Void {
		content(JSON);
	}
	
	public function setTEXT():Void {
		content(TEXT);
	}
	
}