<?php

class sirius_Sirius {
	public function __construct(){}
	static $_loglevel = 12;
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
		if(sirius_Sirius_0($level, $q, $type)) {
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
			case 4:{
				$t = "[//TODO:] ";
			}break;
			default:{
				$t = "";
			}break;
			}
			haxe_Log::trace(_hx_string_or_null($t) . Std::string($q), _hx_anonymous(array("fileName" => "Sirius.hx", "lineNumber" => 240, "className" => "sirius.Sirius", "methodName" => "log")));
		}
	}
	static function logLevel($q) {
		sirius_Sirius::$_loglevel = $q;
	}
	function __toString() { return 'sirius.Sirius'; }
}
sirius_Sirius::$resources = new sirius_modules_ModLib();
sirius_Sirius::$header = new sirius_php_utils_Header();
sirius_Sirius::$database = new sirius_php_db_Gate();
sirius_Sirius::$cache = new sirius_php_data_Cache();
function sirius_Sirius_0(&$level, &$q, &$type) {
	{
		$b = sirius_Sirius::$_loglevel;
		{
			$aNeg = $b < 0;
			$bNeg = $level < 0;
			if($aNeg !== $bNeg) {
				return $aNeg;
			} else {
				return $b >= $level;
			}
			unset($bNeg,$aNeg);
		}
		unset($b);
	}
}
