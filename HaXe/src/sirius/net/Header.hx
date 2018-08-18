package sirius.net;
import haxe.Json;
import php.Lib;
import php.Web;
import sirius.serial.JsonTool;
import sirius.tools.Flag;
import sirius.serial.IOTools;
import sirius.utils.Dice;


/**
 * ...
 * @author Rafael Moreira
 */
class Header {
	
	static public var HTML:String = 'text/html;charset=utf-8';
	
	static public var TEXT:String = 'text/plain;charset=utf-8';
	
	static public var JSON:String = 'application/json;charset=utf-8';
	
	static public var JSONP:String = 'application/javascript;charset=utf-8';
	
	static public var hasType:Bool = false;
	
	static private var _client_headers:Dynamic;
	
	public function new() {
		
	}
	
	public function access(origin:String = '*', ?methods:String = 'GET,POST,OPTIONS', ?headers:String = 'Origin,Content-Type,Accept,Authorization,X-Request-With', ?credentials:Bool = true):Void {
		Web.setHeader('Access-Control-Allow-Origin', origin);
		Web.setHeader('Access-Control-Allow-Methods', methods);
		Web.setHeader('Access-Control-Allow-Headers', headers);
		Web.setHeader('Access-Control-Allow-Credentials', Std.string(credentials));
	}
	
	public function content(type:String):Void {
		if(!hasType){
			hasType = true;
			Web.setHeader('content-type', type);
		}
	}
	
	public function setHTML(?data:Dynamic):Void {
		content(HTML);
		if (data != null) {
			Web.setHeader('Content-Length', Std.string(data.length));
			Lib.print(data);
		}
	}
	
	public function setJSON(?data:Dynamic, ?encode:Bool):Void {
		content(JSON);
		if (data != null) {
			data = JsonTool.stringfy(data, null, '\t');
			writeData(data, encode);
		}
	}
	
	public function setTEXT(?data:Dynamic, ?encode:Bool):Void {
		content(TEXT);
		if (data != null){
			if (Std.is(data, Array)){
				data = data.join('\r');
			}
			writeData(data, encode);
		}
	}
	
	public function setSRU(?data:Dynamic, ?encode:Bool):Void {
		content(TEXT);
		if (data != null){
			if (Std.is(data, Array)){
				data = data.join('\r');
			}
			writeData(data, encode);
		}
	}
	
	function writeData(data:String, encode:Bool) {
		if(data != null){
			if (encode == true) data = IOTools.encodeBase64(data);
			Web.setHeader('Content-Length', Std.string(data.length));
			Lib.print(data);
		}
	}
	
	public function setURI(value:String):Void {
		Web.setHeader('location', value);
	}
	
	public function setOAuth(token:String):Void {
		Web.setHeader('Authorization', token);
	}
	
	public function getOAuth():String {
		return getClientHeader('Authorization');
	}
	
	public function getClientHeader(name:String):String {
		return Reflect.field(getClientHeaders(), name.toUpperCase());
	}
	
	public function getClientHeaders():Dynamic {
		if(_client_headers == null) {
			_client_headers = {};
			var h = Lib.hashOfAssociativeArray(untyped __php__("$_SERVER"));
			for (k in h.keys()) {
				var sk:String = k.toUpperCase();
				if (sk.substr(0, 5) == "HTTP_") {
					Reflect.setField(_client_headers, sk.substr(5), h.get(k));
				// this is also a valid prefix (issue #1883)
				} else if(sk.substr(0,8) == "CONTENT_" || sk.substr(0,4) == "AUTH") {
					Reflect.setField(_client_headers, sk, h.get(k));
				}
			}
		}
		return _client_headers;
	}
	
}