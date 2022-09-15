<?php
/**
 */

namespace jotun\serial;

use \php\_Boot\HxDynamicStr;
use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\tools\Flag;
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
	 * @param mixed $o
	 * @param \Closure $replacer
	 * @param string $space
	 * 
	 * @return string
	 */
	public static function stringify ($o, $replacer = null, $space = null) {
		#src/jotun/serial/JsonTool.hx:30: characters 3-83
		$printer = new JsonTool(($replacer !== null ? $replacer : JsonTool::$customReplacer), $space);
		#src/jotun/serial/JsonTool.hx:31: characters 3-23
		$printer->write("", $o);
		#src/jotun/serial/JsonTool.hx:32: characters 3-32
		return $printer->buf->b;
	}

	/**
	 * @param \Closure $replacer
	 * @param string $space
	 * 
	 * @return void
	 */
	public function __construct ($replacer, $space) {
		#src/jotun/serial/JsonTool.hx:42: characters 3-27
		$this->replacer = $replacer;
		#src/jotun/serial/JsonTool.hx:43: characters 3-22
		$this->indent = $space;
		#src/jotun/serial/JsonTool.hx:44: characters 3-30
		$this->pretty = $space !== null;
		#src/jotun/serial/JsonTool.hx:45: characters 3-16
		$this->nind = 0;
		#src/jotun/serial/JsonTool.hx:52: characters 3-24
		$this->buf = new \StringBuf();
	}

	/**
	 * @param mixed $v
	 * @param string[]|\Array_hx $fields
	 * 
	 * @return void
	 */
	public function fieldsString ($v, $fields) {
		#src/jotun/serial/JsonTool.hx:167: characters 3-20
		$_this = $this->buf;
		$_this->b = ($_this->b??'null') . (\mb_chr(123)??'null');
		#src/jotun/serial/JsonTool.hx:168: characters 3-27
		$len = $fields->length;
		#src/jotun/serial/JsonTool.hx:169: characters 3-22
		$last = $len - 1;
		#src/jotun/serial/JsonTool.hx:170: characters 3-20
		$first = true;
		#src/jotun/serial/JsonTool.hx:171: characters 13-17
		$_g = 0;
		#src/jotun/serial/JsonTool.hx:171: characters 17-20
		$_g1 = $len;
		#src/jotun/serial/JsonTool.hx:171: lines 171-193
		while ($_g < $_g1) {
			#src/jotun/serial/JsonTool.hx:171: characters 13-20
			$i = $_g++;
			#src/jotun/serial/JsonTool.hx:172: characters 4-22
			$f = ($fields->arr[$i] ?? null);
			#src/jotun/serial/JsonTool.hx:173: characters 4-35
			$value = \Reflect::field($v, $f);
			#src/jotun/serial/JsonTool.hx:174: characters 4-33
			if ($value === null) {
				#src/jotun/serial/JsonTool.hx:174: characters 25-33
				continue;
			}
			#src/jotun/serial/JsonTool.hx:175: characters 9-34
			$f1 = $value;
			#src/jotun/serial/JsonTool.hx:175: characters 4-45
			if (($f1 instanceof \Closure) || ($f1 instanceof HxClosure)) {
				#src/jotun/serial/JsonTool.hx:175: characters 37-45
				continue;
			}
			#src/jotun/serial/JsonTool.hx:179: characters 4-67
			if (is_string($f) && (\mb_substr($f, 0, 1) === "_")) {
				#src/jotun/serial/JsonTool.hx:179: characters 59-67
				continue;
			}
			#src/jotun/serial/JsonTool.hx:180: characters 4-65
			if ($first) {
				#src/jotun/serial/JsonTool.hx:180: characters 18-24
				$this->nind++;
				#src/jotun/serial/JsonTool.hx:180: characters 26-39
				$first = false;
			} else {
				#src/jotun/serial/JsonTool.hx:180: characters 48-65
				$_this = $this->buf;
				$_this->b = ($_this->b??'null') . (\mb_chr(44)??'null');
			}
			#src/jotun/serial/JsonTool.hx:181: characters 4-10
			if ($this->pretty) {
				$_this1 = $this->buf;
				$_this1->b = ($_this1->b??'null') . (\mb_chr(10)??'null');
			}
			#src/jotun/serial/JsonTool.hx:182: characters 4-10
			if ($this->pretty) {
				$v1 = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
				$this->buf->add($v1);
			}
			#src/jotun/serial/JsonTool.hx:183: characters 4-12
			$this->quote($f);
			#src/jotun/serial/JsonTool.hx:184: characters 4-21
			$_this2 = $this->buf;
			$_this2->b = ($_this2->b??'null') . (\mb_chr(58)??'null');
			#src/jotun/serial/JsonTool.hx:185: characters 4-33
			if ($this->pretty) {
				#src/jotun/serial/JsonTool.hx:185: characters 16-33
				$_this3 = $this->buf;
				$_this3->b = ($_this3->b??'null') . (\mb_chr(32)??'null');
			}
			#src/jotun/serial/JsonTool.hx:186: characters 4-19
			$this->write($f, $value);
			#src/jotun/serial/JsonTool.hx:187: lines 187-192
			if ($i === $last) {
				#src/jotun/serial/JsonTool.hx:189: characters 5-11
				$this->nind--;
				#src/jotun/serial/JsonTool.hx:190: characters 5-11
				if ($this->pretty) {
					$_this4 = $this->buf;
					$_this4->b = ($_this4->b??'null') . (\mb_chr(10)??'null');
				}
				#src/jotun/serial/JsonTool.hx:191: characters 5-11
				if ($this->pretty) {
					$v2 = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
					$this->buf->add($v2);
				}
			}
		}
		#src/jotun/serial/JsonTool.hx:194: characters 3-20
		$_this = $this->buf;
		$_this->b = ($_this->b??'null') . (\mb_chr(125)??'null');
	}

	/**
	 * @return void
	 */
	public function ipad () {
		#src/jotun/serial/JsonTool.hx:57: characters 3-70
		if ($this->pretty) {
			#src/jotun/serial/JsonTool.hx:57: characters 15-70
			$v = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
			$this->buf->add($v);
		}
	}

	/**
	 * @return void
	 */
	public function newl () {
		#src/jotun/serial/JsonTool.hx:61: characters 3-33
		if ($this->pretty) {
			#src/jotun/serial/JsonTool.hx:61: characters 15-33
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
		#src/jotun/serial/JsonTool.hx:163: characters 3-36
		$this->fieldsString($v, \Reflect::fields($v));
	}

	/**
	 * @param string $s
	 * 
	 * @return void
	 */
	public function quote ($s) {
		#src/jotun/serial/JsonTool.hx:199: characters 26-46
		$this1 = $s;
		#src/jotun/serial/JsonTool.hx:199: characters 3-47
		$us = $this1;
		#src/jotun/serial/JsonTool.hx:200: lines 200-203
		if (mb_strlen($s) !== mb_strlen($us)) {
			#src/jotun/serial/JsonTool.hx:201: characters 4-16
			$this->quoteUtf8($s);
			#src/jotun/serial/JsonTool.hx:202: characters 4-10
			return;
		}
		#src/jotun/serial/JsonTool.hx:205: characters 3-20
		$_this = $this->buf;
		$_this->b = ($_this->b??'null') . (\mb_chr(34)??'null');
		#src/jotun/serial/JsonTool.hx:206: characters 3-13
		$i = 0;
		#src/jotun/serial/JsonTool.hx:207: lines 207-225
		while (true) {
			#src/jotun/serial/JsonTool.hx:208: characters 4-43
			$c = \StringTools::fastCodeAt($s, $i++);
			#src/jotun/serial/JsonTool.hx:209: characters 4-36
			if ($c === 0) {
				#src/jotun/serial/JsonTool.hx:209: characters 31-36
				break;
			}
			#src/jotun/serial/JsonTool.hx:210: lines 210-224
			if ($c === 8) {
				#src/jotun/serial/JsonTool.hx:216: characters 12-22
				$this->buf->add("\\b");
			} else if ($c === 9) {
				#src/jotun/serial/JsonTool.hx:215: characters 20-30
				$this->buf->add("\\t");
			} else if ($c === 10) {
				#src/jotun/serial/JsonTool.hx:213: characters 20-30
				$this->buf->add("\\n");
			} else if ($c === 12) {
				#src/jotun/serial/JsonTool.hx:217: characters 13-23
				$this->buf->add("\\f");
			} else if ($c === 13) {
				#src/jotun/serial/JsonTool.hx:214: characters 20-30
				$this->buf->add("\\r");
			} else if ($c === 34) {
				#src/jotun/serial/JsonTool.hx:211: characters 19-29
				$this->buf->add("\\\"");
			} else if ($c === 92) {
				#src/jotun/serial/JsonTool.hx:212: characters 20-31
				$this->buf->add("\\\\");
			} else {
				#src/jotun/serial/JsonTool.hx:222: characters 5-15
				$_this = $this->buf;
				$_this->b = ($_this->b??'null') . (\mb_chr($c)??'null');
			}
		}
		#src/jotun/serial/JsonTool.hx:226: characters 3-20
		$_this = $this->buf;
		$_this->b = ($_this->b??'null') . (\mb_chr(34)??'null');
	}

	/**
	 * @param string $s
	 * 
	 * @return void
	 */
	public function quoteUtf8 ($s) {
		#src/jotun/serial/JsonTool.hx:231: characters 25-45
		$this1 = $s;
		#src/jotun/serial/JsonTool.hx:231: characters 3-46
		$u = $this1;
		#src/jotun/serial/JsonTool.hx:232: characters 3-15
		$this->buf->add("\"");
		#src/jotun/serial/JsonTool.hx:233: characters 3-24
		$this->buf->add($u);
		#src/jotun/serial/JsonTool.hx:234: characters 3-15
		$this->buf->add("\"");
	}

	/**
	 * @param mixed $k
	 * @param mixed $v
	 * 
	 * @return void
	 */
	public function write ($k, $v) {
		#src/jotun/serial/JsonTool.hx:65: characters 3-43
		if ($this->replacer !== null) {
			#src/jotun/serial/JsonTool.hx:65: characters 25-26
			$v = ($this->replacer)($k, $v);
		}
		#src/jotun/serial/JsonTool.hx:66: characters 11-25
		$_g = \Type::typeof($v);
		$__hx__switch = ($_g->index);
		if ($__hx__switch === 0) {
			#src/jotun/serial/JsonTool.hx:134: characters 5-16
			$this->buf->add("null");
		} else if ($__hx__switch === 1) {
			#src/jotun/serial/JsonTool.hx:74: characters 5-11
			$this->buf->add($v);
		} else if ($__hx__switch === 2) {
			#src/jotun/serial/JsonTool.hx:77: characters 5-39
			$v1 = (\is_finite($v) ? $v : "null");
			$this->buf->add($v1);
		} else if ($__hx__switch === 3) {
			#src/jotun/serial/JsonTool.hx:131: characters 5-53
			$this->buf->add(($v ? "true" : "false"));
		} else if ($__hx__switch === 4) {
			#src/jotun/serial/JsonTool.hx:71: characters 5-17
			$this->fieldsString($v, \Reflect::fields($v));
		} else if ($__hx__switch === 5) {
			#src/jotun/serial/JsonTool.hx:80: characters 5-19
			$this->buf->add("\"<fun>\"");
		} else if ($__hx__switch === 6) {
			#src/jotun/serial/JsonTool.hx:82: characters 16-17
			$c = $_g->params[0];
			#src/jotun/serial/JsonTool.hx:88: lines 88-124
			if ($c === Boot::getClass('String')) {
				#src/jotun/serial/JsonTool.hx:89: characters 6-14
				$this->quote($v);
			} else if ($c === Boot::getClass(\Array_hx::class)) {
				#src/jotun/serial/JsonTool.hx:91: characters 6-33
				$v1 = $v;
				#src/jotun/serial/JsonTool.hx:92: characters 6-23
				$_this = $this->buf;
				$_this->b = ($_this->b??'null') . (\mb_chr(91)??'null');
				#src/jotun/serial/JsonTool.hx:93: characters 6-25
				$len = $v1->length;
				#src/jotun/serial/JsonTool.hx:94: characters 6-25
				$last = $len - 1;
				#src/jotun/serial/JsonTool.hx:95: characters 16-20
				$_g1 = 0;
				#src/jotun/serial/JsonTool.hx:95: characters 20-23
				$_g2 = $len;
				#src/jotun/serial/JsonTool.hx:95: lines 95-107
				while ($_g1 < $_g2) {
					#src/jotun/serial/JsonTool.hx:95: characters 16-23
					$i = $_g1++;
					#src/jotun/serial/JsonTool.hx:97: characters 7-47
					if ($i > 0) {
						#src/jotun/serial/JsonTool.hx:97: characters 18-35
						$_this = $this->buf;
						$_this->b = ($_this->b??'null') . (\mb_chr(44)??'null');
					} else {
						#src/jotun/serial/JsonTool.hx:97: characters 41-47
						$this->nind++;
					}
					#src/jotun/serial/JsonTool.hx:98: characters 7-13
					if ($this->pretty) {
						$_this1 = $this->buf;
						$_this1->b = ($_this1->b??'null') . (\mb_chr(10)??'null');
					}
					#src/jotun/serial/JsonTool.hx:99: characters 7-13
					if ($this->pretty) {
						$v2 = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
						$this->buf->add($v2);
					}
					#src/jotun/serial/JsonTool.hx:100: characters 7-21
					$this->write($i, ($v1->arr[$i] ?? null));
					#src/jotun/serial/JsonTool.hx:101: lines 101-106
					if ($i === $last) {
						#src/jotun/serial/JsonTool.hx:103: characters 8-14
						$this->nind--;
						#src/jotun/serial/JsonTool.hx:104: characters 8-14
						if ($this->pretty) {
							$_this2 = $this->buf;
							$_this2->b = ($_this2->b??'null') . (\mb_chr(10)??'null');
						}
						#src/jotun/serial/JsonTool.hx:105: characters 8-14
						if ($this->pretty) {
							$v3 = \StringTools::lpad("", $this->indent, $this->nind * mb_strlen($this->indent));
							$this->buf->add($v3);
						}
					}
				}
				#src/jotun/serial/JsonTool.hx:108: characters 6-23
				$_this = $this->buf;
				$_this->b = ($_this->b??'null') . (\mb_chr(93)??'null');
			} else if ($c === Boot::getClass(StringMap::class)) {
				#src/jotun/serial/JsonTool.hx:110: characters 6-45
				$v1 = $v;
				#src/jotun/serial/JsonTool.hx:111: characters 6-17
				$o = new HxAnon();
				#src/jotun/serial/JsonTool.hx:112: characters 16-24
				$data = \array_values(\array_map("strval", \array_keys($v1->data)));
				$_g_current = 0;
				$_g_length = \count($data);
				$_g_data = $data;
				#src/jotun/serial/JsonTool.hx:112: lines 112-113
				while ($_g_current < $_g_length) {
					$k = $_g_data[$_g_current++];
					#src/jotun/serial/JsonTool.hx:113: characters 7-37
					\Reflect::setField($o, $k, ($v1->data[$k] ?? null));
				}
				#src/jotun/serial/JsonTool.hx:114: characters 6-18
				$v1 = $o;
				$this->fieldsString($v1, \Reflect::fields($v1));
			} else if ($c === Boot::getClass(\Date::class)) {
				#src/jotun/serial/JsonTool.hx:116: characters 6-23
				$v1 = $v;
				#src/jotun/serial/JsonTool.hx:117: characters 6-25
				$this->quote($v1->toString());
			} else {
				#src/jotun/serial/JsonTool.hx:122: characters 6-18
				$this->fieldsString($v, \Reflect::fields($v));
			}
		} else if ($__hx__switch === 7) {
			#src/jotun/serial/JsonTool.hx:126: characters 15-16
			$_g1 = $_g->params[0];
			#src/jotun/serial/JsonTool.hx:127: characters 5-41
			$i = $v->index;
			#src/jotun/serial/JsonTool.hx:128: characters 5-11
			$this->buf->add($i);
		} else if ($__hx__switch === 8) {
			#src/jotun/serial/JsonTool.hx:68: characters 5-17
			$this->fieldsString($v, \Reflect::fields($v));
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
			#src/jotun/serial/JsonTool.hx:22: lines 22-24
			if (is_string($a)) {
				#src/jotun/serial/JsonTool.hx:23: characters 4-42
				if (HxDynamicStr::wrap($a)->substr(0, 1) === "_") {
					#src/jotun/serial/JsonTool.hx:23: characters 31-42
					return null;
				}
			}
			#src/jotun/serial/JsonTool.hx:25: characters 3-44
			if (($b instanceof Flag)) {
				#src/jotun/serial/JsonTool.hx:25: characters 30-44
				return Boot::dynamicField($b, 'value');
			}
			#src/jotun/serial/JsonTool.hx:26: characters 10-32
			if ($b === null) {
				#src/jotun/serial/JsonTool.hx:26: characters 24-28
				return null;
			} else {
				#src/jotun/serial/JsonTool.hx:26: characters 31-32
				return $b;
			}
		};
	}
}

Boot::registerClass(JsonTool::class, 'jotun.serial.JsonTool');
JsonTool::__hx__init();
