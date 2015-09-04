<?php

class sirius_php_Sirius {
	public function __construct(){}
	static $_loglevel = 100;
	static $_initialized = false;
	static $resources;
	static $header;
	static $database;
	static $cache;
	static function log($q, $level = null, $type = null) {
		if($type === null) {
			$type = -1;
		}
		if($level === null) {
			$level = 10;
		}
		if(sirius_php_Sirius_0($level, $q, $type)) {
			$t = null;
			switch($type) {
			case -1:{
				$t = "";
			}break;
			case 0:{
				$t = "[MESSAGE] ";
			}break;
			case 1:{
				$t = "[>SYSTEM] ";
			}break;
			case 2:{
				$t = "[WARNING] ";
			}break;
			case 3:{
				$t = "[!ERROR!] ";
			}break;
			default:{
				$t = "";
			}break;
			}
			haxe_Log::trace(_hx_string_or_null($t) . Std::string($q), _hx_anonymous(array("fileName" => "Sirius.hx", "lineNumber" => 47, "className" => "sirius.php.Sirius", "methodName" => "log")));
		}
	}
	static function logLevel($q) {
		sirius_php_Sirius::$_loglevel = $q;
	}
	function __toString() { return 'sirius.php.Sirius'; }
}
sirius_php_Sirius::$resources = new sirius_modules_ModLib();
sirius_php_Sirius::$header = new sirius_php_utils_Header();
sirius_php_Sirius::$database = new sirius_php_db_Gate();
sirius_php_Sirius::$cache = new sirius_php_data_Cache();
function sirius_php_Sirius_0(&$level, &$q, &$type) {
	{
		$b = sirius_php_Sirius::$_loglevel;
		{
			$aNeg = $b < 0;
			$bNeg = $level < 0;
			if($aNeg !== $bNeg) {
				return $aNeg;
			} else {
				return $b > $level;
			}
			unset($bNeg,$aNeg);
		}
		unset($b);
	}
}
