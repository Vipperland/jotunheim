<?php
/**
 */

namespace jotun\php\db\pdo;

use \php\Boot;

class Database {
	/**
	 * @param string $dsn
	 * @param string $user
	 * @param string $password
	 * @param mixed $options
	 * 
	 * @return Connection
	 */
	public static function connect ($dsn, $user = null, $password = null, $options = null) {
		#src/jotun/php/db/pdo/Database.hx:8: characters 3-29
		$pdo = null;
		#src/jotun/php/db/pdo/Database.hx:9: lines 9-17
		if (null === $options) {
			#src/jotun/php/db/pdo/Database.hx:10: characters 4-72
			$pdo = new \PDO($dsn,$user,$password);
		} else {
			#src/jotun/php/db/pdo/Database.hx:12: characters 4-60
			$arr = array();
			#src/jotun/php/db/pdo/Database.hx:13: lines 13-15
			$_g = 0;
			$_g1 = \Reflect::fields($options);
			while ($_g < $_g1->length) {
				#src/jotun/php/db/pdo/Database.hx:13: characters 9-12
				$key = ($_g1->arr[$_g] ?? null);
				#src/jotun/php/db/pdo/Database.hx:13: lines 13-15
				++$_g;
				#src/jotun/php/db/pdo/Database.hx:14: characters 5-51
				$arr[$key] = \Reflect::field($options, $key);
			}
			#src/jotun/php/db/pdo/Database.hx:16: characters 4-81
			$pdo = new \PDO($dsn,$user,$password,$arr);
		}
		#src/jotun/php/db/pdo/Database.hx:18: characters 3-13
		return $pdo;
	}
}

Boot::registerClass(Database::class, 'jotun.php.db.pdo.Database');
