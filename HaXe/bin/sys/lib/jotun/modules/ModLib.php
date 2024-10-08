<?php
/**
 * Generated by Haxe 4.3.4
 */

namespace jotun\modules;

use \php\_Boot\HxAnon;
use \php\Boot;
use \haxe\Exception;
use \jotun\utils\Filler;
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
	 * @var object
	 */
	static public $DATA;
	/**
	 * @var bool
	 */
	static public $_init;

	/**
	 * @var \Closure[]|\Array_hx
	 */
	public $_predata;

	/**
	 * @return void
	 */
	public function __construct () {
		#src/jotun/modules/ModLib.hx:77: lines 77-82
		if (ModLib::$_init !== true) {
			#src/jotun/modules/ModLib.hx:78: characters 4-16
			ModLib::$_init = true;
			#src/jotun/modules/ModLib.hx:79: characters 4-17
			$this->_predata = new \Array_hx();
		} else {
			#src/jotun/modules/ModLib.hx:81: characters 4-9
			throw new \Error("Can't create instance of ModLib. Use Jotun.resources instead of new ModLib().");
		}
	}

	/**
	 * @param string $name
	 * @param mixed $data
	 * 
	 * @return mixed
	 */
	public function _sanitize ($name, $data) {
		#src/jotun/modules/ModLib.hx:72: characters 3-89
		Dice::Values($this->_predata, function ($v) use (&$name, &$data) {
			#src/jotun/modules/ModLib.hx:72: characters 64-84
			$data = $v($name, $data);
		});
		#src/jotun/modules/ModLib.hx:73: characters 3-14
		return $data;
	}

	/**
	 * @param string $name
	 * 
	 * @return mixed
	 */
	public function buffer ($name = null) {
		#src/jotun/modules/ModLib.hx:360: lines 360-364
		if (($name !== null) && ($name !== "")) {
			#src/jotun/modules/ModLib.hx:361: characters 11-33
			return \Reflect::field(ModLib::$DATA->objects, $name);
		} else {
			#src/jotun/modules/ModLib.hx:363: characters 4-22
			return ModLib::$DATA->buffer;
		}
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
		#src/jotun/modules/ModLib.hx:101: characters 10-41
		return \Reflect::field(ModLib::$CACHE, \mb_strtolower($module));
	}

	/**
	 * Write module with custom data in the flow to be imported by Jotun Client
	 * @param	name
	 * @param	data
	 * @param	repeat
	 * @param	sufix
	 * 
	 * @param mixed $name
	 * @param mixed $data
	 * 
	 * @return void
	 */
	public function export ($name, $data = null) {
		#src/jotun/modules/ModLib.hx:401: lines 401-420
		$_gthis = $this;
		#src/jotun/modules/ModLib.hx:402: characters 4-38
		echo("<noscript jtn-module>");
		#src/jotun/modules/ModLib.hx:403: lines 403-418
		if (($name instanceof \Array_hx)) {
			#src/jotun/modules/ModLib.hx:404: lines 404-414
			Dice::Values($name, function ($v) use (&$name, &$data, &$_gthis) {
				#src/jotun/modules/ModLib.hx:405: lines 405-413
				if (is_string($v)) {
					#src/jotun/modules/ModLib.hx:406: characters 7-54
					echo(\Std::string("[Module:{\"name\":\"" . \Std::string($name) . "\"}]\x0D"));
					#src/jotun/modules/ModLib.hx:407: characters 7-29
					$_gthis->print($_gthis->get($name, $data));
				} else if (\Reflect::hasField($v, "info")) {
					#src/jotun/modules/ModLib.hx:409: characters 7-28
					echo("[Module:");
					#src/jotun/modules/ModLib.hx:410: characters 7-40
					echo(\Std::string(Json::phpJsonEncode(Boot::dynamicField($v, 'info'), null, null)));
					#src/jotun/modules/ModLib.hx:411: characters 7-23
					echo("]\x0D");
					#src/jotun/modules/ModLib.hx:412: characters 7-28
					$_gthis->print(Boot::dynamicField($v, 'name'), Boot::dynamicField($v, 'data'));
				}
			});
		} else {
			#src/jotun/modules/ModLib.hx:416: characters 5-52
			echo(\Std::string("[Module:{\"name\":\"" . \Std::string($name) . "\"}]\x0D"));
			#src/jotun/modules/ModLib.hx:417: characters 5-20
			$this->get($name, $data);
		}
		#src/jotun/modules/ModLib.hx:419: characters 4-28
		echo("</noscript>");
	}

	/**
	 * Get module content
	 * @param	name
	 * @param	data
	 * @param	alt
	 * @return
	 * 
	 * @param string $name
	 * @param mixed $data
	 * @param string $alt
	 * 
	 * @return string
	 */
	public function get ($name, $data = null, $alt = null) {
		#src/jotun/modules/ModLib.hx:323: characters 3-28
		$name = \mb_strtolower($name);
		#src/jotun/modules/ModLib.hx:324: lines 324-326
		if (!$this->exists($name)) {
			#src/jotun/modules/ModLib.hx:325: characters 11-122
			if ($alt !== null) {
				#src/jotun/modules/ModLib.hx:325: characters 25-28
				return $alt;
			} else {
				#src/jotun/modules/ModLib.hx:325: characters 31-122
				return "<span style='color:#ff0000;font-weight:bold;'>Undefined [Module:" . ($name??'null') . "]</span><br/>";
			}
		}
		#src/jotun/modules/ModLib.hx:327: characters 3-40
		$content = \Reflect::field(ModLib::$CACHE, $name);
		#src/jotun/modules/ModLib.hx:328: characters 3-31
		$data = $this->_sanitize($name, $data);
		#src/jotun/modules/ModLib.hx:329: characters 10-61
		if ($data !== null) {
			#src/jotun/modules/ModLib.hx:329: characters 27-51
			return Filler::to($content, $data);
		} else {
			#src/jotun/modules/ModLib.hx:329: characters 54-61
			return $content;
		}
	}

	/**
	 * @param string $name
	 * 
	 * @return string
	 */
	public function image ($name) {
		#src/jotun/modules/ModLib.hx:356: characters 10-31
		return \Reflect::field(ModLib::$DATA->images, $name);
	}

	/**
	 * Get module content as json object
	 * @param	name
	 * @param	data
	 * @return
	 * 
	 * @param string $name
	 * @param mixed $data
	 * 
	 * @return mixed
	 */
	public function object ($name, $data = null) {
		#src/jotun/modules/ModLib.hx:339: lines 339-351
		if (\Reflect::hasField(ModLib::$DATA->objects, $name)) {
			#src/jotun/modules/ModLib.hx:340: characters 11-33
			$data = \Reflect::field(ModLib::$DATA->objects, $name);
		} else {
			#src/jotun/modules/ModLib.hx:342: characters 4-41
			$val = $this->get($name, $data, "");
			#src/jotun/modules/ModLib.hx:343: lines 343-350
			if ($val !== null) {
				#src/jotun/modules/ModLib.hx:344: lines 344-349
				try {
					#src/jotun/modules/ModLib.hx:345: characters 6-28
					$data = Json::phpJsonDecode($val);
				} catch(\Throwable $_g) {
					#src/jotun/modules/ModLib.hx:347: characters 6-89
					Jotun::log("\x09ModLib => Can't create object for [Module:" . ($name??'null') . "]", 3);
					#src/jotun/modules/ModLib.hx:348: characters 6-17
					$data = null;
				}
			}
		}
		#src/jotun/modules/ModLib.hx:352: characters 3-14
		return $data;
	}

	/**
	 * Pre filter all get data
	 * @param	handler
	 * 
	 * @param \Closure $handler
	 * 
	 * @return void
	 */
	public function onDataRequest ($handler) {
		#src/jotun/modules/ModLib.hx:90: lines 90-92
		if (\Lambda::indexOf($this->_predata, $handler) === -1) {
			#src/jotun/modules/ModLib.hx:91: characters 4-39
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
		#src/jotun/modules/ModLib.hx:376: characters 8-47
		$tmp = null;
		if ($file !== null) {
			#src/jotun/modules/ModLib.hx:376: characters 24-47
			\clearstatcache(true, $file);
			#src/jotun/modules/ModLib.hx:376: characters 8-47
			$tmp = \file_exists($file);
		} else {
			$tmp = false;
		}
		#src/jotun/modules/ModLib.hx:376: lines 376-379
		if ($tmp) {
			#src/jotun/modules/ModLib.hx:377: characters 5-42
			$this->register($file, File::getContent($file));
			#src/jotun/modules/ModLib.hx:378: characters 5-16
			return true;
		}
		#src/jotun/modules/ModLib.hx:380: characters 4-16
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
		#src/jotun/modules/ModLib.hx:391: characters 4-30
		echo(\Std::string($this->get($name, $data)));
	}

	/**
	 * Register a module
	 *
	 * 	[Module:{
	 * 		"name":"unique mod name",
	 * 		"?type":"mod type",
	 * 		"?require":["modname",...],
	 * 		"?inject":["modname",...],
	 * 		"?data":{...},
	 * 		"?target":[{"query":"", "index":N },...]
	 *	}]
	 *
	 * 	Include x Inject
	 *
	 * 	=== Inclusion, [Module:{"name":"IncludeModSample","require":["RequiredModName"]}]
	 * 		Will inject content of defined mods in THIS content
	 * 		THIS mod require the include tag for injection points:
	 * 		{{@include:RequiredModName,data:{...}}} or {{@include:RequiredModName}}
	 *
	 * 		This = "Message: {{@include:RequiredModName}}"
	 * 		Include = "This is the content from RequiredModName"
	 * 		Result = "Message: This is the content from RequiredModName"
	 *
	 * 	=== Injection, [Module:{"name":"InjectModSample","inject":["TargetModToInject"]}]
	 * 		Will include THIS mod in another, and will fill with custom data if defined
	 * 		Receiving mod require the include tag for injection points:
	 * 		{{@inject:InjectModSample,data:{...}}} or {{@inject:InjectModSample}}
	 *
	 * 		This = "Message: {{@inject:TargetModToInject}}"
	 * 		Inject = "This is the content from TargetModToInject"
	 * 		Result = "Message: This is the content from RequiredModName"
	 *
	 * @param	file
	 * @param	content
	 * @param	data
	 * 
	 * @param string $file
	 * @param string $content
	 * 
	 * @return void
	 */
	public function register ($file, $content) {
		#src/jotun/modules/ModLib.hx:146: lines 146-313
		$_gthis = $this;
		#src/jotun/modules/ModLib.hx:147: characters 3-55
		$content = HxString::split($content, "[module:{")->join("[!MOD!]");
		#src/jotun/modules/ModLib.hx:148: characters 3-55
		$content = HxString::split($content, "[Module:{")->join("[!MOD!]");
		#src/jotun/modules/ModLib.hx:149: characters 3-52
		$sur = HxString::split($content, "[!MOD!]");
		#src/jotun/modules/ModLib.hx:150: characters 3-34
		$total = $sur->length - 1;
		#src/jotun/modules/ModLib.hx:151: characters 3-21
		$count = 0;
		#src/jotun/modules/ModLib.hx:152: characters 3-22
		$errors = 0;
		#src/jotun/modules/ModLib.hx:153: characters 3-21
		$fdata = 0;
		#src/jotun/modules/ModLib.hx:154: lines 154-312
		if ($sur->length > 1) {
			#src/jotun/modules/ModLib.hx:155: characters 4-87
			Jotun::log("ModLib => PARSING " . ($file??'null') . " MODULES (~" . ($total??'null') . ")", 1);
			#src/jotun/modules/ModLib.hx:159: lines 159-273
			Dice::All($sur, function ($p, $v) use (&$fdata, &$count, &$errors, &$total, &$file, &$_gthis, &$content) {
				#src/jotun/modules/ModLib.hx:160: lines 160-271
				if ($p > 0) {
					#src/jotun/modules/ModLib.hx:161: characters 6-13
					$count += 1;
					#src/jotun/modules/ModLib.hx:162: characters 6-34
					$i = HxString::indexOf($v, "}]");
					#src/jotun/modules/ModLib.hx:163: lines 163-270
					if ($i !== -1) {
						#src/jotun/modules/ModLib.hx:164: characters 7-61
						$mod = Json::phpJsonDecode("{" . (\mb_substr($v, 0, $i)??'null') . "}");
						#src/jotun/modules/ModLib.hx:165: characters 7-30
						$path = $file;
						#src/jotun/modules/ModLib.hx:166: lines 166-175
						if ($mod->name === null) {
							#src/jotun/modules/ModLib.hx:167: characters 8-23
							$mod->name = $file;
						} else if ($mod->name === "[]") {
							#src/jotun/modules/ModLib.hx:169: characters 8-20
							$path = ($path??'null') . "[]";
						} else {
							#src/jotun/modules/ModLib.hx:171: characters 8-30
							$path = ($path??'null') . "#" . ($mod->name??'null');
							#src/jotun/modules/ModLib.hx:172: lines 172-174
							if ($mod->type !== "data") {
								#src/jotun/modules/ModLib.hx:173: characters 9-93
								Jotun::log("\x09@ BLOCK: " . ($mod->name??'null') . " (" . ($count??'null') . "/" . ($total??'null') . ")", 1);
							}
						}
						#src/jotun/modules/ModLib.hx:176: lines 176-178
						if ($_gthis->exists($mod->name)) {
							#src/jotun/modules/ModLib.hx:177: characters 8-70
							Jotun::log("\x09ModLib => !!! OVERRIDING " . ($path??'null'), 2);
						}
						#src/jotun/modules/ModLib.hx:179: characters 7-40
						$end = HxString::indexOf($v, "/EOF;");
						#src/jotun/modules/ModLib.hx:180: characters 17-81
						$content = \trim(HxString::substring($v, $i + 2, ($end === -1 ? mb_strlen($v) : $end)));
						#src/jotun/modules/ModLib.hx:181: lines 181-189
						if (($mod->type === null) || ($mod->type === "null") || ($mod->type === "html")) {
							#src/jotun/modules/ModLib.hx:182: characters 8-73
							$content = HxString::split(HxString::split($content, "\x0D\x0A")->join("\x0A"), "\x0D")->join("\x0A");
							#src/jotun/modules/ModLib.hx:183: lines 183-185
							while (\mb_substr($content, 0, 1) === "\x0D") {
								#src/jotun/modules/ModLib.hx:184: characters 9-55
								$content = HxString::substring($content, 1, mb_strlen($content));
							}
							#src/jotun/modules/ModLib.hx:186: lines 186-188
							while (\mb_substr($content, -1, null) === "\x0A") {
								#src/jotun/modules/ModLib.hx:187: characters 9-59
								$content = HxString::substring($content, 0, mb_strlen($content) - 1);
							}
						}
						#src/jotun/modules/ModLib.hx:190: lines 190-219
						if ($mod->require !== null) {
							#src/jotun/modules/ModLib.hx:191: characters 8-42
							$incT = $mod->require->length;
							#src/jotun/modules/ModLib.hx:192: characters 8-25
							$incC = 1;
							#src/jotun/modules/ModLib.hx:193: characters 8-94
							Jotun::log("\x09\x09> INCLUDING MODULES IN '" . ($mod->name??'null') . "' (" . ($incT??'null') . ")", 1);
							#src/jotun/modules/ModLib.hx:194: lines 194-218
							Dice::Values($mod->require, function ($v) use (&$incC, &$mod, &$_gthis, &$content) {
								#src/jotun/modules/ModLib.hx:195: lines 195-216
								if ($_gthis->exists($v)) {
									#src/jotun/modules/ModLib.hx:197: lines 197-210
									Dice::All(HxString::split($content, "{{@include:" . ($v??'null') . ",data:{"), function ($p, $v2) use (&$mod, &$_gthis, &$content, &$v) {
										#src/jotun/modules/ModLib.hx:198: lines 198-209
										if ($p > 0) {
											#src/jotun/modules/ModLib.hx:199: characters 12-51
											$pieces = (HxString::split($v2, "}}}")->arr[0] ?? null);
											#src/jotun/modules/ModLib.hx:200: lines 200-208
											try {
												#src/jotun/modules/ModLib.hx:201: characters 13-78
												$data = Json::phpJsonDecode("{" . ($pieces??'null') . "}");
												#src/jotun/modules/ModLib.hx:202: lines 202-204
												if (!($data instanceof \Array_hx)) {
													#src/jotun/modules/ModLib.hx:203: characters 14-41
													$value = $mod->name;
													\Reflect::setField($data, "@name", $value);
												}
												#src/jotun/modules/ModLib.hx:205: characters 13-103
												$content = HxString::split($content, "{{@include:" . ($v??'null') . ",data:{" . ($pieces??'null') . "}}}")->join($_gthis->get($v, $data));
											} catch(\Error $e) {
												#src/jotun/modules/ModLib.hx:207: characters 13-96
												Jotun::log("\x09\x09\x09ERROR: Can't parse module include data for " . ($v??'null') . ".", 3);
											}
										}
									});
									#src/jotun/modules/ModLib.hx:212: characters 10-72
									$content = HxString::split($content, "{{@include:" . ($v??'null') . "}}")->join($_gthis->get($v));
									#src/jotun/modules/ModLib.hx:213: characters 10-72
									Jotun::log("\x09\x09\x09+ INCLUDED '" . ($v??'null') . "' #" . ($incC??'null'), 1);
								} else {
									#src/jotun/modules/ModLib.hx:215: characters 10-70
									Jotun::log("\x09\x09\x09- MISSING '" . ($v??'null') . "' #" . ($incC??'null'), 3);
								}
								#src/jotun/modules/ModLib.hx:217: characters 9-15
								$incC += 1;
							});
						}
						#src/jotun/modules/ModLib.hx:220: lines 220-223
						if ($mod->data !== null) {
							#src/jotun/modules/ModLib.hx:221: characters 19-39
							$tmp = Json::phpJsonDecode($mod->data);
							#src/jotun/modules/ModLib.hx:221: characters 8-39
							$mod->data = $tmp;
							#src/jotun/modules/ModLib.hx:222: characters 8-46
							$content = Filler::to($content, $mod->data);
						}
						#src/jotun/modules/ModLib.hx:224: lines 224-228
						if ($mod->replace !== null) {
							#src/jotun/modules/ModLib.hx:225: lines 225-227
							Dice::Values($mod->replace, function ($v) use (&$content) {
								#src/jotun/modules/ModLib.hx:226: characters 9-49
								$content = HxString::split($content, ($v->arr[0] ?? null))->join(($v->arr[1] ?? null));
							});
						}
						#src/jotun/modules/ModLib.hx:229: lines 229-257
						if ($mod->type !== null) {
							#src/jotun/modules/ModLib.hx:230: lines 230-256
							if ($mod->type === "data") {
								#src/jotun/modules/ModLib.hx:231: lines 231-245
								try {
									#src/jotun/modules/ModLib.hx:232: characters 10-17
									$fdata += 1;
									#src/jotun/modules/ModLib.hx:233: characters 10-39
									$content = Json::phpJsonDecode($content);
									#src/jotun/modules/ModLib.hx:234: lines 234-240
									if ($mod->name === "[]") {
										#src/jotun/modules/ModLib.hx:235: characters 11-83
										Jotun::log("\x09@ PUSH: {...} (" . ($count??'null') . "/" . ($total??'null') . ")", 1);
										#src/jotun/modules/ModLib.hx:236: characters 11-36
										$_this = ModLib::$DATA->buffer;
										$_this->arr[$_this->length++] = $content;
									} else {
										#src/jotun/modules/ModLib.hx:238: characters 11-97
										Jotun::log("\x09@ DATA:  {" . ($mod->name??'null') . "} (" . ($count??'null') . "/" . ($total??'null') . ")", 1);
										#src/jotun/modules/ModLib.hx:239: characters 11-46
										\Reflect::setField(ModLib::$DATA->objects, $mod->name, $content);
									}
									#src/jotun/modules/ModLib.hx:241: characters 10-22
									return false;
								} catch(\Throwable $_g) {
									#src/jotun/modules/ModLib.hx:242: characters 17-18
									$e = Exception::caught($_g)->unwrap();
									#src/jotun/modules/ModLib.hx:243: characters 10-18
									$errors += 1;
									#src/jotun/modules/ModLib.hx:244: characters 10-117
									Jotun::log("\x09\x09ERROR! Can't parse DATA.objects[" . ($mod->name??'null') . "] \x0A\x0A " . ($content??'null') . "\x0A\x0A" . \Std::string($e), 3);
								}
							} else if ($mod->type === "image") {
								#src/jotun/modules/ModLib.hx:255: characters 9-43
								\Reflect::setField(ModLib::$DATA->images, $mod->name, $content);
							}
						}
						#src/jotun/modules/ModLib.hx:265: characters 7-45
						$n = \mb_strtolower($mod->name);
						#src/jotun/modules/ModLib.hx:266: characters 7-28
						\Reflect::setField(ModLib::$CACHE, $n, $content);
						#src/jotun/modules/ModLib.hx:267: characters 7-36
						\Reflect::setField(ModLib::$DATA->paths, "@" . ($n??'null'), $path);
					} else {
						#src/jotun/modules/ModLib.hx:269: characters 7-99
						Jotun::log("\x09ModLib => CONFIG ERROR " . ($file??'null') . "(" . (\mb_substr($v, 0, 15)??'null') . "...)", 3);
					}
				}
				#src/jotun/modules/ModLib.hx:272: characters 5-17
				return false;
			});
			#src/jotun/modules/ModLib.hx:286: characters 4-121
			Jotun::log("\x09! PARSED: " . ($count - $errors) . "/" . ($total??'null') . ", Data: " . ($fdata??'null') . ", Errors: " . ($errors??'null'), 1);
		} else {
			#src/jotun/modules/ModLib.hx:310: characters 5-43
			\Reflect::setField(ModLib::$CACHE, \mb_strtolower($file), $content);
		}
	}

	/**
	 * @param string $module
	 * 
	 * @return void
	 */
	public function remove ($module) {
		#src/jotun/modules/ModLib.hx:105: lines 105-107
		if ($this->exists($module)) {
			#src/jotun/modules/ModLib.hx:106: characters 4-24
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
		self::$DATA = new HxAnon([
			"buffer" => new \Array_hx(),
			"images" => new HxAnon(),
			"objects" => new HxAnon(),
			"paths" => new HxAnon(),
		]);
	}
}

Boot::registerClass(ModLib::class, 'jotun.modules.ModLib');
ModLib::__hx__init();
