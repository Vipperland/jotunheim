<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace jotun\utils;

use \php\_Boot\HxDynamicStr;
use \php\Boot;
use \php\_Boot\HxString;

/**
 * ...
 * @author Rafael Moreira
 */
class SearchTag {
	/**
	 * @var \EReg
	 */
	static public $_E;
	/**
	 * @var mixed
	 */
	static public $_M;

	/**
	 * @var string[]|\Array_hx
	 */
	public $tags;

	/**
	 * @param mixed $data
	 * @param string $space
	 * 
	 * @return string
	 */
	public static function clear ($data, $space = "+") {
		#src/jotun/utils/SearchTag.hx:23: lines 23-35
		if ($space === null) {
			$space = "+";
		}
		#src/jotun/utils/SearchTag.hx:24: characters 10-40
		$data = \mb_strtolower(\Std::string($data));
		#src/jotun/utils/SearchTag.hx:26: characters 3-17
		$i = 0;
		#src/jotun/utils/SearchTag.hx:27: characters 3-25
		$l = Boot::dynamicField(SearchTag::$_M, 'length');
		#src/jotun/utils/SearchTag.hx:28: lines 28-31
		while ($i < $l) {
			#src/jotun/utils/SearchTag.hx:29: characters 4-46
			$data = HxDynamicStr::wrap($data)->split((SearchTag::$_M[$i]->arr[0] ?? null))->join((SearchTag::$_M[$i]->arr[1] ?? null));
			#src/jotun/utils/SearchTag.hx:30: characters 4-7
			++$i;
		}
		#src/jotun/utils/SearchTag.hx:32: characters 3-37
		$data = HxDynamicStr::wrap($data)->split(" ")->join($space);
		#src/jotun/utils/SearchTag.hx:33: characters 3-38
		$data = HxDynamicStr::wrap($data)->split("\x09")->join($space);
		#src/jotun/utils/SearchTag.hx:34: characters 3-14
		return $data;
	}

	/**
	 * @param mixed $value
	 * 
	 * @return SearchTag
	 */
	public static function create ($value) {
		#src/jotun/utils/SearchTag.hx:18: lines 18-19
		if (!($value instanceof SearchTag)) {
			#src/jotun/utils/SearchTag.hx:19: characters 4-32
			$value = new SearchTag($value);
		}
		#src/jotun/utils/SearchTag.hx:20: characters 3-15
		return $value;
	}

	/**
	 * @param mixed $tags
	 * 
	 * @return void
	 */
	public function __construct ($tags = null) {
		#src/jotun/utils/SearchTag.hx:44: characters 3-12
		$tags = new \Array_hx();
		#src/jotun/utils/SearchTag.hx:45: characters 3-12
		$this->add($tags);
	}

	/**
	 * @return string
	 */
	public function _tag () {
		#src/jotun/utils/SearchTag.hx:40: characters 3-36
		return "|" . ($this->tags->join("|")??'null') . "|";
	}

	/**
	 * @param mixed $values
	 * 
	 * @return void
	 */
	public function add ($values) {
		#src/jotun/utils/SearchTag.hx:49: lines 49-57
		$_gthis = $this;
		#src/jotun/utils/SearchTag.hx:50: characters 12-59
		if (!($values instanceof \Array_hx)) {
			#src/jotun/utils/SearchTag.hx:50: characters 51-59
			$values = \Array_hx::wrap([$values]);
		}
		#src/jotun/utils/SearchTag.hx:51: lines 51-56
		Dice::Values($values, function ($v) use (&$_gthis) {
			#src/jotun/utils/SearchTag.hx:52: characters 4-16
			$v = SearchTag::clear($v);
			#src/jotun/utils/SearchTag.hx:53: characters 4-43
			$iof = \Lambda::indexOf($_gthis->tags, $v);
			#src/jotun/utils/SearchTag.hx:54: lines 54-55
			if ($iof === -1) {
				#src/jotun/utils/SearchTag.hx:55: characters 5-36
				$_gthis->tags->offsetSet($_gthis->tags->length, $v);
			}
		});
	}

	/**
	 * @param mixed $values
	 * @param bool $equality
	 * 
	 * @return float
	 */
	public function compare ($values, $equality = false) {
		#src/jotun/utils/SearchTag.hx:70: lines 70-81
		if ($equality === null) {
			$equality = false;
		}
		#src/jotun/utils/SearchTag.hx:71: characters 3-27
		$tag = $this->_tag();
		#src/jotun/utils/SearchTag.hx:72: characters 3-31
		$values = SearchTag::create($values)->tags;
		#src/jotun/utils/SearchTag.hx:73: characters 3-34
		$total = Boot::dynamicField($values, 'length');
		#src/jotun/utils/SearchTag.hx:74: lines 74-79
		$count = Dice::Values($values, function ($v) use (&$tag, &$equality) {
			#src/jotun/utils/SearchTag.hx:75: lines 75-78
			if ($equality) {
				#src/jotun/utils/SearchTag.hx:76: characters 5-44
				return HxString::indexOf($tag, "|" . ($v??'null') . "|") === -1;
			} else {
				#src/jotun/utils/SearchTag.hx:78: characters 5-32
				return HxString::indexOf($tag, $v) !== -1;
			}
		})->keys;
		#src/jotun/utils/SearchTag.hx:80: characters 10-21
		$int = $count;
		$int1 = $total;
		#src/jotun/utils/SearchTag.hx:80: characters 3-27
		return (($int < 0 ? 4294967296.0 + $int : $int + 0.0)) / (($int1 < 0 ? 4294967296.0 + $int1 : $int1 + 0.0)) * 100;
	}

	/**
	 * @param mixed $values
	 * 
	 * @return bool
	 */
	public function contains ($values) {
		#src/jotun/utils/SearchTag.hx:90: characters 3-27
		$tag = $this->_tag();
		#src/jotun/utils/SearchTag.hx:91: characters 3-31
		$values = SearchTag::create($values)->tags;
		#src/jotun/utils/SearchTag.hx:92: characters 3-94
		return !Dice::Values($values, function ($v) use (&$tag) {
			#src/jotun/utils/SearchTag.hx:92: characters 52-79
			return HxString::indexOf($tag, $v) !== -1;
		})->completed;
	}

	/**
	 * @param mixed $values
	 * 
	 * @return bool
	 */
	public function equal ($values) {
		#src/jotun/utils/SearchTag.hx:84: characters 3-27
		$tag = $this->_tag();
		#src/jotun/utils/SearchTag.hx:85: characters 3-31
		$values = SearchTag::create($values)->tags;
		#src/jotun/utils/SearchTag.hx:86: characters 3-105
		return Dice::Values($values, function ($v) use (&$tag) {
			#src/jotun/utils/SearchTag.hx:86: characters 51-90
			return HxString::indexOf($tag, "|" . ($v??'null') . "|") === -1;
		})->completed;
	}

	/**
	 * @param mixed $values
	 * 
	 * @return void
	 */
	public function remove ($values) {
		#src/jotun/utils/SearchTag.hx:60: lines 60-67
		$_gthis = $this;
		#src/jotun/utils/SearchTag.hx:61: characters 3-31
		$values = SearchTag::create($values)->tags;
		#src/jotun/utils/SearchTag.hx:62: lines 62-66
		Dice::Values($values, function ($v) use (&$_gthis) {
			#src/jotun/utils/SearchTag.hx:63: characters 4-43
			$iof = \Lambda::indexOf($_gthis->tags, $v);
			#src/jotun/utils/SearchTag.hx:64: lines 64-65
			if ($iof !== -1) {
				#src/jotun/utils/SearchTag.hx:65: characters 5-29
				$_gthis->tags->splice($iof, 1);
			}
		});
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


		self::$_M = \Array_hx::wrap([
			\Array_hx::wrap([
				"á",
				"a",
			]),
			\Array_hx::wrap([
				"ã",
				"a",
			]),
			\Array_hx::wrap([
				"â",
				"a",
			]),
			\Array_hx::wrap([
				"à",
				"a",
			]),
			\Array_hx::wrap([
				"ê",
				"e",
			]),
			\Array_hx::wrap([
				"é",
				"e",
			]),
			\Array_hx::wrap([
				"è",
				"e",
			]),
			\Array_hx::wrap([
				"î",
				"i",
			]),
			\Array_hx::wrap([
				"í",
				"i",
			]),
			\Array_hx::wrap([
				"ì",
				"i",
			]),
			\Array_hx::wrap([
				"õ",
				"o",
			]),
			\Array_hx::wrap([
				"ô",
				"o",
			]),
			\Array_hx::wrap([
				"ó",
				"o",
			]),
			\Array_hx::wrap([
				"ò",
				"o",
			]),
			\Array_hx::wrap([
				"ú",
				"u",
			]),
			\Array_hx::wrap([
				"ù",
				"u",
			]),
			\Array_hx::wrap([
				"û",
				"u",
			]),
			\Array_hx::wrap([
				"ç",
				"c",
			]),
			\Array_hx::wrap([
				"[",
				"",
			]),
			\Array_hx::wrap([
				"]",
				"",
			]),
		]);
		self::$_E = new \EReg("^[a-z0-9]", "g");
	}
}

Boot::registerClass(SearchTag::class, 'jotun.utils.SearchTag');
SearchTag::__hx__init();