package;

import haxe.Json;
import jotun.gaming.dataform.Pulsar;
import jotun.gaming.dataform.Spark;
import jotun.idb.WebDB;
import jotun.serial.Packager;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Test_JS{
	
	static private var _db:WebDB;
	
	static public function main() {
		
		var str:String = [
			'obj1 {',
			'	obj2 {',
			'		a: Hello',
			'		b: World',
			'	}',
			'	a: Hello',
			'	b: World',
			'}',
			'a: Hello',
			'b: World',
			'arr1 [',
			'	{',
			'		a: Hellow',
			'		b: World',
			'	}',
			'	hi mom!',
			'	true',
			'	5',
			'	[',
			'		{',
			'			a: Hello',
			'			b: World',
			'		}',
			'	]',
			']',
		].join('\r');
		
	}
	
} 
