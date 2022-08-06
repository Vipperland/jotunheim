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
		
		Pulsar.map(Spark, 'user', ['name', 'email']);
		Pulsar.map(Spark, 'color', ['name']);
		Pulsar.map(Spark, 'animal', ['name']);
		
		var t:String = [
			"user 0:alpha|1:user@alpha.com",
			"@color 0:yellow",
			"@color 0:blue",
			"@animal 0:dog",
			"@animal 0:cat",
			"user 0:beta|1:user@beta.com",
			"@color 0:gray",
			"@animal 0:cat",
			"user 0:gama|1:user@gama.com",
			"@color 0:cyan",
			"@color 0:black",
			"@color 0:white",
			"@animal 0:dog",
			"@animal 0:cat",
			"@animal 0:horse",
			"@animal 0:pig",
			"user 0:omega|1:user@omega.com",
			"@animal 0:bird",
		].join('\n');
		
		var colA:Pulsar = new Pulsar();
		var colB:Pulsar = new Pulsar();
		
		var cA:Int = colA.parse(t);
		var rA:String = colA.stringify(true);
		trace('colA data(' + cA + ') \r\n\t' + rA.split('\n').join('\r\n\t'));
		
		var cB:Int = colB.parse(rA);
		var rB:String = colB.stringify(true);
		trace('colB data(' + cB + ') \r\n\t' + rB.split('\n').join('\r\n\t'));
		
		//trace('Data Match? \r\n\t' + (t == rA && t == rB));
		
		trace(colA.link());
		
		
	}
	
} 
