<?php

class sirius_db_pdo_Bridge {
	public function __construct(){}
	static function open($dsn, $user = null, $password = null, $options = null) {
		$GLOBALS['%s']->push("sirius.db.pdo.Bridge::open");
		$__hx__spos = $GLOBALS['%s']->length;
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
		{
			$GLOBALS['%s']->pop();
			return $pdo;
		}
		$GLOBALS['%s']->pop();
	}
	function __toString() { return 'sirius.db.pdo.Bridge'; }
}
