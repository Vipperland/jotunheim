<?php
/**
 * Generated by Haxe 4.3.0
 */

use \jotun\gaming\dataform\Pulsar;
use \php\Boot;
use \jotun\Jotun;
use \jotun\gaming\dataform\Spark;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {
	/**
	 * @return void
	 */
	public static function main () {
		#src/Test_PHP.hx:23: characters 3-38
		Pulsar::map("r", \Array_hx::wrap(["ammount"]), Boot::getClass(Spark::class));
		#src/Test_PHP.hx:24: characters 3-38
		Pulsar::map("g", \Array_hx::wrap(["ammount"]), Boot::getClass(Spark::class));
		#src/Test_PHP.hx:25: characters 3-38
		Pulsar::map("b", \Array_hx::wrap(["ammount"]), Boot::getClass(Spark::class));
		#src/Test_PHP.hx:28: characters 3-31
		$p = new Pulsar();
		#src/Test_PHP.hx:30: characters 3-36
		$c = new Spark("color");
		#src/Test_PHP.hx:31: characters 3-14
		$p->insert($c);
		#src/Test_PHP.hx:33: characters 3-67
		$p->link("color")->get(0)->insert((new Spark("r"))->set("ammount", 10));
		#src/Test_PHP.hx:34: characters 3-67
		$p->link("color")->get(0)->insert((new Spark("g"))->set("ammount", 20));
		#src/Test_PHP.hx:35: characters 3-67
		$p->link("color")->get(0)->insert((new Spark("b"))->set("ammount", 30));
		#src/Test_PHP.hx:39: characters 3-42
		Jotun::$header->setTEXT($p->toString(false));
	}
}

Boot::registerClass(Test_PHP::class, 'Test_PHP');