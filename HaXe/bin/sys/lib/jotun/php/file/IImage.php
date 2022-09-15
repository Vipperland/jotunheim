<?php
/**
 */

namespace jotun\php\file;

use \php\Boot;

/**
 * @author Rafael Moreira <vipperland[at]live.com>
 */
interface IImage {
	/**
	 * @param int $x
	 * @param int $y
	 * @param int $width
	 * @param int $height
	 * 
	 * @return IImage
	 */
	public function crop ($x, $y, $width, $height) ;

	/**
	 * @return void
	 */
	public function delete () ;

	/**
	 * @return void
	 */
	public function dispose () ;

	/**
	 * @param int $width
	 * @param int $height
	 * 
	 * @return IImage
	 */
	public function fit ($width, $height) ;

	/**
	 * @param int $width
	 * @param int $height
	 * 
	 * @return bool
	 */
	public function isOutBounds ($width, $height) ;

	/**
	 * @return bool
	 */
	public function isValid () ;

	/**
	 * @param mixed $file
	 * 
	 * @return IImage
	 */
	public function open ($file) ;

	/**
	 * @param int $width
	 * @param int $height
	 * @param bool $ratio
	 * 
	 * @return IImage
	 */
	public function resample ($width, $height, $ratio = null) ;

	/**
	 * @param string $name
	 * @param int $type
	 * @param int $qty
	 * 
	 * @return bool
	 */
	public function save ($name = null, $type = null, $qty = null) ;
}

Boot::registerClass(IImage::class, 'jotun.php.file.IImage');
