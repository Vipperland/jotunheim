<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace sys;

use \php\Boot;

/**
 * This class provides information about files and directories.
 * If `null` is passed as a file path to any function in this class, the
 * result is unspecified, and may differ from target to target.
 * See `sys.io.File` for the complementary file API.
 */
class FileSystem {
	/**
	 * Returns `true` if the file or directory specified by `path` is a directory.
	 * If `path` is not a valid file system entry or if its destination is not
	 * accessible, an exception is thrown.
	 * 
	 * @param string $path
	 * 
	 * @return bool
	 */
	public static function isDirectory ($path) {
		#D:\Toolkits\Haxe\4.3.0\haxe\std/php/_std/sys/FileSystem.hx:94: characters 3-36
		\clearstatcache(true, $path);
		#D:\Toolkits\Haxe\4.3.0\haxe\std/php/_std/sys/FileSystem.hx:95: characters 3-29
		return \is_dir($path);
	}
}

Boot::registerClass(FileSystem::class, 'sys.FileSystem');