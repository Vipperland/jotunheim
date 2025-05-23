package jotun.net;
import haxe.Rest;
import jotun.gaming.dataform.Pulsar;
import jotun.serial.Packager;
import jotun.serial.JsonTool;
import jotun.utils.Dice;
import jotun.utils.Omnitools;
import php.Global;
import php.Lib;
import php.Web;


/**
 * ...
 * @author Rafael Moreira
 */
class Header {
	
	static public var HTML:String = 'text/html; charset=utf-8';
	
	static public var TEXT:String = 'text/plain; charset=utf-8';
	
	static public var JSON:String = 'application/json; charset=utf-8';
	
	static public var PULSAR:String = 'text/pulsar; charset=utf-8';
	
	static public var JSONP:String = 'application/javascript; charset=utf-8';
	
	static public var hasType:Bool = false;
	
	static private var _client_headers:Dynamic;
	
	static private var _no_compression:Bool;
	
	public function new() {
		
	}
	
	public function isRequestMethod(method:String):Bool {
		return Jotun.domain.server.REQUEST_METHOD.toUpperCase() == method.toUpperCase();
	}
	
	public function isOrigin(origin:Dynamic):Bool {
		var c:String = Jotun.domain.server.HTTP_ORIGIN.toLowerCase();
		if(Std.isOfType(origin, Array)){
			return !Dice.Values(origin, function(v:String){
				return c.indexOf(v) != -1;
			}).completed;
		}else{
			return c.indexOf(origin) != -1;
		}
	}
	
	public function allowOrigin(domain:String):Void {
		Web.setHeader('Access-Control-Allow-Origin', domain);
	}
	
	public function allowMethods(methods:Rest<String>):Void {
		Web.setHeader('Access-Control-Allow-Methods', methods.toArray().join(', '));
	}
	
	public function allowHeaders(headers:Rest<String>):Void {
		Web.setHeader('Access-Control-Allow-Headers', headers.toArray().join(', '));
	}
	
	public function allowCredentials(credentials:Bool):Void {
		Web.setHeader('Access-Control-Allow-Credentials', Std.string(credentials));
	}
	
	public function setContentEncoding(value:String):Void {
		_no_compression = value == null || value == 'none' || value == 'no' || value == 'disable';
		Web.setHeader('Content-Encoding', _no_compression ? 'none' : value);
	}
	
	public function setFreeAccess():Void {
		allowOrigin('*');
		allowMethods('POST', 'GET', 'DELETE', 'PUT', 'PATCH', 'OPTIONS');
		allowHeaders('Origin', 'Content-Type', 'Accept', 'Authorization', 'X-Request-With');
		allowCredentials(true);
	}
	
	public function content(type:String):Void {
		if(!hasType){
			hasType = true;
			Web.setHeader('Content-Type', type);
		}
	}
	
	public function setHTML(?data:Dynamic):Void {
		content(HTML);
		if (data != null) {
			Web.setHeader('Content-Length', Std.string(data.length));
			Lib.print(data);
		}
	}
	
	public function setJSON(?data:Dynamic, ?encode:Bool, ?chunk:Int, ?pretty:Bool):Void {
		content(JSON);
		if (data != null) {
			data = JsonTool.stringify(data, null, pretty ? '\t' : null);
			_writeData(data, encode, chunk);
		}
	}
	
	public function setTEXT(?data:Dynamic, ?encode:Bool, ?chunk:Int):Void {
		content(TEXT);
		if (data != null){
			if (Std.isOfType(data, Array)){
				data = data.join('\n');
			}
			_writeData(data, encode, chunk);
		}
	}
	
	public function setPulsar(?data:Pulsar, ?encode:Bool, ?chunk:Int):Void {
		content(PULSAR);
		if (data != null){
			_writeData(data.toString(encode), encode, chunk);
		}
	}
	
	private function _createPieces(data:String, chunk:Int){
		var f:Int = 0;
		var t:Int = data.length;
		var copy:String = "";
		while (f < t){
			copy += data.substr(f, chunk);
			f += chunk;
			if (f < t){
				copy += '\n';
			}
		}
		return copy;
	}
	
	private function _writeData(data:String, ?encode:Bool, ?chunk:Int) {
		if(data != null){
			if (encode == true) {
				data = Packager.encodeBase64(data);
				if (chunk != null && chunk >= 40){
					Web.setHeader('Content-Chunk', '' + chunk);
					data = _createPieces(data, chunk);
				}
			}
			if(!_no_compression){
				var compress:String = getClientHeaders().ACCEPT_ENCODING;
				if (compress.indexOf('x-gzip') != -1){
					compress = 'x-gzip';
				}else if (compress.indexOf('gzip') != -1){
					compress = 'gzip';
				}else {
					compress = null;
				}
				if (compress != null){
					data = php.Syntax.codeDeref('gzcompress({0},{1})', data, 1);
					Web.setHeader('Content-Encoding', compress);
				}
				if (compress != null){
					data = '\x1f' + php.Syntax.codeDeref('chr({0})', 139) + '\x08\x00\x00\x00\x00\x00' + data;
				}
			}
			Lib.print(data);
		}
	}
	
	public function setURI(value:String):Void {
		Web.setHeader('location', value);
	}
	
	public function setOAuth(token:String):Void {
		Web.setHeader('Authorization', token);
	}
	
	public function getOAuth(?cookie:String):String {
		if(cookie != null){
			return readCookie(cookie);
		}else{
			return getClientHeader('Authorization');
		}
	}
	
	public function setOAuthCookie(name:String, value:String, ?expire:UInt = 0, ?domain:String = null, ?secure:Bool = false, ?http:Bool = false):Void {
		writeCookie(name, value, expire, domain, secure, http);
	}
	
	public function getClientHeader(name:String):String {
		return Reflect.field(getClientHeaders(), name.toUpperCase());
	}
	
	public function getClientHeaders():Dynamic {
		if(_client_headers == null) {
			_client_headers = {};
			var h = Lib.hashOfAssociativeArray(php.Syntax.codeDeref("$_SERVER"));
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
	
	public function readCookie(name:String):String {
		return Global.session_get_cookie_params()[name];
	}
	
	public function writeCookie(name:String, value:String, ?expire:UInt = 0, ?domain:String = null, ?secure:Bool = false, ?http:Bool = false):Void {
		Global.setcookie(name, value, Std.int(Omnitools.timeFromNow((expire+1) * 24)), "/", domain, secure, http);
	}
	
}