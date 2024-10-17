package jotun.net;

#if js
	import js.Browser;
	import js.Syntax;
	import js.html.Location;
	import jotun.dom.Display;
#elseif php
	import php.Lib;
	import php.NativeArray;
	import php.Syntax;
	import php.Web;
	import jotun.net.IDomainData;
#end

import haxe.Json;
import haxe.io.Bytes;
import jotun.gaming.dataform.Pulsar;
import jotun.net.DataSource;
import jotun.utils.Dice;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Domain implements IDomain {
	
	public var host:String;
	
	public var port:String;
	
	public var url:Array<String>;
	
	#if js
		
		public var hash:Array<String>;
		
	#elseif php
		
		public var server:IDomainData;
		
		public var input:DataSource;
		
		public var pulsar:Pulsar;
		
		public var domain:String;
		
		public var client:String;
		
	#end
	
	public var file:String;
	
	public function new() {
		_parseURI();
	}
	
	private function _parseURI():Void {
		
		#if js
		
			var l:Location = Browser.window.location;
			host = l.hostname;
			port = l.port;
			hash = l.hash.split("/");
			url = l.pathname.substring(1, l.pathname.length).split('/');
			Jotun.params = new DataSource(Utils.getQueryParams(l.href));
		
		#elseif php
		
			server = cast Lib.objectOfAssociativeArray(Syntax.codeDeref("$_SERVER"));
			port = server.SERVER_PORT;
			domain = Web.getCwd();
			host = Web.getHostName();
			client = Web.getClientIP();
			
			var boundary:String = _getMultipartKey();
			
			switch (server.CONTENT_TYPE){
				case 'application/json' : {
					input = new DataSource(_getJsonInput());
				}
				case 'plain/pulsar' : {
					pulsar = Pulsar.create(getInput());
				}
			}
			
			Jotun.params = new DataSource(_getParams());
			
			if (boundary != null) {
				Reflect.deleteField(Jotun.params.data, boundary);
				boundary = boundary.split("\r\n")[0];
				_getRawData(boundary, Jotun.params.data);
			}
			url = server.SCRIPT_NAME.split('/');
			
		#end
		
	}
	
	public function getDomain(?len:Int = 2):String {
		var h:Array<String> = host.split('.');
		return h.splice(h.length - len, len).join('.');
	}
	
	#if js
		
		public function reload(?force:Bool=false):Void {
			Browser.window.location.reload(force);
		}
		
		public function location():String {
			return host + '/' + url.join('/');
		}
		
		public static function matchLocation(uri:String):Bool {
			return Browser.window.location.href.indexOf(uri) != -1;
		}
		
	#elseif php
		
		public function getRequestMethod():String {
			return server.REQUEST_METHOD.toUpperCase();
		}
		
		public function isRequestMethod(q:String):Bool {
			return getRequestMethod() == q.toUpperCase();
		}
		
		private function _getJsonInput():Dynamic {
			var data:String = getInput();
			if(data != null && data.substr(0, 4) == '----'){
				return null;
			}
			return data != null ? Json.parse(data) : null;
		}
		
		/**
		 * Merge POST and GET parameters as one string vector
		 * @return
		 */
		private function _getParams():Dynamic {
			var a : NativeArray = Syntax.codeDeref("array_merge($_GET, $_POST)");
			#if force_std_separator
				var h = Lib.objectOfAssociativeArray(a);
				var params:String = Web.getParamsString();
				if( params == "" )
					return h;
				for( p in ~/[;&]/g.split(params) ) {
					var a = p.split("=");
					var n = a.shift();
					Reflect.setField(h, StringTools.urlDecode(n),StringTools.urlDecode(a.join("=")));
				}
				return h;
			#else
				return Lib.objectOfAssociativeArray(a);
			#end
		}
		
		/**
		 * Parse Multipart/FormData raw data (properties only)
		 * @param	boundary
		 * @param	data
		 * @return
		 */
		private function _getRawData(boundary:String, ?data:Dynamic):Dynamic {
			if (data == null) {
				data = {};
			}
			var content:String = Syntax.codeDeref("file_get_contents('php://input')");
			var result:Array<String> = content.split(boundary);
			Dice.Values(result, function(v:String) {
				if (v == null || v.length == 0) {
					return;
				}
				if(v.indexOf("Content-Disposition: form-data;") < 30){
					var point:Array<String> = v.split("Content-Disposition: form-data; name=")[1].split("\r\n\r\n");
					var param:String = point[0].split("\"").join("");
					if (param.indexOf("Content-Type:") == -1) {
						var value:String = point[1].split("\r\n")[0];
						if (param.length > 0 && value.length > 0 && value != "null") {
							if (param.indexOf("[]") == -1){
								Reflect.setField(data, param, value);
							} else {
								if (!Reflect.hasField(data, param)) {
									Reflect.setField(data, param, []);
								}
								Reflect.field(data, param).push(value);
							}
						}
					}
				}
			});
			
			return data;
			
		}
		
		private function _getMultipartKey():String {
			if(isRequestMethod('POST')){
				var a : NativeArray = Syntax.codeDeref("$_POST");
				var post = Lib.hashOfAssociativeArray(a);
				for (key in post.keys()) {
					if (key.indexOf("Content-Disposition:_form-data;_name") != -1)
						return key;
				}
			}
			return null;
		}
		
		public function parseFiles( onPart : String -> String -> Void, onData : Bytes -> Int -> Int -> Void ) : Void {
			var files:Dynamic = Syntax.codeDeref("$_FILES");
			if (!Syntax.codeDeref("isset({0})", files)){
				return;
			}
			var keys:Dynamic = Syntax.codeDeref("array_keys({0})", files);
			var parts : Array<String> = Lib.toHaxeArray(keys);
			for(part in parts) {
				var info : Dynamic = Syntax.codeDeref("$_FILES[$part]");
				var tmp : String = untyped info['tmp_name'];
				var file : String = untyped info['name'];
				var err : Int = untyped info['error'];
				if(err > 0) {
					switch(err) {
						case 1: throw "The uploaded file exceeds the max size of " + Syntax.codeDeref('ini_get({0})', 'upload_max_filesize');
						case 2: throw "The uploaded file exceeds the max file size directive specified in the HTML form (max is" + Syntax.codeDeref('ini_get({0})', 'post_max_size') + ")";
						case 3: throw "The uploaded file was only partially uploaded";
						case 4: continue; // No file was uploaded
						case 6: throw "Missing a temporary folder";
						case 7: throw "Failed to write file to disk";
						case 8: throw "File upload stopped by extension";
					}
				}
				onPart(part, file);
				if ("" != file)	{
					var h = Syntax.codeDeref("fopen({0},{1})", tmp, "r");
					var bsize = 8192;
					while (!Syntax.codeDeref("feof({0})", h)) {
						var buf : String = Syntax.codeDeref("fread({0},{1})", h, bsize);
						var size : Int = Syntax.codeDeref("strlen({0})", buf);
						onData(Bytes.ofString(buf), 0, size);
					}
					Syntax.codeDeref("fclose({0})", h);
				}
			}
			
		}
		
		public function getInput():String {
			var data:String = Syntax.codeDeref("file_get_contents('php://input')");
			return data != null && data.length > 0 ? data : null;
		}
		
	#end
	
}