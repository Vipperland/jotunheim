package sirius.net;

#if js
	import js.Browser;
	import js.html.Location;
	import sirius.dom.Display;
#elseif php
	import php.Lib;
	import php.NativeArray;
	import php.Web;
#end
import sirius.data.DataCache;
import sirius.data.IDataCache;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Domain implements IDomain {
	
	public var host:String;
	
	public var port:String;
	
	public var fragments:Array<String>;
	
	#if js
		
		public var hash:String;
		
	#elseif php
		
		public var server:String;
		
		public var client:String;
		
	#end
	
	public var firstFragment:String;
	
	public var lastFragment:String;
	
	public var directory:String;
	
	public var file:String;
	
	public var extension:String;
	
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
			hash = l.hash.substr(1);
		#elseif php
			server = Web.getCwd();
			host = Web.getHostName();
			client = Web.getClientIP();
			port = untyped __php__("$_SERVER['SERVER_PORT']");
			params = _getParams();
			var p:String = untyped __php__("$_SERVER['SCRIPT_NAME']");
		#end
		
		fragments = Utils.clearArray(p.split("/"));
		firstFragment = fragment(0, "");
		lastFragment = fragment(fragments.length - 1, firstFragment);
		var fn:Array<String> = lastFragment.split(".");
		file = fn[0];
		extension = lastFragment.indexOf(".") != -1 ? fn.pop() : "";
		directory = fragments.length > 0 ? (extension == '' ? lastFragment : fragments[fragments.length-2]) : '';
		
	}
	
	public function fragment(i:Int, ?a:String):String {
		return i >= 0 && i < fragments.length ? fragments[i] : a;
	}
	
	#if js
		
		public function reload(?force:Bool=false):Void {
			Browser.window.location.reload(force);
		}
		
	#elseif php
		
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