<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace jotun\php\file;

use \php\Boot;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class FileInfo {
	/**
	 * @var mixed
	 */
	public $error;
	/**
	 * @var string
	 */
	public $input;
	/**
	 * @var string
	 */
	public $output;
	/**
	 * @var string[]|\Array_hx
	 */
	public $sizes;
	/**
	 * @var string
	 */
	public $type;

	/**
	 * @param string $type
	 * @param string $input
	 * @param string $output
	 * 
	 * @return void
	 */
	public function __construct ($type, $input, $output) {
		#src/jotun/php/file/FileInfo.hx:20: characters 3-19
		$this->type = $type;
		#src/jotun/php/file/FileInfo.hx:21: characters 3-23
		$this->output = $output;
		#src/jotun/php/file/FileInfo.hx:22: characters 3-21
		$this->input = $input;
	}
}

Boot::registerClass(FileInfo::class, 'jotun.php.file.FileInfo');