<?php
/**
 */

namespace sys\io;

use \php\Boot;

/**
 * API for reading and writing files.
 * See `sys.FileSystem` for the complementary file system API.
 */
class File {
	/**
	 * Retrieves the content of the file specified by `path` as a String.
	 * If the file does not exist or can not be read, an exception is thrown.
	 * `sys.FileSystem.exists` can be used to check for existence.
	 * If `path` is null, the result is unspecified.
	 * 
	 * @param string $path
	 * 
	 * @return string
	 */
	public static function getContent ($path) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/sys/io/File.hx:30: characters 3-33
		return \file_get_contents($path);
	}

	/**
	 * Stores `content` in the file specified by `path`.
	 * If the file cannot be written to, an exception is thrown.
	 * If `path` or `content` are null, the result is unspecified.
	 * 
	 * @param string $path
	 * @param string $content
	 * 
	 * @return void
	 */
	public static function saveContent ($path, $content) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/sys/io/File.hx:38: characters 3-35
		\file_put_contents($path, $content);
	}
}

Boot::registerClass(File::class, 'sys.io.File');
