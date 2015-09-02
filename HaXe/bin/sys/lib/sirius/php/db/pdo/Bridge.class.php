<?php

class sirius_php_db_pdo_Bridge {
	public function __construct(){}
	static function open($dsn, $user = null, $password = null, $options = null) {
		$pdo = null;
		if(null === $options) {
			$pdo = new PDO($dsn, $user, $password);
		} else {
			$arr = array();
			{
				$_g = 0;
				$_g1 = Reflect::fields($options);
				while($_g < $_g1->length) {
					$key = $_g1[$_g];
					++$_g;
					$arr[$key] = Reflect::field($options, $key);
					unset($key);
				}
			}
			$pdo = new PDO($dsn, $user, $password, $arr);
		}
		return $pdo;
	}
	function __toString() { return 'sirius.php.db.pdo.Bridge'; }
}
