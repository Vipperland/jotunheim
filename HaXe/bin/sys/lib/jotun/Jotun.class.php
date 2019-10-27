<?php

// Generated by Haxe 3.4.7
class jotun_Jotun {
	public function __construct(){}
	static $_loaded = false;
	static $resources;
	static $domain;
	static $logger;
	static function main() {}
	static $header;
	static $gate;
	static $loader;
	static $tick;
	static function hrequire($file) {
		require_once($file);
	}
	static function module($file, $content = null, $handler = null) {
		if(_hx_index_of($file, "http", null) === -1) {
			jotun_Jotun::$resources->prepare($file);
		} else {
			jotun_Jotun::$loader->async($file, $content, $handler);
		}
	}
	static function request($url, $data = null, $method = null, $handler = null, $headers = null) {
		if($method === null) {
			$method = "post";
		}
		jotun_Jotun::$loader->request($url, $data, $method, $handler, $headers);
	}
	static function log($q, $type = null) {
		if($type === null) {
			$type = -1;
		}
		jotun_Jotun::$logger->push($q, $type);
	}
	function __toString() { return 'jotun.Jotun'; }
}
jotun_Jotun::$resources = new jotun_modules_ModLib();
jotun_Jotun::$domain = new jotun_net_Domain();
jotun_Jotun::$logger = new jotun_data_Logger();
jotun_Jotun::$header = new jotun_net_Header();
jotun_Jotun::$gate = new jotun_db_Gate();
jotun_Jotun::$loader = new jotun_net_Loader(null);
jotun_Jotun::$tick = time();