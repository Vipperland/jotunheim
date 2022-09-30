<?php
/**
 */

namespace jotun\modules;

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\utils\Filler;
use \haxe\Log;
use \jotun\Jotun;
use \jotun\utils\Dice;
use \sys\io\File;
use \haxe\Json;
use \php\_Boot\HxString;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class ModLib {
	/**
	 * @var mixed
	 */
	static public $CACHE;
	/**
	 * @var mixed
	 */
	static public $DATA;

	/**
	 * @var \Closure[]|\Array_hx
	 */
	public $_predata;
	/**
	 * @var mixed
	 */
	public $data;

	/**
	 * @return void
	 */
	public function __construct () {
		#src/jotun/modules/ModLib.hx:58: characters 3-14
		$this->data = ModLib::$DATA;
		#src/jotun/modules/ModLib.hx:59: characters 3-16
		$this->_predata = new \Array_hx();
	}

	/**
	 * @param string $name
	 * @param mixed $data
	 * 
	 * @return mixed
	 */
	public function _sanitize ($name, $data) {
		#src/jotun/modules/ModLib.hx:51: characters 3-89
		Dice::Values($this->_predata, function ($v) use (&$name, &$data) {
			#src/jotun/modules/ModLib.hx:51: characters 64-84
			$data = $v($name, $data);
		});
		#src/jotun/modules/ModLib.hx:52: characters 3-14
		return $data;
	}

	/**
	 * Check if a plugins exists
	 * @param	module
	 * @return
	 * 
	 * @param string $module
	 * 
	 * @return bool
	 */
	public function exists ($module) {
		#src/jotun/modules/ModLib.hx:78: characters 3-32
		$module = \mb_strtolower($module);
		#src/jotun/modules/ModLib.hx:79: characters 3-41
		return \Reflect::hasField(ModLib::$CACHE, $module);
	}

	/**
	 * Get module content
	 * @param	name
	 * @param	data
	 * @return
	 * 
	 * @param string $name
	 * @param mixed $data
	 * 
	 * @return string
	 */
	public function get ($name, $data = null) {
		#src/jotun/modules/ModLib.hx:236: characters 3-28
		$name = \mb_strtolower($name);
		#src/jotun/modules/ModLib.hx:237: lines 237-239
		if (!$this->exists($name)) {
			#src/jotun/modules/ModLib.hx:238: characters 4-102
			return "<span style='color:#ff0000;font-weight:bold;'>Undefined [Module:" . ($name??'null') . "]</span><br/>";
		}
		#src/jotun/modules/ModLib.hx:240: characters 3-51
		$content = \Reflect::field(ModLib::$CACHE, $name);
		#src/jotun/modules/ModLib.hx:241: characters 3-31
		$data = $this->_sanitize($name, $data);
		#src/jotun/modules/ModLib.hx:242: characters 10-61
		if ($data !== null) {
			#src/jotun/modules/ModLib.hx:242: characters 27-51
			return Filler::to($content, $data);
		} else {
			#src/jotun/modules/ModLib.hx:242: characters 54-61
			return $content;
		}
	}

	/**
	 * @param string $name
	 * @param mixed $data
	 * 
	 * @return mixed
	 */
	public function getObj ($name, $data = null) {
		#src/jotun/modules/ModLib.hx:246: lines 246-258
		if (\Reflect::hasField(ModLib::$DATA, $name)) {
			#src/jotun/modules/ModLib.hx:247: characters 4-36
			$data = \Reflect::field(ModLib::$DATA, $name);
		} else {
			#src/jotun/modules/ModLib.hx:249: characters 4-37
			$val = $this->get($name, $data);
			#src/jotun/modules/ModLib.hx:250: lines 250-257
			if ($val !== null) {
				#src/jotun/modules/ModLib.hx:251: lines 251-256
				try {
					#src/jotun/modules/ModLib.hx:252: characters 6-28
					$data = Json::phpJsonDecode($val);
				} catch(\Throwable $_g) {
					#src/jotun/modules/ModLib.hx:254: characters 6-11
					(Log::$trace)("Parsing error for MOD:[" . ($name??'null') . "]", new _HxAnon_ModLib0("src/jotun/modules/ModLib.hx", 254, "jotun.modules.ModLib", "getObj"));
					#src/jotun/modules/ModLib.hx:255: characters 6-17
					$data = null;
				}
			}
		}
		#src/jotun/modules/ModLib.hx:259: characters 3-14
		return $data;
	}

	/**
	 * Pre filter input data
	 * @param	handler
	 * 
	 * @param \Closure $handler
	 * 
	 * @return void
	 */
	public function onDataOut ($handler) {
		#src/jotun/modules/ModLib.hx:67: lines 67-69
		if (\Lambda::indexOf($this->_predata, $handler) === -1) {
			#src/jotun/modules/ModLib.hx:68: characters 4-39
			$this->_predata->offsetSet($this->_predata->length, $handler);
		}
	}

	/**
	 * Cache a file to post write
	 * @param	file
	 * @return
	 * 
	 * @param string $file
	 * 
	 * @return bool
	 */
	public function prepare ($file) {
		#src/jotun/modules/ModLib.hx:271: characters 8-47
		$tmp = null;
		if ($file !== null) {
			#src/jotun/modules/ModLib.hx:271: characters 24-47
			\clearstatcache(true, $file);
			#src/jotun/modules/ModLib.hx:271: characters 8-47
			$tmp = \file_exists($file);
		} else {
			$tmp = false;
		}
		#src/jotun/modules/ModLib.hx:271: lines 271-274
		if ($tmp) {
			#src/jotun/modules/ModLib.hx:272: characters 5-42
			$this->register($file, File::getContent($file));
			#src/jotun/modules/ModLib.hx:273: characters 5-16
			return true;
		}
		#src/jotun/modules/ModLib.hx:275: characters 4-16
		return false;
	}

	/**
	 * Write module and fill with custom data in the flow
	 * @param	name
	 * @param	data
	 * @param	repeat
	 * @param	sufix
	 * 
	 * @param string $name
	 * @param mixed $data
	 * 
	 * @return void
	 */
	public function print ($name, $data = null) {
		#src/jotun/modules/ModLib.hx:286: characters 4-30
		echo(\Std::string($this->get($name, $data)));
	}

	/**
	 * Register a module
	 * @param	file
	 * @param	content
	 * 
	 * @param string $file
	 * @param string $content
	 * @param mixed $data
	 * 
	 * @return void
	 */
	public function register ($file, $content, $data = null) {
		#src/jotun/modules/ModLib.hx:93: lines 93-227
		$_gthis = $this;
		#src/jotun/modules/ModLib.hx:94: characters 3-55
		$content = HxString::split($content, "[module:{")->join("[!MOD!]");
		#src/jotun/modules/ModLib.hx:95: characters 3-55
		$content = HxString::split($content, "[Module:{")->join("[!MOD!]");
		#src/jotun/modules/ModLib.hx:96: characters 3-52
		$sur = HxString::split($content, "[!MOD!]");
		#src/jotun/modules/ModLib.hx:97: lines 97-226
		if ($sur->length > 1) {
			#src/jotun/modules/ModLib.hx:98: characters 4-45
			Jotun::log("ModLib => PARSING " . ($file??'null'), 1);
			#src/jotun/modules/ModLib.hx:102: lines 102-191
			Dice::All($sur, function ($p, $v) use (&$file, &$_gthis, &$content) {
				#src/jotun/modules/ModLib.hx:103: lines 103-189
				if ($p > 0) {
					#src/jotun/modules/ModLib.hx:104: characters 6-34
					$i = HxString::indexOf($v, "}]");
					#src/jotun/modules/ModLib.hx:105: lines 105-188
					if ($i !== -1) {
						#src/jotun/modules/ModLib.hx:106: characters 7-61
						$mod = Json::phpJsonDecode("{" . (\mb_substr($v, 0, $i)??'null') . "}");
						#src/jotun/modules/ModLib.hx:107: characters 7-30
						$path = $file;
						#src/jotun/modules/ModLib.hx:108: lines 108-116
						if ($mod->name === null) {
							#src/jotun/modules/ModLib.hx:109: characters 8-23
							$mod->name = $file;
						} else if ($mod->name === "[]") {
							#src/jotun/modules/ModLib.hx:111: characters 8-20
							$path = ($path??'null') . "[]";
							#src/jotun/modules/ModLib.hx:112: characters 8-52
							Jotun::log("\x09\x09ModLib => PUSH " . ($mod->name??'null'), 1);
						} else {
							#src/jotun/modules/ModLib.hx:114: characters 8-30
							$path = ($path??'null') . "#" . ($mod->name??'null');
							#src/jotun/modules/ModLib.hx:115: characters 8-52
							Jotun::log("\x09\x09ModLib => NAME " . ($mod->name??'null'), 1);
						}
						#src/jotun/modules/ModLib.hx:117: lines 117-119
						if ($_gthis->exists($mod->name)) {
							#src/jotun/modules/ModLib.hx:118: characters 8-57
							Jotun::log("\x09ModLib => !!! OVERRIDING " . ($path??'null'), 2);
						}
						#src/jotun/modules/ModLib.hx:120: characters 7-40
						$end = HxString::indexOf($v, "/EOF;");
						#src/jotun/modules/ModLib.hx:121: characters 17-81
						$content = \trim(HxString::substring($v, $i + 2, ($end === -1 ? mb_strlen($v) : $end)));
						#src/jotun/modules/ModLib.hx:122: lines 122-130
						if (($mod->type === null) || ($mod->type === "null") || ($mod->type === "html")) {
							#src/jotun/modules/ModLib.hx:123: characters 8-73
							$content = HxString::split(HxString::split($content, "\x0D\x0A")->join("\x0A"), "\x0D")->join("\x0A");
							#src/jotun/modules/ModLib.hx:124: lines 124-126
							while (\mb_substr($content, 0, 1) === "\x0D") {
								#src/jotun/modules/ModLib.hx:125: characters 9-55
								$content = HxString::substring($content, 1, mb_strlen($content));
							}
							#src/jotun/modules/ModLib.hx:127: lines 127-129
							while (\mb_substr($content, -1, null) === "\x0A") {
								#src/jotun/modules/ModLib.hx:128: characters 9-59
								$content = HxString::substring($content, 0, mb_strlen($content) - 1);
							}
						}
						#src/jotun/modules/ModLib.hx:131: lines 131-140
						if ($mod->require !== null) {
							#src/jotun/modules/ModLib.hx:132: characters 8-68
							Jotun::log("\x09ModLib => " . ($path??'null') . " INCLUDING MODULES...", 1);
							#src/jotun/modules/ModLib.hx:133: lines 133-139
							Dice::Values($mod->require, function ($v) use (&$_gthis, &$content) {
								#src/jotun/modules/ModLib.hx:134: lines 134-138
								if ($_gthis->exists($v)) {
									#src/jotun/modules/ModLib.hx:135: characters 10-72
									$content = HxString::split($content, "{{@include:" . ($v??'null') . "}}")->join($_gthis->get($v));
								} else {
									#src/jotun/modules/ModLib.hx:137: characters 10-57
									Jotun::log("\x09\x09ModLib => MISSING '" . ($v??'null') . "'", 2);
								}
							});
						}
						#src/jotun/modules/ModLib.hx:141: lines 141-148
						if ($mod->inject !== null) {
							#src/jotun/modules/ModLib.hx:142: characters 8-68
							Jotun::log("\x09ModLib => " . ($path??'null') . " INJECTING MODULES...", 1);
							#src/jotun/modules/ModLib.hx:143: lines 143-147
							if ($_gthis->exists($mod->inject)) {
								#src/jotun/modules/ModLib.hx:144: characters 9-72
								$content = HxString::split($_gthis->get($mod->inject), "{{@injection}}")->join($content);
							} else {
								#src/jotun/modules/ModLib.hx:146: characters 9-56
								Jotun::log("\x09\x09ModLib => MISSING '" . ($v??'null') . "'", 2);
							}
						}
						#src/jotun/modules/ModLib.hx:149: lines 149-152
						if ($mod->data !== null) {
							#src/jotun/modules/ModLib.hx:150: characters 8-39
							$mod->data = Json::phpJsonDecode($mod->data);
							#src/jotun/modules/ModLib.hx:151: characters 8-46
							$content = Filler::to($content, $mod->data);
						}
						#src/jotun/modules/ModLib.hx:153: lines 153-155
						if ($mod->wrap !== null) {
							#src/jotun/modules/ModLib.hx:154: characters 8-108
							$content = HxString::split(HxString::split(HxString::split($content, "\x0D\x0A")->join($mod->wrap), "\x0A")->join($mod->wrap), "\x0D")->join($mod->wrap);
						}
						#src/jotun/modules/ModLib.hx:183: characters 7-45
						$n = \mb_strtolower($mod->name);
						#src/jotun/modules/ModLib.hx:184: characters 7-42
						\Reflect::setField(ModLib::$CACHE, $n, $content);
						#src/jotun/modules/ModLib.hx:185: characters 7-45
						\Reflect::setField(ModLib::$CACHE, "@" . ($n??'null'), $path);
					} else {
						#src/jotun/modules/ModLib.hx:187: characters 7-88
						Jotun::log("\x09ModLib => CONFIG ERROR " . ($file??'null') . "(" . (\mb_substr($v, 0, 15)??'null') . "...)", 3);
					}
				}
				#src/jotun/modules/ModLib.hx:190: characters 5-17
				return false;
			});
		} else {
			#src/jotun/modules/ModLib.hx:224: characters 5-57
			\Reflect::setField(ModLib::$CACHE, \mb_strtolower($file), $content);
		}
	}

	/**
	 * @param string $module
	 * 
	 * @return void
	 */
	public function remove ($module) {
		#src/jotun/modules/ModLib.hx:83: lines 83-85
		if ($this->exists($module)) {
			#src/jotun/modules/ModLib.hx:84: characters 4-38
			\Reflect::deleteField(ModLib::$CACHE, $module);
		}
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


		self::$CACHE = new HxAnon();
		self::$DATA = new _HxAnon_ModLib1(new \Array_hx());
	}
}

class _HxAnon_ModLib0 extends HxAnon {
	function __construct($fileName, $lineNumber, $className, $methodName) {
		$this->fileName = $fileName;
		$this->lineNumber = $lineNumber;
		$this->className = $className;
		$this->methodName = $methodName;
	}
}

class _HxAnon_ModLib1 extends HxAnon {
	function __construct($buffer) {
		$this->buffer = $buffer;
	}
}

Boot::registerClass(ModLib::class, 'jotun.modules.ModLib');
ModLib::__hx__init();
