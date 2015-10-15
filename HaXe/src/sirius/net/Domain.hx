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
		#elseif php
			data = cast Lib.objectOfAssociativeArray(untyped __php__("$_SERVER"));
			server = Web.getCwd();
			host = Web.getHostName();
			client = Web.getClientIP();
			port = untyped __php__("$_SERVER['SERVER_PORT']");
			params = _getParams();
			var p:String = untyped __php__("$_SERVER['SCRIPT_NAME']");
		#end
		
		url = new Fragments(p, "/");
		
	}
	
	#if js
		
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
		
		private function _getParams():Dynamic {
			#if force_std_separator
				var a : NativeArray = untyped __php__("$array_merge($_GET, $_POST)");
				if(untyped __call__("get_magic_quotes_gpc"))
					untyped __php__("reset($a); while(list($k, $v) = each($a)) $a[$k] = stripslashes((string)$v)");
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
				var a : NativeArray = untyped __php__("array_merge($_GET, $_POST)");
				if(untyped __call__("get_magic_quotes_gpc"))
					untyped __php__("reset($a); while(list($k, $v) = each($a)) $a[$k] = stripslashes((string)$v)");
				return Lib.objectOfAssociativeArray(a);
			#end
		}
		
	#end
	
}