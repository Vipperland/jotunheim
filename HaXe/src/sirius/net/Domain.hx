package sirius.net;

#if js
	import js.Browser;
	import js.html.Location;
	import sirius.dom.Display;
#elseif php
	import php.Lib;
	import php.NativeArray;
	import php.Web;
	
	import sirius.net.IDomainData;
#end
import haxe.io.Bytes;
import sirius.data.DataCache;
import sirius.data.Fragments;
import sirius.data.IDataCache;
import sirius.data.IFragments;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Domain implements IDomain {
	
	public var host:String;
	
	public var port:String;
	
	public var url:IFragments;
	
	#if js
		
		public var hash:IFragments;
		
		public var data:IDataCache;
		
	#elseif php
		
		public var data:IDomainData;
		
		public var server:String;
		
		public var client:String;
		
	#end
	
	public var file:String;
	
	public var params:Dynamic;
	
	public function new() {
		_parseURI();
	}
	
	private function _parseURI():Void {
		
		#if js
			var l:Location = Browser.window.location;
			var p:String = l.pathname;
			host = l.hostname;
			port = l.port;
			hash = new Fragments(l.hash.substr(1), "/");
			params = Utils.getQueryParams(l.href);
		#elseif php
			data = cast Lib.objectOfAssociativeArray(untyped __php__("$_SERVER"));
			server = Web.getCwd();
			host = Web.getHostName();
			client = Web.getClientIP();
			port = untyped __php__("$_SERVER['SERVER_PORT']");
			
			var boundary:String = _getMultipartKey();
			
			params = _getParams();
			
			if (boundary != null) {
				Reflect.deleteField(params, boundary);
				boundary = boundary.split("\r\n")[0];
				_getRawData(boundary, params);
			}
			
			var p:String = untyped __php__("$_SERVER['SCRIPT_NAME']");
			
		#end
		
		url = new Fragments(p, "/");
		
	}
	
	#if js
		
		public function allocate(?expire:UInt = 30):IDataCache {
			if(data == null)
				data = new DataCache(host, '/', 86400 * expire);
			return data;
		}
		
		public function reload(?force:Bool=false):Void {
			Browser.window.location.reload(force);
		}
		/* INTERFACE sirius.net.IDomain */
	#elseif php
		
		public function require(params:Array<String>):Bool {
			var r:Bool = true;
			Dice.Values(params, function(v:String) {
				r = Reflect.hasField(this.params, v);
				return !r;
			});
			return r;
		}
		
		/**
		 * Merge POST and GET parameters as one string vector
		 * @return
		 */
		private function _getParams():Dynamic {
			var a : NativeArray = untyped __php__("array_merge($_GET, $_POST)");
			if(untyped __call__("get_magic_quotes_gpc"))
				untyped __php__("reset($a); while(list($k, $v) = each($a)) $a[$k] = stripslashes((string)$v)");
			#if force_std_separator
				var h = Lib.objectOfAssociativeArray(a);
				var params = Web.getParamsString();
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
			if (data == null) 
				data = {};
			var input:String = untyped __php__ ("file_get_contents('php://input')");
			var result:Array<String> = input.split(boundary);
			Dice.Values(result, function(v:String) {
				if (v == null || v.length == 0) 
					return;
				if(v.indexOf("Content-Disposition: form-data;") < 30){
					var point:Array<String> = v.split("Content-Disposition: form-data; name=")[1].split("\r\n\r\n");
					var param:String = point[0].split("\"").join("");
					if (param.indexOf("Content-Type:") == -1) {
						var value:String = point[1].split("\r\n")[0];
						if (param.length > 0 && value.length > 0 && value != "null") {
							if(param.indexOf("[]") == -1)
								Reflect.setField(data, param, value);
							else {
								if (!Reflect.hasField(data, param)) 
									Reflect.setField(data, param, []);
								Reflect.field(data, param).push(value);
							}
						}
					}
				}
			});
			
			return data;
			
		}
		
		private function _getMultipartKey() : String {
			var a : NativeArray = untyped __php__("$_POST");
			if(untyped __call__("get_magic_quotes_gpc"))
				untyped __php__("reset($a); while(list($k, $v) = each($a)) $a[$k] = stripslashes((string)$v)");
			var post = Lib.hashOfAssociativeArray(a);
			for (key in post.keys()) {
				if (key.indexOf("Content-Disposition:_form-data;_name") != -1)
					return key;
			}
			return null;
		}
		
		public function parseFiles( onPart : String -> String -> Void, onData : Bytes -> Int -> Int -> Void ) : Void {
			
			if(!untyped __call__("isset", __php__("$_FILES"))) return;
			var parts : Array<String> = untyped __call__("new _hx_array",__call__("array_keys", __php__("$_FILES")));
			for(part in parts) {
				var info : Dynamic = untyped __php__("$_FILES[$part]");
				var tmp : String = untyped info['tmp_name'];
				var file : String = untyped info['name'];
				var err : Int = untyped info['error'];
				if(err > 0) {
					switch(err) {
						case 1: throw "The uploaded file exceeds the max size of " + untyped __call__('ini_get', 'upload_max_filesize');
						case 2: throw "The uploaded file exceeds the max file size directive specified in the HTML form (max is" + untyped __call__('ini_get', 'post_max_size') + ")";
						case 3: throw "The uploaded file was only partially uploaded";
						case 4: continue; // No file was uploaded
						case 6: throw "Missing a temporary folder";
						case 7: throw "Failed to write file to disk";
						case 8: throw "File upload stopped by extension";
					}
				}
				onPart(part, file);
				if ("" != file)	{
					var h = untyped __call__("fopen", tmp, "r");
					var bsize = 8192;
					while (!untyped __call__("feof", h)) {
						var buf : String = untyped __call__("fread", h, bsize);
						var size : Int = untyped __call__("strlen", buf);
						onData(Bytes.ofString(buf), 0, size);
					}
					untyped __call__("fclose", h);
				}
			}
			
		}
		
	#end
	
}