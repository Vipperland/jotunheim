<?php
/**
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
	 * Creates a directory specified by `path`.
	 * This method is recursive: The parent directories don't have to exist.
	 * If the directory cannot be created, an exception is thrown.
	 * 
	 * @param string $path
	 * 
	 * @return void
	 */
	public static function createDirectory ($path) {
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/sys/FileSystem.hx:99: characters 3-36
		\clearstatcache(true, $path);
		#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/sys/FileSystem.hx:100: lines 100-101
		if (!\is_dir($path)) {
			#D:\Toolkits\Haxe\4.2.5\haxe\std/php/_std/sys/FileSystem.hx:101: characters 4-33
			\mkdir($path, 493, true);
		}
	}
}

Boot::registerClass(FileSystem::class, 'sys.FileSystem');
