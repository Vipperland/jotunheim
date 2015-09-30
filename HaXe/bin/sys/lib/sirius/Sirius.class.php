<?php

class sirius_Sirius {
	public function __construct(){}
	static $_loglevel = 12;
	static $_initialized = false;
	static $resources;
	static $domain;
	static $header;
	static $gate;
	static $loader;
	static function module($file, $content = null, $handler = null) {
		sirius_Sirius::$loader->async($file, $content, $handler);
	}
	static function request($url, $data = null, $handler = null, $method = null) {
		if($method === null) {
			$method = "post";
		}
		sirius_Sirius::$loader->request($url, $data, $handler, $method);
	}
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
			php_Lib::dump($q);
		}
	}
	static function logLevel($q) {
		sirius_Sirius::$_loglevel = $q;
	}
	function __toString() { return 'sirius.Sirius'; }
}
sirius_Sirius::$resources = new sirius_modules_ModLib();
sirius_Sirius::$domain = new sirius_net_Domain();
sirius_Sirius::$header = new sirius_php_utils_Header();
sirius_Sirius::$gate = new sirius_db_Gate();
sirius_Sirius::$loader = new sirius_modules_Loader(null);
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
