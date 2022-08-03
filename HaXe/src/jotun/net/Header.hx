package jotun.net;
import jotun.serial.Packager;
import jotun.serial.JsonTool;
import php.Lib;
import php.Web;


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
	
	public function setJSON(?data:Dynamic, ?encode:Bool, ?chunk:Int):Void {
		content(JSON);
		if (data != null) {
			data = JsonTool.stringify(data, null, '\t');
			writeData(data, encode, chunk);
		}
	}
	
	public function setTEXT(?data:Dynamic, ?encode:Bool, ?chunk:Int):Void {
		content(TEXT);
		if (data != null){
			if (Std.isOfType(data, Array)){
				data = data.join('\n');
			}
			writeData(data, encode, chunk);
		}
	}
	
	public function setSRU(?data:Dynamic, ?encode:Bool, ?chunk:Int):Void {
		content(TEXT);
		if (data != null){
			if (Std.isOfType(data, Array)){
				data = data.join('\n');
			}
			writeData(data, encode, chunk);
		}
	}
	
	function _createPieces(data:String, chunk:Int){
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
	
	function writeData(data:String, ?encode:Bool, ?chunk:Int) {
		if(data != null){
			if (encode == true) {
				data = Packager.encodeBase64(data);
				if (chunk != null && chunk >= 40){
					Web.setHeader('Content-Chunk', '' + chunk);
					data = _createPieces(data, chunk);
				}
			}
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
	
}