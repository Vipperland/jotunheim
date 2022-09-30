<?php
/**
 */

namespace jotun\tools;

use \php\_Boot\HxDynamicStr;
use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\utils\Dice;
use \haxe\Json;
use \jotun\utils\IColor;
use \php\_Boot\HxString;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Utils {
	/**
	 * @param mixed[]|\Array_hx $data
	 * @param string $separator
	 * @param string $and
	 * 
	 * @return string
	 */
	public static function And ($data, $separator = ", ", $and = " & ") {
		#src/jotun/tools/Utils.hx:522: lines 522-527
		if ($separator === null) {
			$separator = ", ";
		}
		if ($and === null) {
			$and = " & ";
		}
		if ($data->length > 1) {
			#src/jotun/tools/Utils.hx:523: characters 4-59
			$q = $data->splice(0, $data->length - 1);
			#src/jotun/tools/Utils.hx:524: characters 4-50
			return ($q->join($separator)??'null') . ($and??'null') . ($data->join("")??'null');
		} else {
			#src/jotun/tools/Utils.hx:526: characters 4-24
			return $data->join("");
		}
	}

	/**
	 * @param string $i
	 * @param string $n
	 * @param string $c
	 * @param string $p
	 * @param mixed $v
	 * @param bool $t
	 * @param bool $h
	 * @param bool $r
	 * 
	 * @return string
	 */
	public static function _codex ($i, $n, $c, $p, $v, $t, $h, $r) {
		#src/jotun/tools/Utils.hx:354: characters 3-259
		return ((($h ? "<div class=\"prop\"><span>" : ""))??'null') . ($i??'null') . ($p??'null') . ((($t ? ((($h ? "<span class=\"" . ($c??'null') . "\">" : ""))??'null') . ":" . ($n??'null') . ((($h ? "</span>" : ""))??'null') : ""))??'null') . "=" . ((($h && $r ? "</span><span class=\"" . ($c??'null') . " value\">" : ""))??'null') . \Std::string($v) . ((($h && $r ? "</span>" : ""))??'null') . ((($h ? "</div>" : "\x0A"))??'null');
	}

	/**
	 * @param string $i
	 * @param string $ls
	 * @param string $rs
	 * @param mixed $v
	 * @param bool $t
	 * @param bool $h
	 * 
	 * @return string
	 */
	public static function _codexWrap ($i, $ls, $rs, $v, $t, $h) {
		#src/jotun/tools/Utils.hx:358: characters 3-70
		return ($ls??'null') . ((($h ? "<br/>" : "\x0A"))??'null') . (Utils::_jstring($v, $i, "", $t, $h)??'null') . ($i??'null') . ($rs??'null');
	}

	/**
	 * @private
	 * 
	 * @param mixed $o
	 * @param string $i
	 * @param string $b
	 * @param bool $t
	 * @param bool $h
	 * 
	 * @return string
	 */
	public static function _jstring ($o, $i, $b, $t, $h) {
		#src/jotun/tools/Utils.hx:363: lines 363-365
		if ($h) {
			#src/jotun/tools/Utils.hx:364: characters 4-30
			$b = ($b??'null') . "<div class=\"block\">";
		}
		#src/jotun/tools/Utils.hx:366: characters 3-50
		$i = ($i??'null') . (($h ? "&nbsp;&nbsp;&nbsp;&nbsp;" : "\x09")??'null');
		#src/jotun/tools/Utils.hx:367: lines 367-388
		Dice::All($o, function ($p, $v) use (&$t, &$i, &$b, &$h) {
			#src/jotun/tools/Utils.hx:368: lines 368-387
			if ($v === null) {
				#src/jotun/tools/Utils.hx:369: characters 5-31
				$b = ($b??'null') . ($i??'null') . ($p??'null') . ":* = null\x0A";
			} else if (is_string($v)) {
				#src/jotun/tools/Utils.hx:372: characters 5-57
				$b = ($b??'null') . (Utils::_codex($i, "String", "string", $p, $v, $t, $h, true)??'null');
			} else if (is_bool($v)) {
				#src/jotun/tools/Utils.hx:375: characters 5-53
				$b = ($b??'null') . (Utils::_codex($i, "Bool", "bool", $p, $v, $t, $h, true)??'null');
			} else if (Boot::isOfType($v, Boot::getClass('Int'))) {
				#src/jotun/tools/Utils.hx:378: characters 5-51
				$b = ($b??'null') . (Utils::_codex($i, "Int", "int", $p, $v, $t, $h, true)??'null');
			} else if ((is_float($v) || is_int($v))) {
				#src/jotun/tools/Utils.hx:381: characters 5-55
				$b = ($b??'null') . (Utils::_codex($i, "Float", "float", $p, $v, $t, $h, true)??'null');
			} else if (($v instanceof \Array_hx)) {
				#src/jotun/tools/Utils.hx:384: characters 5-107
				$b = ($b??'null') . (Utils::_codex($i, "Array(" . \Std::string(Boot::dynamicField($v, 'length')) . ")", "array", $p, Utils::_codexWrap($i, "[", "]", $v, $t, $h), $t, $h, false)??'null');
			} else {
				#src/jotun/tools/Utils.hx:386: characters 5-91
				$b = ($b??'null') . (Utils::_codex($i, "Object", "object", $p, Utils::_codexWrap($i, "{", "}", $v, $t, $h), $t, $h, false)??'null');
			}
		});
		#src/jotun/tools/Utils.hx:389: lines 389-391
		if ($h) {
			#src/jotun/tools/Utils.hx:390: characters 4-17
			$b = ($b??'null') . "</div>";
		}
		#src/jotun/tools/Utils.hx:392: characters 3-11
		return $b;
	}

	/**
	 * @param mixed $q
	 * 
	 * @return bool
	 */
	public static function boolean ($q) {
		#src/jotun/tools/Utils.hx:473: characters 10-119
		if (!(($q === true) || Boot::equal($q, 1) || ($q === "1") || ($q === "true") || ($q === "yes") || ($q === "accept") || ($q === "ok"))) {
			#src/jotun/tools/Utils.hx:473: characters 104-119
			return $q === "selected";
		} else {
			#src/jotun/tools/Utils.hx:473: characters 10-119
			return true;
		}
	}

	/**
	 * Remove white and null values from array
	 * @param	path
	 * 
	 * @param string[]|\Array_hx $path
	 * @param mixed $filter
	 * 
	 * @return mixed[]|\Array_hx
	 */
	public static function clearArray ($path, $filter = null) {
		#src/jotun/tools/Utils.hx:320: characters 3-31
		$copy = new \Array_hx();
		#src/jotun/tools/Utils.hx:321: lines 321-325
		Dice::Values($path, function ($v) use (&$copy, &$filter) {
			#src/jotun/tools/Utils.hx:322: lines 322-324
			if (($v !== null) && ($v !== "") && (($filter === null) || $filter($v))) {
				#src/jotun/tools/Utils.hx:323: characters 5-26
				$copy->offsetSet($copy->length, $v);
			}
		});
		#src/jotun/tools/Utils.hx:326: characters 3-14
		return $copy;
	}

	/**
	 * #AARRGGBB OR #RRGGBB
	 * @param	hex
	 * @return
	 * 
	 * @param string $hex
	 * 
	 * @return IColor
	 */
	public static function color ($hex) {
		#src/jotun/tools/Utils.hx:554: characters 3-65
		$cI = (mb_strlen($hex) === 10 ? 3 : (mb_strlen($hex) === 9 ? 2 : 0));
		#src/jotun/tools/Utils.hx:556: characters 7-68
		$tmp = (mb_strlen($hex) === 9 ? \Std::parseInt("0x" . (\mb_substr($hex, 1, 2)??'null')) : 255);
		#src/jotun/tools/Utils.hx:557: characters 7-49
		$tmp1 = \Std::parseInt("0x" . (\mb_substr($hex, 1 + $cI, 2)??'null'));
		#src/jotun/tools/Utils.hx:558: characters 7-49
		$tmp2 = \Std::parseInt("0x" . (\mb_substr($hex, 3 + $cI, 2)??'null'));
		#src/jotun/tools/Utils.hx:555: lines 555-560
		return new _HxAnon_Utils0($tmp, $tmp1, $tmp2, \Std::parseInt("0x" . (\mb_substr($hex, 5 + $cI, 2)??'null')));
	}

	/**
	 * @param IColor $color
	 * @param float $multiply
	 * 
	 * @return string
	 */
	public static function colorToCss ($color, $multiply = null) {
		#src/jotun/tools/Utils.hx:564: characters 3-177
		return "rgb(" . ((int)(($color->r * $multiply))??'null') . " " . ((int)(($color->g * $multiply))??'null') . " " . ((int)(($color->b * $multiply))??'null') . "/" . (Utils::toFixed($color->a * $multiply / 255, 2)??'null') . ")";
	}

	/**
	 * @param string $url
	 * @param mixed $value
	 * @param bool $encode
	 * 
	 * @return string
	 */
	public static function createQueryParams ($url, $value, $encode = true) {
		#src/jotun/tools/Utils.hx:292: lines 292-305
		if ($encode === null) {
			$encode = true;
		}
		#src/jotun/tools/Utils.hx:293: characters 3-28
		$q = new \Array_hx();
		#src/jotun/tools/Utils.hx:294: lines 294-300
		Dice::All($value, function ($p, $v) use (&$encode, &$q) {
			#src/jotun/tools/Utils.hx:295: lines 295-299
			if (is_string($v) || (is_float($v) || is_int($v)) || is_bool($v)) {
				#src/jotun/tools/Utils.hx:296: characters 5-67
				$q->offsetSet($q->length, ($p??'null') . "=" . ((($encode ? \rawurlencode($v) : $v))??'null'));
			} else if (($v instanceof \Array_hx)) {
				#src/jotun/tools/Utils.hx:298: characters 5-88
				$q->offsetSet($q->length, ($p??'null') . "=" . ((($encode ? \rawurlencode($v->join(";")) : $v->join(";")))??'null'));
			}
		});
		#src/jotun/tools/Utils.hx:301: lines 301-303
		if ($url === null) {
			#src/jotun/tools/Utils.hx:302: characters 4-12
			$url = "";
		}
		#src/jotun/tools/Utils.hx:304: characters 3-66
		return ($url??'null') . (((HxString::indexOf($url, "?") === -1 ? "?" : "&"))??'null') . ($q->join("&")??'null');
	}

	/**
	 * @param float[]|\Array_hx $values
	 * @param \Closure $filter
	 * 
	 * @return float
	 */
	public static function getMax ($values, $filter = null) {
		#src/jotun/tools/Utils.hx:268: characters 3-22
		$r = null;
		#src/jotun/tools/Utils.hx:269: lines 269-272
		Dice::Values($values, function ($i) use (&$filter, &$r) {
			#src/jotun/tools/Utils.hx:270: lines 270-271
			if (($filter === null) || $filter($i)) {
				#src/jotun/tools/Utils.hx:271: characters 5-34
				if (($i > $r) || ($r === null)) {
					#src/jotun/tools/Utils.hx:271: characters 29-34
					$r = $i;
				}
			}
		});
		#src/jotun/tools/Utils.hx:273: characters 3-11
		return $r;
	}

	/**
	 * @param float[]|\Array_hx $values
	 * @param \Closure $filter
	 * 
	 * @return float
	 */
	public static function getMin ($values, $filter = null) {
		#src/jotun/tools/Utils.hx:259: characters 3-22
		$r = null;
		#src/jotun/tools/Utils.hx:260: lines 260-263
		Dice::Values($values, function ($i) use (&$filter, &$r) {
			#src/jotun/tools/Utils.hx:261: lines 261-262
			if (($filter === null) || $filter($i)) {
				#src/jotun/tools/Utils.hx:262: characters 5-34
				if (($i < $r) || ($r === null)) {
					#src/jotun/tools/Utils.hx:262: characters 29-34
					$r = $i;
				}
			}
		});
		#src/jotun/tools/Utils.hx:264: characters 3-11
		return $r;
	}

	/**
	 * @param string $value
	 * 
	 * @return mixed
	 */
	public static function getQueryParams ($value) {
		#src/jotun/tools/Utils.hx:277: characters 3-27
		$params = new HxAnon();
		#src/jotun/tools/Utils.hx:278: lines 278-282
		if ($value !== null) {
			#src/jotun/tools/Utils.hx:279: characters 12-55
			$_this = HxString::split(HxString::split($value, "+")->join(" "), "?");
			if ($_this->length > 0) {
				$_this->length--;
			}
			$value = \array_pop($_this->arr);
		} else {
			#src/jotun/tools/Utils.hx:281: characters 4-17
			return $params;
		}
		#src/jotun/tools/Utils.hx:283: lines 283-288
		Dice::Values(HxString::split($value, "&"), function ($v) use (&$params) {
			#src/jotun/tools/Utils.hx:284: characters 4-43
			$data = HxString::split($v, "=");
			#src/jotun/tools/Utils.hx:285: lines 285-287
			if ($data->length > 1) {
				#src/jotun/tools/Utils.hx:286: characters 5-93
				\Reflect::setField($params, \urldecode(($data->arr[0] ?? null)), \urldecode(($data->arr[1] ?? null)));
			}
		});
		#src/jotun/tools/Utils.hx:289: characters 3-16
		return $params;
	}

	/**
	 *
	 * @param	o
	 * @param	alt
	 * @return
	 * 
	 * @param mixed $o
	 * @param mixed $alt
	 * 
	 * @return mixed
	 */
	public static function getValidOne ($o, $alt) {
		#src/jotun/tools/Utils.hx:450: characters 10-30
		if (Utils::isValid($o)) {
			#src/jotun/tools/Utils.hx:450: characters 23-24
			return $o;
		} else {
			#src/jotun/tools/Utils.hx:450: characters 27-30
			return $alt;
		}
	}

	/**
	 * @param mixed $o
	 * @param int $min
	 * @param int $max
	 * 
	 * @return bool
	 */
	public static function isBetween ($o, $min, $max) {
		#src/jotun/tools/Utils.hx:411: lines 411-421
		if ($o !== null) {
			#src/jotun/tools/Utils.hx:412: lines 412-418
			if (!(is_float($o) || is_int($o))) {
				#src/jotun/tools/Utils.hx:413: lines 413-417
				if (($o instanceof \Array_hx) || is_string($o)) {
					#src/jotun/tools/Utils.hx:414: characters 6-18
					$o = Boot::dynamicField($o, 'length');
				} else {
					#src/jotun/tools/Utils.hx:416: characters 6-18
					return false;
				}
			}
		} else {
			#src/jotun/tools/Utils.hx:420: characters 4-16
			return false;
		}
		#src/jotun/tools/Utils.hx:422: lines 422-428
		if ($max === null) {
			#src/jotun/tools/Utils.hx:423: characters 4-19
			return $o >= $min;
		} else if ($min === null) {
			#src/jotun/tools/Utils.hx:425: characters 4-19
			return $o <= $max;
		} else if ($o >= $min) {
			#src/jotun/tools/Utils.hx:427: characters 23-31
			return $o <= $max;
		} else {
			#src/jotun/tools/Utils.hx:427: characters 11-31
			return false;
		}
	}

	/**
	 * @param mixed $o
	 * 
	 * @return bool
	 */
	public static function isFunction ($o) {
		#src/jotun/tools/Utils.hx:574: characters 4-54
		return is_callable($o);
	}

	/**
	 * Check if a value is !null or/and length>0 if a string
	 * @param	o
	 * @return
	 * 
	 * @param mixed $o
	 * @param int $len
	 * 
	 * @return bool
	 */
	public static function isValid ($o, $len = 0) {
		#src/jotun/tools/Utils.hx:400: lines 400-408
		if ($len === null) {
			$len = 0;
		}
		#src/jotun/tools/Utils.hx:401: lines 401-406
		if (($o !== null) && ($o !== "")) {
			#src/jotun/tools/Utils.hx:402: lines 402-405
			if (($o !== "null") && \Reflect::hasField($o, "length")) {
				#src/jotun/tools/Utils.hx:403: characters 12-26
				$a = Boot::dynamicField($o, 'length');
				$aNeg = $a < 0;
				$bNeg = $len < 0;
				if ($aNeg !== $bNeg) {
					return $aNeg;
				} else {
					return $a > $len;
				}
			} else if (!Boot::equal($o, 0)) {
				#src/jotun/tools/Utils.hx:405: characters 22-32
				return $o !== false;
			} else {
				#src/jotun/tools/Utils.hx:405: characters 12-32
				return false;
			}
		}
		#src/jotun/tools/Utils.hx:407: characters 3-15
		return false;
	}

	/**
	 * Check if a value is !null or/and length>0 if a string
	 * @param	o
	 * @return
	 * 
	 * @param mixed[]|\Array_hx $o
	 * 
	 * @return bool
	 */
	public static function isValidAll ($o) {
		#src/jotun/tools/Utils.hx:437: lines 437-439
		$q = Dice::Values($o, function ($v) {
			#src/jotun/tools/Utils.hx:438: characters 4-22
			return !Utils::isValid($v);
		});
		#src/jotun/tools/Utils.hx:440: characters 3-21
		return $q->completed;
	}

	/**
	 * data.split('{').join('').split('}').join('<br/>')
	 * @param	o
	 * @return
	 * 
	 * @param mixed $o
	 * @param bool $type
	 * @param bool $html
	 * 
	 * @return string
	 */
	public static function jotunStringify ($o, $type = true, $html = null) {
		#src/jotun/tools/Utils.hx:350: characters 3-41
		if ($type === null) {
			$type = true;
		}
		return Utils::_jstring($o, "", "", $type, $html);
	}

	/**
	 * @param mixed $val
	 * @param string $s
	 * @param string $a
	 * @param string $b
	 * 
	 * @return string
	 */
	public static function money ($val, $s = "\$", $a = ",", $b = ".") {
		#src/jotun/tools/Utils.hx:476: lines 476-500
		if ($s === null) {
			$s = "\$";
		}
		if ($a === null) {
			$a = ",";
		}
		if ($b === null) {
			$b = ".";
		}
		#src/jotun/tools/Utils.hx:477: characters 3-14
		$r = "";
		#src/jotun/tools/Utils.hx:478: characters 3-13
		$val *= 100;
		#src/jotun/tools/Utils.hx:479: lines 479-498
		if ($val > 99) {
			#src/jotun/tools/Utils.hx:480: characters 4-27
			$val = "" . ((int)($val)??'null');
			#src/jotun/tools/Utils.hx:481: characters 4-27
			$i = Boot::dynamicField($val, 'length');
			#src/jotun/tools/Utils.hx:482: characters 4-18
			$c = 0;
			#src/jotun/tools/Utils.hx:483: lines 483-495
			while ($i-- > 0) {
				#src/jotun/tools/Utils.hx:484: characters 5-29
				$r = \Std::string(HxDynamicStr::wrap($val)->substr($i, 1)) . ($r??'null');
				#src/jotun/tools/Utils.hx:485: lines 485-493
				if ($i > 0) {
					#src/jotun/tools/Utils.hx:486: lines 486-490
					if ($c === 1) {
						#src/jotun/tools/Utils.hx:487: characters 7-16
						$r = ($b??'null') . ($r??'null');
					} else if (($c > 1) && ((($c + 2) % 3) === 0)) {
						#src/jotun/tools/Utils.hx:489: characters 7-16
						$r = ($a??'null') . ($r??'null');
					}
				} else if ($c < 3) {
					#src/jotun/tools/Utils.hx:492: characters 6-39
					$r = "0" . ((($c === 1 ? "." : ""))??'null') . ($r??'null');
				}
				#src/jotun/tools/Utils.hx:494: characters 5-8
				++$c;
			}
		} else {
			#src/jotun/tools/Utils.hx:497: characters 4-45
			$r = "0" . ($b??'null') . ((($val < 10 ? "0" : ""))??'null') . \Std::string($val);
		}
		#src/jotun/tools/Utils.hx:499: characters 3-15
		return ($s??'null') . ($r??'null');
	}

	/**
	 * @param mixed $o
	 * 
	 * @return string
	 */
	public static function paramsOf ($o) {
		#src/jotun/tools/Utils.hx:507: characters 3-28
		$r = new \Array_hx();
		#src/jotun/tools/Utils.hx:508: lines 508-517
		Dice::All($o, function ($p, $v) use (&$r) {
			#src/jotun/tools/Utils.hx:509: lines 509-516
			if (Utils::isValid($v) && !Utils::isFunction($v)) {
				#src/jotun/tools/Utils.hx:510: lines 510-514
				if ((is_float($v) || is_int($v))) {
					#src/jotun/tools/Utils.hx:511: characters 6-23
					$v = \Std::string($v);
				} else if (!is_string($v)) {
					#src/jotun/tools/Utils.hx:513: characters 10-27
					$v = Json::phpJsonEncode($v, null, null);
				}
				#src/jotun/tools/Utils.hx:515: characters 5-53
				$r->offsetSet($r->length, ($p??'null') . "=" . (\rawurlencode($v)??'null'));
			}
		});
		#src/jotun/tools/Utils.hx:518: characters 3-21
		return $r->join("&");
	}

	/**
	 * @param string $value
	 * @param int $length
	 * @param string $q
	 * 
	 * @return string
	 */
	public static function prefix ($value, $length, $q) {
		#src/jotun/tools/Utils.hx:531: lines 531-533
		while (mb_strlen($value) < $length) {
			#src/jotun/tools/Utils.hx:532: characters 4-21
			$value = ($q??'null') . ($value??'null');
		}
		#src/jotun/tools/Utils.hx:534: characters 3-15
		return $value;
	}

	/**
	 * @param string $url
	 * @param mixed $params
	 * 
	 * @return string
	 */
	public static function replaceQuery ($url, $params) {
		#src/jotun/tools/Utils.hx:308: characters 3-45
		$current = Utils::getQueryParams($url);
		#src/jotun/tools/Utils.hx:309: lines 309-311
		Dice::All($params, function ($p, $v) use (&$current) {
			#src/jotun/tools/Utils.hx:310: characters 4-35
			\Reflect::setField($current, $p, $v);
		});
		#src/jotun/tools/Utils.hx:312: characters 3-55
		return Utils::createQueryParams((HxString::split($url, "?")->arr[0] ?? null), $current);
	}

	/**
	 * @param string $value
	 * 
	 * @return string
	 */
	public static function rnToBr ($value) {
		#src/jotun/tools/Utils.hx:545: characters 3-95
		return HxString::split(HxString::split(HxString::split($value, "\x0D\x0A")->join("<br/>"), "\x0D")->join("<br/>"), "\x0A")->join("<br/>");
	}

	/**
	 * @param mixed $q
	 * 
	 * @return mixed
	 */
	public static function stdClone ($q) {
		#src/jotun/tools/Utils.hx:503: characters 10-39
		return Json::phpJsonDecode(Json::phpJsonEncode($q, null, null));
	}

	/**
	 * @param string $value
	 * @param int $length
	 * @param string $q
	 * 
	 * @return string
	 */
	public static function sufix ($value, $length, $q) {
		#src/jotun/tools/Utils.hx:538: lines 538-540
		while (mb_strlen($value) < $length) {
			#src/jotun/tools/Utils.hx:539: characters 4-21
			$value = ($value??'null') . ($q??'null');
		}
		#src/jotun/tools/Utils.hx:541: characters 3-15
		return $value;
	}

	/**
	 * @param float $n
	 * @param int $i
	 * @param string $s
	 * @param string $t
	 * 
	 * @return string
	 */
	public static function toFixed ($n, $i, $s = ".", $t = "") {
		#src/jotun/tools/Utils.hx:570: characters 4-77
		if ($s === null) {
			$s = ".";
		}
		if ($t === null) {
			$t = "";
		}
		return number_format($n,$i,$s,$t);
	}

	/**
	 * Convert a value to String or Json string
	 * @param	o
	 * @param	json
	 * @return
	 * 
	 * @param mixed $o
	 * @param bool $json
	 * 
	 * @return string
	 */
	public static function toString ($o, $json = null) {
		#src/jotun/tools/Utils.hx:341: characters 10-58
		if ($json === true) {
			#src/jotun/tools/Utils.hx:341: characters 25-42
			return Json::phpJsonEncode($o, null, null);
		} else {
			#src/jotun/tools/Utils.hx:341: characters 45-58
			return \Std::string($o);
		}
	}

	/**
	 * @param string $value
	 * 
	 * @return string
	 */
	public static function trimm ($value) {
		#src/jotun/tools/Utils.hx:330: characters 3-98
		return HxString::split(HxString::split(HxString::split(HxString::split($value, "\x0D")->join(""), "\x0A")->join(""), "\x09")->join(""), " ")->join("");
	}

	/**
	 * Class name of the object
	 * @param	o
	 * @return
	 * 
	 * @param mixed $o
	 * 
	 * @return string
	 */
	public static function typeof ($o) {
		#src/jotun/tools/Utils.hx:459: characters 3-19
		$name = null;
		#src/jotun/tools/Utils.hx:460: lines 460-467
		if ($o !== null) {
			#src/jotun/tools/Utils.hx:461: lines 461-463
			try {
				#src/jotun/tools/Utils.hx:462: characters 5-52
				return Boot::dynamicField(Boot::dynamicField(Boot::dynamicField($o, '__proto__'), '__class__'), '__name__')->join(".");
			} catch(\Throwable $_g) {
			}
			#src/jotun/tools/Utils.hx:464: lines 464-466
			try {
				#src/jotun/tools/Utils.hx:465: characters 5-47
				return \Type::getClassName(\Type::getClass($o));
			} catch(\Throwable $_g) {
			}
		}
		#src/jotun/tools/Utils.hx:468: characters 3-14
		return null;
	}
}

class _HxAnon_Utils0 extends HxAnon {
	function __construct($a, $r, $g, $b) {
		$this->a = $a;
		$this->r = $r;
		$this->g = $g;
		$this->b = $b;
	}
}

Boot::registerClass(Utils::class, 'jotun.tools.Utils');
