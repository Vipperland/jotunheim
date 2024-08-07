<?php
/**
 * Generated by Haxe 4.3.4
 */

namespace jotun\serial;

use \php\_Boot\HxDynamicStr;
use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\logical\Flag;
use \haxe\Json;
use \php\_Boot\HxClosure;
use \haxe\ds\StringMap;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class JsonTool {
	/**
	 * @var \Closure
	 */
	static public $customReplacer;

	/**
	 * @var \StringBuf
	 */
	public $buf;
	/**
	 * @var string
	 */
	public $indent;
	/**
	 * @var int
	 */
	public $nind;
	/**
	 * @var bool
	 */
	public $pretty;
	/**
	 * @var \Closure
	 */
	public $replacer;

	/**
	 * @param mixed $obj
	 * 
	 * @return mixed
	 */
	public static function clone ($obj) {
		#src/jotun/serial/JsonTool.hx:33: characters 10-36
		return Json::phpJsonDecode(JsonTool::stringify($obj));
	}

	/**
	 * @param mixed $o
	 * @param \Closure $replacer
	 * @param string $space
	 * 
	 * @return string
	 */
	public static function stringify ($o, $replacer = null, $space = null) {
		#src/jotun/serial/JsonTool.hx:38: characters 3-83
		$printer = new JsonTool(($replacer !== null ? $replacer : JsonTool::$customReplacer), $space);
		#src/jotun/serial/JsonTool.hx:39: characters 3-23
		$printer->write("", $o);
		#src/jotun/serial/JsonTool.hx:40: characters 3-32
		return $printer->buf->b;
	}

	/**
	 * @param \Closure $replacer
	 * @param string $space
	 * 
	 * @return void
	 */
	public function __construct ($replacer, $space) {
		#src/jotun/serial/JsonTool.hx:50: characters 3-27
		$this->replacer = $replacer;
		#src/jotun/serial/JsonTool.hx:51: characters 3-22
		$this->indent = $space;
		#src/jotun/serial/JsonTool.hx:52: characters 3-30
		$this->pretty = $space !== null;
		#src/jotun/serial/JsonTool.hx:53: characters 3-16
		$this->nind = 0;
		#src/jotun/serial/JsonTool.hx:59: characters 3-24
		$this->buf = new \StringBuf();
	}

	/**
	 * @param mixed $v
	 * 
	 * @return void
	 */
	public function classString ($v) {
		#src/jotun/serial/JsonTool.hx:155: characters 3-60
		$this->fieldsString($v, \Type::getInstanceFields(\Type::getClass($v)));
	}

	/**
	 * @param mixed $v
	 * @param string[]|\Array_hx $fields
	 * 
	 * @return void
	 */
	public function fieldsString ($v, $fields) {
		#src/jotun/serial/JsonTool.hx:163: characters 3-20
		$_this = $this->buf;
		$_this->b = ($_this->b??'null') . (\mb_chr(123)??'null');
		#src/jotun/serial/JsonTool.hx:164: characters 3-27
		$len = $fields->length;
		#src/jotun/serial/JsonTool.hx:165: characters 3-22
		$last = $len - 1;
		#src/jotun/serial/JsonTool.hx:166: characters 3-20
		$first = true;
		#src/jotun/serial/JsonTool.hx:167: characters 13-17
		$_g = 0;
		#src/jotun/serial/JsonTool.hx:167: characters 17-20
		$_g1 = $len;
		#src/jotun/serial/JsonTool.hx:167: lines 167-195
		while ($_g < $_g1) {
			#src/jotun/serial/JsonTool.hx:167: characters 13-20
			$i = $_g++;
			#src/jotun/serial/JsonTool.hx:168: characters 4-22
			$f = ($fields->arr[$i] ?? null);
			#src/jotun/serial/JsonTool.hx:169: characters 4-36
			$value = \Reflect::field($v, $f);
			#src/jotun/serial/JsonTool.hx:170: characters 8-33
			$f1 = $value;
			#src/jotun/serial/JsonTool.hx:170: lines 170-172
			if (($f1 instanceof \Closure) || ($f1 instanceof HxClosure)) {
				#src/jotun/serial/JsonTool.hx:171: characters 5-13
				continue;
			}
			#src/jotun/serial/JsonTool.hx:173: lines 173-175
			if (is_string($f) && (\mb_substr($f, 0, 1) === "_")) {
				#src/jotun/serial/JsonTool.hx:174: characters 5-13
				continue;
			}
			#src/jotun/serial/JsonTool.hx:176: lines 176-181
			if ($first) {
				#src/jotun/serial/JsonTool.hx:177: characters 5-11
				$this->nind++;
				#src/jotun/serial/JsonTool.hx:178: characters 5-18
				$first = false;
			} else {
				#src/jotun/serial/JsonTool.hx:180: characters 5-22
				$_this = $this->buf;
				$_this->b = ($_this->b??'null') . (\mb_chr(44)??'null');
			}
			#src/jotun/serial/JsonTool.hx:182: characters 4-10
			if ($this->pretty) {
				$_this1 = $this->buf;
				$_this1->b = ($_this1->b??'null') . (\mb_chr(10)??'null');
			}
			#src/jotun/serial/JsonTool.hx:183: characters 4-10
			if ($this->pretty) {
				$v1 = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
				$this->buf->add($v1);
			}
			#src/jotun/serial/JsonTool.hx:184: characters 4-12
			$this->quote($f);
			#src/jotun/serial/JsonTool.hx:185: characters 4-21
			$_this2 = $this->buf;
			$_this2->b = ($_this2->b??'null') . (\mb_chr(58)??'null');
			#src/jotun/serial/JsonTool.hx:186: lines 186-188
			if ($this->pretty) {
				#src/jotun/serial/JsonTool.hx:187: characters 5-22
				$_this3 = $this->buf;
				$_this3->b = ($_this3->b??'null') . (\mb_chr(32)??'null');
			}
			#src/jotun/serial/JsonTool.hx:189: characters 4-19
			$this->write($f, $value);
			#src/jotun/serial/JsonTool.hx:190: lines 190-194
			if ($i === $last) {
				#src/jotun/serial/JsonTool.hx:191: characters 5-11
				$this->nind--;
				#src/jotun/serial/JsonTool.hx:192: characters 5-11
				if ($this->pretty) {
					$_this4 = $this->buf;
					$_this4->b = ($_this4->b??'null') . (\mb_chr(10)??'null');
				}
				#src/jotun/serial/JsonTool.hx:193: characters 5-11
				if ($this->pretty) {
					$v2 = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
					$this->buf->add($v2);
				}
			}
		}
		#src/jotun/serial/JsonTool.hx:196: characters 3-20
		$_this = $this->buf;
		$_this->b = ($_this->b??'null') . (\mb_chr(125)??'null');
	}

	/**
	 * @return void
	 */
	public function ipad () {
		#src/jotun/serial/JsonTool.hx:64: lines 64-66
		if ($this->pretty) {
			#src/jotun/serial/JsonTool.hx:65: characters 4-59
			$v = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
			$this->buf->add($v);
		}
	}

	/**
	 * @return void
	 */
	public function newl () {
		#src/jotun/serial/JsonTool.hx:70: lines 70-72
		if ($this->pretty) {
			#src/jotun/serial/JsonTool.hx:71: characters 4-22
			$_this = $this->buf;
			$_this->b = ($_this->b??'null') . (\mb_chr(10)??'null');
		}
	}

	/**
	 * @param mixed $v
	 * 
	 * @return void
	 */
	public function objString ($v) {
		#src/jotun/serial/JsonTool.hx:159: characters 3-37
		$this->fieldsString($v, \Reflect::fields($v));
	}

	/**
	 * @param string $s
	 * 
	 * @return void
	 */
	public function quote ($s) {
		#src/jotun/serial/JsonTool.hx:206: characters 3-20
		$_this = $this->buf;
		$_this->b = ($_this->b??'null') . (\mb_chr(34)??'null');
		#src/jotun/serial/JsonTool.hx:207: characters 3-13
		$i = 0;
		#src/jotun/serial/JsonTool.hx:208: characters 3-25
		$length = mb_strlen($s);
		#src/jotun/serial/JsonTool.hx:212: lines 212-256
		while ($i < $length) {
			#src/jotun/serial/JsonTool.hx:213: characters 4-45
			$c = \StringTools::unsafeCodeAt($s, $i++);
			#src/jotun/serial/JsonTool.hx:214: lines 214-255
			if ($c === 8) {
				#src/jotun/serial/JsonTool.hx:226: characters 6-16
				$this->buf->add("\\b");
			} else if ($c === 9) {
				#src/jotun/serial/JsonTool.hx:224: characters 6-16
				$this->buf->add("\\t");
			} else if ($c === 10) {
				#src/jotun/serial/JsonTool.hx:220: characters 6-16
				$this->buf->add("\\n");
			} else if ($c === 12) {
				#src/jotun/serial/JsonTool.hx:228: characters 6-16
				$this->buf->add("\\f");
			} else if ($c === 13) {
				#src/jotun/serial/JsonTool.hx:222: characters 6-16
				$this->buf->add("\\r");
			} else if ($c === 34) {
				#src/jotun/serial/JsonTool.hx:216: characters 6-16
				$this->buf->add("\\\"");
			} else if ($c === 92) {
				#src/jotun/serial/JsonTool.hx:218: characters 6-17
				$this->buf->add("\\\\");
			} else {
				#src/jotun/serial/JsonTool.hx:253: characters 6-16
				$_this = $this->buf;
				$_this->b = ($_this->b??'null') . (\mb_chr($c)??'null');
			}
		}
		#src/jotun/serial/JsonTool.hx:262: characters 3-20
		$_this = $this->buf;
		$_this->b = ($_this->b??'null') . (\mb_chr(34)??'null');
	}

	/**
	 * @param mixed $k
	 * @param mixed $v
	 * 
	 * @return void
	 */
	public function write ($k, $v) {
		#src/jotun/serial/JsonTool.hx:76: lines 76-78
		if ($this->replacer !== null) {
			#src/jotun/serial/JsonTool.hx:77: characters 4-5
			$v = ($this->replacer)($k, $v);
		}
		#src/jotun/serial/JsonTool.hx:79: characters 11-25
		$_g = \Type::typeof($v);
		$__hx__switch = ($_g->index);
		if ($__hx__switch === 0) {
			#src/jotun/serial/JsonTool.hx:133: characters 5-16
			$this->buf->add("null");
		} else if ($__hx__switch === 1) {
			#src/jotun/serial/JsonTool.hx:85: characters 5-52
			$this->buf->add($v);
		} else if ($__hx__switch === 2) {
			#src/jotun/serial/JsonTool.hx:87: characters 5-51
			$v1 = (\is_finite($v) ? \Std::string($v) : "null");
			$this->buf->add($v1);
		} else if ($__hx__switch === 3) {
			#src/jotun/serial/JsonTool.hx:131: characters 5-68
			$this->buf->add(($v ? "true" : "false"));
		} else if ($__hx__switch === 4) {
			#src/jotun/serial/JsonTool.hx:83: characters 5-17
			$this->fieldsString($v, \Reflect::fields($v));
		} else if ($__hx__switch === 5) {
			#src/jotun/serial/JsonTool.hx:89: characters 5-19
			$this->buf->add("\"<fun>\"");
		} else if ($__hx__switch === 6) {
			#src/jotun/serial/JsonTool.hx:90: characters 16-17
			$c = $_g->params[0];
			#src/jotun/serial/JsonTool.hx:91: lines 91-126
			if ($c === Boot::getClass('String')) {
				#src/jotun/serial/JsonTool.hx:92: characters 6-14
				$this->quote($v);
			} else if ($c === Boot::getClass(\Array_hx::class)) {
				#src/jotun/serial/JsonTool.hx:94: characters 6-31
				$v1 = $v;
				#src/jotun/serial/JsonTool.hx:95: characters 6-23
				$_this = $this->buf;
				$_this->b = ($_this->b??'null') . (\mb_chr(91)??'null');
				#src/jotun/serial/JsonTool.hx:96: characters 6-25
				$len = $v1->length;
				#src/jotun/serial/JsonTool.hx:97: characters 6-25
				$last = $len - 1;
				#src/jotun/serial/JsonTool.hx:98: characters 16-20
				$_g1 = 0;
				#src/jotun/serial/JsonTool.hx:98: characters 20-23
				$_g2 = $len;
				#src/jotun/serial/JsonTool.hx:98: lines 98-112
				while ($_g1 < $_g2) {
					#src/jotun/serial/JsonTool.hx:98: characters 16-23
					$i = $_g1++;
					#src/jotun/serial/JsonTool.hx:99: lines 99-103
					if ($i > 0) {
						#src/jotun/serial/JsonTool.hx:100: characters 8-25
						$_this = $this->buf;
						$_this->b = ($_this->b??'null') . (\mb_chr(44)??'null');
					} else {
						#src/jotun/serial/JsonTool.hx:102: characters 8-14
						$this->nind++;
					}
					#src/jotun/serial/JsonTool.hx:104: characters 7-13
					if ($this->pretty) {
						$_this1 = $this->buf;
						$_this1->b = ($_this1->b??'null') . (\mb_chr(10)??'null');
					}
					#src/jotun/serial/JsonTool.hx:105: characters 7-13
					if ($this->pretty) {
						$v2 = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
						$this->buf->add($v2);
					}
					#src/jotun/serial/JsonTool.hx:106: characters 7-21
					$this->write($i, ($v1->arr[$i] ?? null));
					#src/jotun/serial/JsonTool.hx:107: lines 107-111
					if ($i === $last) {
						#src/jotun/serial/JsonTool.hx:108: characters 8-14
						$this->nind--;
						#src/jotun/serial/JsonTool.hx:109: characters 8-14
						if ($this->pretty) {
							$_this2 = $this->buf;
							$_this2->b = ($_this2->b??'null') . (\mb_chr(10)??'null');
						}
						#src/jotun/serial/JsonTool.hx:110: characters 8-14
						if ($this->pretty) {
							$v3 = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
							$this->buf->add($v3);
						}
					}
				}
				#src/jotun/serial/JsonTool.hx:113: characters 6-23
				$_this = $this->buf;
				$_this->b = ($_this->b??'null') . (\mb_chr(93)??'null');
			} else if ($c === Boot::getClass(StringMap::class)) {
				#src/jotun/serial/JsonTool.hx:115: characters 6-43
				$v1 = $v;
				#src/jotun/serial/JsonTool.hx:116: characters 6-17
				$o = new HxAnon();
				#src/jotun/serial/JsonTool.hx:117: characters 16-24
				$data = \array_values(\array_map("strval", \array_keys($v1->data)));
				$_g_current = 0;
				$_g_length = \count($data);
				$_g_data = $data;
				#src/jotun/serial/JsonTool.hx:117: lines 117-119
				while ($_g_current < $_g_length) {
					$k = $_g_data[$_g_current++];
					#src/jotun/serial/JsonTool.hx:118: characters 7-39
					\Reflect::setField($o, $k, ($v1->data[$k] ?? null));
				}
				#src/jotun/serial/JsonTool.hx:120: characters 6-18
				$v1 = $o;
				$this->fieldsString($v1, \Reflect::fields($v1));
			} else if ($c === Boot::getClass(\Date::class)) {
				#src/jotun/serial/JsonTool.hx:122: characters 6-21
				$v1 = $v;
				#src/jotun/serial/JsonTool.hx:123: characters 6-25
				$this->quote($v1->toString());
			} else {
				#src/jotun/serial/JsonTool.hx:125: characters 6-20
				$this->classString($v);
			}
		} else if ($__hx__switch === 7) {
			#src/jotun/serial/JsonTool.hx:127: characters 15-16
			$_g1 = $_g->params[0];
			#src/jotun/serial/JsonTool.hx:128: characters 5-31
			$i = $v->index;
			#src/jotun/serial/JsonTool.hx:129: characters 5-23
			$v = \Std::string($i);
			$this->buf->add($v);
		} else if ($__hx__switch === 8) {
			#src/jotun/serial/JsonTool.hx:81: characters 5-17
			$this->buf->add("\"???\"");
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


		self::$customReplacer = function ($a, $b) {
			#src/jotun/serial/JsonTool.hx:17: lines 17-23
			if (is_string($a)) {
				#src/jotun/serial/JsonTool.hx:18: lines 18-20
				if (HxDynamicStr::wrap($a)->substr(0, 1) === "_") {
					#src/jotun/serial/JsonTool.hx:19: characters 5-16
					return null;
				}
			} else if (($b instanceof Flag)) {
				#src/jotun/serial/JsonTool.hx:22: characters 4-18
				return Boot::dynamicField($b, 'value');
			}
			#src/jotun/serial/JsonTool.hx:29: characters 10-32
			if ($b === null) {
				#src/jotun/serial/JsonTool.hx:29: characters 24-28
				return null;
			} else {
				#src/jotun/serial/JsonTool.hx:29: characters 31-32
				return $b;
			}
		};
	}
}

Boot::registerClass(JsonTool::class, 'jotun.serial.JsonTool');
JsonTool::__hx__init();
