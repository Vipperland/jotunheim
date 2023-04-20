package;

import haxe.Json;
import jotun.Jotun;
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
		
		Jotun.request(
			'http://127.0.0.100/api/user/register', 
			{
				date: "14/02/2014",
				email: "vipperland@live.com",
				pwd: "12345678",
				username: "Vipperland",
			},
			'post',
			function(r){
				trace(r);
			},
			{'Content-Type':'application/json'}
		);
		
	}
	
} 
