package sirius.php;

import haxe.Log;
import php.data.Cache;
import php.db.Gate;
import sirius.modules.ILoader;
import sirius.modules.Loader;
import sirius.modules.ModLib;
import sirius.php.utils.Header;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Sirius {
	
	static private var _loglevel:UInt = 100;
	
	static private var _initialized:Bool = false;
	
	static public var resources:ModLib = new ModLib();
	
	#if php
	
		public static var header:Header = new Header();
		
		public static var database:Gate = new Gate();
		
		static public var cache:Cache = new Cache();
		
		//static function main() {
			//var t:Array<Dynamic> = [ { name:"Goddamn ", nick:"Foobar", extra:{message:"- Now with Sweet Potatos!"} }, { name:"Hello", nick:"World", extra:{message:null} } ];
			//ModLib.prepare("modules/filler-test.html");
			//ModLib.print("modules/filler-test.html", t, true);
		//}
	
	#elseif js
	
		static public var resources:ILoader = new Loader();
	
	#end
	
	static public function log(q:Dynamic, level:UInt = 10, type:UInt = -1):Void {
		if (level < _loglevel) {
			var t:String = switch(type) {
				case -1 : "";
				case 0 : "[MESSAGE] ";
				case 1 : "[>SYSTEM] ";
				case 2 : "[WARNING] ";
				case 3 : "[!ERROR!] ";
				default : "";
			}
			Log.trace(t + q);
		}
	}
	
	static public function logLevel(q:UInt):Void {
		_loglevel = q;
	}

}