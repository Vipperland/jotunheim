package sirius.php;

import haxe.Log;
import php.db.Gate;
import php.Lib;
import sirius.modules.ILoader;
import sirius.modules.Loader;
import sirius.modules.ModLib;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Sirius {
	
	public static var db:Gate = new Gate();
	
	static public var resources:ILoader = new Loader();
	
	//static function main() {
		//var t:Array<Dynamic> = [ { name:"Goddamn ", nick:"Foobar", extra:{message:"- Now with Sweet Potatos!"} }, { name:"Hello", nick:"World", extra:{message:null} } ];
		//ModLib.prepare("modules/filler-test.html");
		//ModLib.print("modules/filler-test.html", t, true);
	//}
	
	static private var _loglevel:UInt = 100;
	
	static private var _initialized:Bool = false;
	
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