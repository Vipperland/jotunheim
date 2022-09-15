<?php
/**
 */

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\php\db\Clause;
use \jotun\Jotun;
use \jotun\utils\Dice;
use \jotun\php\file\Uploader;
use \jotun\php\db\Token;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {
	/**
	 * @return void
	 */
	public static function main () {
		#src/Test_PHP.hx:18: characters 3-32
		$buff = new \Array_hx();
		#src/Test_PHP.hx:20: lines 20-22
		Dice::All(Jotun::$header->getClientHeaders(), function ($p, $v) use (&$buff) {
			#src/Test_PHP.hx:21: characters 4-27
			$buff->arr[$buff->length++] = ($p??'null') . ": " . ($v??'null');
		});
		#src/Test_PHP.hx:23: characters 3-130
		$x = "===================================================== Parameters: (Method:" . (Jotun::$domain->getRequestMethod()??'null') . ")";
		$buff->arr[$buff->length++] = $x;
		#src/Test_PHP.hx:24: lines 24-26
		Dice::All(Jotun::$domain->params, function ($p, $v) use (&$buff) {
			#src/Test_PHP.hx:25: characters 4-27
			$buff->arr[$buff->length++] = ($p??'null') . ": " . ($v??'null');
		});
		#src/Test_PHP.hx:31: characters 3-75
		$buff->arr[$buff->length++] = "===================================================== Files";
		#src/Test_PHP.hx:32: lines 32-53
		$x = Uploader::save("./uploads/", new _HxAnon_Test_PHP0(new _HxAnon_Test_PHP1(240, 160, true), new _HxAnon_Test_PHP1(480, 320, true), new _HxAnon_Test_PHP1(960, 640, true), new _HxAnon_Test_PHP1(1280, 960, true)))->list;
		$buff->arr[$buff->length++] = $x;
		#src/Test_PHP.hx:57: characters 3-54
		Jotun::$gate->open(Token::localhost("decorador"), true);
		#src/Test_PHP.hx:58: characters 19-44
		$q = Jotun::$gate->table("users");
		#src/Test_PHP.hx:59: characters 4-94
		$q1 = Jotun::$gate->builder->leftJoin("user_address", "address", Clause::EQUAL("address.user_id", 1));
		#src/Test_PHP.hx:60: characters 4-102
		$q2 = Jotun::$gate->builder->leftJoin("location_state", "state", Clause::CUSTOM("state.id=address.state_id"));
		#src/Test_PHP.hx:58: lines 58-62
		$q3 = $q->findJoin(\Array_hx::wrap([
			"users.id as UID",
			"users.name as NAME",
			"state.alt as STATE",
			"city.name as CITY",
		]), \Array_hx::wrap([
			$q1,
			$q2,
			Jotun::$gate->builder->leftJoin("location_city", "city", "city.id=address.city_id"),
		]), Clause::CUSTOM("users.id<30"));
		#src/Test_PHP.hx:64: characters 3-28
		$x = Jotun::$gate->get_log();
		$buff->arr[$buff->length++] = $x;
		#src/Test_PHP.hx:65: characters 3-15
		$buff->arr[$buff->length++] = $q3;
		#src/Test_PHP.hx:67: characters 3-29
		Jotun::$header->setJSON($buff);
	}
}

class _HxAnon_Test_PHP1 extends HxAnon {
	function __construct($width, $height, $create) {
		$this->width = $width;
		$this->height = $height;
		$this->create = $create;
	}
}

class _HxAnon_Test_PHP0 extends HxAnon {
	function __construct($thumb, $small, $medium, $large) {
		$this->thumb = $thumb;
		$this->small = $small;
		$this->medium = $medium;
		$this->large = $large;
	}
}

Boot::registerClass(Test_PHP::class, 'Test_PHP');
