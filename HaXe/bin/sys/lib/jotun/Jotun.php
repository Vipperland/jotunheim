<?php
/**
 */

namespace jotun;

use \jotun\modules\ModLib;
use \php\Boot;
use \jotun\net\Loader;
use \jotun\net\Header;
use \jotun\php\db\IGate;
use \jotun\net\ILoader;
use \jotun\net\IDomain;
use \php\_Boot\HxString;
use \jotun\php\db\Gate;
use \jotun\data\Logger;
use \jotun\net\Domain;

/**
 * 191104010157
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Jotun {
	/**
	 * @var bool
	 * @private
	 */
	static public $_loaded = false;
	/**
	 * @var IDomain
	 */
	static public $domain;
	/**
	 * @var IGate
	 */
	static public $gate;
	/**
	 * @var Header
	 */
	static public $header;
	/**
	 * @var ILoader
	 */
	static public $loader;
	/**
	 * @var Logger
	 */
	static public $logger;
	/**
	 * @var ModLib
	 */
	static public $resources;
	/**
	 * @var int
	 */
	static public $tick;

	/**
	 * Level controlled log
	 * @param	q
	 * @param	level
	 * @param	type
	 * 
	 * @param mixed $q
	 * @param int $type
	 * 
	 * @return void
	 */
	public static function log ($q, $type = -1) {
		#src/jotun/Jotun.hx:274: characters 3-23
		if ($type === null) {
			$type = -1;
		}
		Jotun::$logger->push($q, $type);
	}

	/**
	 * @return void
	 */
	public static function main () {
	}

	/**
	 * Load an external or internal module content
	 * @param	file
	 * @param	content
	 * @param	handler
	 * 
	 * @param string $file
	 * @param mixed $content
	 * @param \Closure $handler
	 * 
	 * @return void
	 */
	public static function module ($file, $content = null, $handler = null) {
		#src/jotun/Jotun.hx:245: lines 245-249
		if (HxString::indexOf($file, "http") === -1) {
			#src/jotun/Jotun.hx:246: characters 5-28
			Jotun::$resources->prepare($file);
		} else {
			#src/jotun/Jotun.hx:248: characters 5-42
			Jotun::$loader->module($file, $content, $handler);
		}
	}

	/**
	 * Call a URL with POST/GET/BINARY capabilities
	 * @param	url
	 * @param	data
	 * @param	handler
	 * @param	method
	 * 
	 * @param string $url
	 * @param mixed $data
	 * @param string $method
	 * @param \Closure $handler
	 * @param mixed $headers
	 * 
	 * @return void
	 */
	public static function request ($url, $data = null, $method = "post", $handler = null, $headers = null) {
		#src/jotun/Jotun.hx:261: characters 4-55
		if ($method === null) {
			$method = "post";
		}
		Jotun::$loader->request($url, $data, $method, $handler, $headers);
	}

	/**
	 * @param string $file
	 * 
	 * @return void
	 */
	public static function require ($file) {
		#src/jotun/Jotun.hx:235: characters 4-51
		require_once($file);
	}

	/**
	 * @internal
	 * @access private
	 */
	static public function __hx__init ()
	{
		static $called = false;
		if ($called) return;
		$called = true;


		self::$resources = new ModLib();
		self::$domain = new Domain();
		self::$logger = new Logger();
		self::$header = new Header();
		self::$gate = new Gate();
		self::$loader = new Loader();
		self::$tick = time();
	}
}

Boot::registerClass(Jotun::class, 'jotun.Jotun');
Jotun::__hx__init();
