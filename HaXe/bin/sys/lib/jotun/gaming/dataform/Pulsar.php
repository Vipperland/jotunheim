<?php
/**
 */

namespace jotun\gaming\dataform;

use \jotun\serial\Packager;
use \php\_Boot\HxAnon;
use \jotun\tools\Key;
use \php\Boot;
use \haxe\Exception;
use \jotun\signals\Signals;
use \jotun\utils\Dice;
use \jotun\errors\Error;
use \php\_Boot\HxString;

/**
 * ...
 * @author Rim Project
 */
class Pulsar {
	/**
	 * @var int
	 */
	static public $BLOCK_SIZE = 64;
	/**
	 * @var int
	 */
	static public $ID_SIZE = 32;
	/**
	 * @var mixed
	 */
	static public $_dictio;

	/**
	 * @var mixed
	 */
	public $_open_links;
	/**
	 * @var Signals
	 */
	public $signals;

	/**
	 * @param string $name
	 * @param string[]|\Array_hx $r
	 * 
	 * @return Spark
	 */
	public static function construct ($name, $r) {
		#src/jotun/gaming/dataform/Pulsar.hx:39: characters 3-24
		$O = null;
		#src/jotun/gaming/dataform/Pulsar.hx:40: characters 3-22
		$o = null;
		#src/jotun/gaming/dataform/Pulsar.hx:41: characters 3-22
		$indexable = null;
		#src/jotun/gaming/dataform/Pulsar.hx:42: lines 42-49
		if (\Reflect::hasField(Pulsar::$_dictio, $name)) {
			#src/jotun/gaming/dataform/Pulsar.hx:43: characters 4-36
			$O = \Reflect::field(Pulsar::$_dictio, $name);
			#src/jotun/gaming/dataform/Pulsar.hx:44: lines 44-48
			if (Boot::dynamicField($O, 'Tag')) {
				#src/jotun/gaming/dataform/Pulsar.hx:45: characters 26-37
				$tmp = Boot::dynamicField($O, 'Construct');
				#src/jotun/gaming/dataform/Pulsar.hx:45: characters 5-44
				$o = new $tmp->phpClassName($name);
			} else {
				#src/jotun/gaming/dataform/Pulsar.hx:47: characters 26-37
				$tmp = Boot::dynamicField($O, 'Construct');
				#src/jotun/gaming/dataform/Pulsar.hx:47: characters 5-38
				$o = new $tmp->phpClassName();
			}
		}
		#src/jotun/gaming/dataform/Pulsar.hx:50: lines 50-60
		if ($o !== null) {
			#src/jotun/gaming/dataform/Pulsar.hx:51: lines 51-59
			if ($r->length === 3) {
				#src/jotun/gaming/dataform/Pulsar.hx:52: characters 5-16
				$o->id = ($r->arr[1] ?? null);
				#src/jotun/gaming/dataform/Pulsar.hx:53: characters 5-18
				$o->merge(($r->arr[2] ?? null));
			} else if ($r->length === 2) {
				#src/jotun/gaming/dataform/Pulsar.hx:55: lines 55-57
				if (Boot::dynamicField($O, 'Indexable')) {
					#src/jotun/gaming/dataform/Pulsar.hx:56: characters 6-29
					$o->id = Key::GEN(Pulsar::$ID_SIZE);
				}
				#src/jotun/gaming/dataform/Pulsar.hx:58: characters 5-18
				$o->merge(($r->arr[1] ?? null));
			}
		}
		#src/jotun/gaming/dataform/Pulsar.hx:61: characters 3-11
		return $o;
	}

	/**
	 * @param string $name
	 * 
	 * @return bool
	 */
	public static function isIndexable ($name) {
		#src/jotun/gaming/dataform/Pulsar.hx:65: characters 10-90
		if (\Reflect::hasField(Pulsar::$_dictio, $name)) {
			#src/jotun/gaming/dataform/Pulsar.hx:65: characters 44-82
			return Boot::dynamicField(\Reflect::field(Pulsar::$_dictio, $name), 'Indexable');
		} else {
			#src/jotun/gaming/dataform/Pulsar.hx:65: characters 85-90
			return false;
		}
	}

	/**
	 * @param string $name
	 * @param string[]|\Array_hx $props
	 * @param mixed $object
	 * @param bool $indexable
	 * @param bool $tageable
	 * 
	 * @return void
	 */
	public static function map ($name, $props, $object = null, $indexable = true, $tageable = true) {
		#src/jotun/gaming/dataform/Pulsar.hx:26: lines 26-36
		if ($indexable === null) {
			$indexable = true;
		}
		if ($tageable === null) {
			$tageable = true;
		}
		#src/jotun/gaming/dataform/Pulsar.hx:27: lines 27-34
		if ($object === null) {
			#src/jotun/gaming/dataform/Pulsar.hx:33: characters 4-18
			$object = Boot::getClass(Spark::class);
		}
		#src/jotun/gaming/dataform/Pulsar.hx:35: characters 3-136
		\Reflect::setField(Pulsar::$_dictio, $name, new _HxAnon_Pulsar0(($object === null ? Boot::getClass(Spark::class) : $object), $props, $indexable, $tageable));
	}

	/**
	 * @param string $name
	 * 
	 * @return string[]|\Array_hx
	 */
	public static function propertiesOf ($name) {
		#src/jotun/gaming/dataform/Pulsar.hx:69: characters 10-90
		if (\Reflect::hasField(Pulsar::$_dictio, $name)) {
			#src/jotun/gaming/dataform/Pulsar.hx:69: characters 44-83
			return Boot::dynamicField(\Reflect::field(Pulsar::$_dictio, $name), 'Properties');
		} else {
			#src/jotun/gaming/dataform/Pulsar.hx:69: characters 86-90
			return null;
		}
	}

	/**
	 * @param string $data
	 * 
	 * @return void
	 */
	public function __construct ($data = null) {
		#src/jotun/gaming/dataform/Pulsar.hx:145: characters 3-19
		$this->_open_links = new HxAnon();
		#src/jotun/gaming/dataform/Pulsar.hx:146: characters 3-30
		$this->signals = new Signals($this);
		#src/jotun/gaming/dataform/Pulsar.hx:147: lines 147-149
		if (($data !== null) && (mb_strlen($data) > 0)) {
			#src/jotun/gaming/dataform/Pulsar.hx:148: characters 4-15
			$this->parse($data);
		}
	}

	/**
	 * @param string[]|\Array_hx $r
	 * 
	 * @return void
	 */
	public function _delete ($r) {
		#src/jotun/gaming/dataform/Pulsar.hx:104: lines 104-109
		if ($r->length === 2) {
			#src/jotun/gaming/dataform/Pulsar.hx:105: characters 4-34
			$x = $this->link(($r->arr[0] ?? null));
			#src/jotun/gaming/dataform/Pulsar.hx:106: lines 106-108
			if ($x !== null) {
				#src/jotun/gaming/dataform/Pulsar.hx:107: characters 5-40
				$this->_onLinkDelete($x->delete(($r->arr[1] ?? null), true));
			}
		}
	}

	/**
	 * @param string $r
	 * 
	 * @return string
	 */
	public function _encode ($r) {
		#src/jotun/gaming/dataform/Pulsar.hx:266: characters 3-43
		$r1 = Packager::encodeBase64($r);
		#src/jotun/gaming/dataform/Pulsar.hx:267: characters 3-17
		$i = 0;
		#src/jotun/gaming/dataform/Pulsar.hx:268: lines 268-271
		while (\mb_substr($r1, mb_strlen($r1) - 1, 1) === "=") {
			#src/jotun/gaming/dataform/Pulsar.hx:269: characters 4-36
			$r1 = HxString::substring($r1, 0, mb_strlen($r1) - 1);
			#src/jotun/gaming/dataform/Pulsar.hx:270: characters 4-7
			++$i;
		}
		#src/jotun/gaming/dataform/Pulsar.hx:272: characters 3-42
		$r1 = "#" . (Packager::md5Encode($r1)??'null') . ($i??'null') . ($r1??'null');
		#src/jotun/gaming/dataform/Pulsar.hx:273: characters 3-8
		$i = 0;
		#src/jotun/gaming/dataform/Pulsar.hx:274: characters 3-22
		$nr = "";
		#src/jotun/gaming/dataform/Pulsar.hx:275: characters 3-26
		$len = mb_strlen($r1);
		#src/jotun/gaming/dataform/Pulsar.hx:276: lines 276-279
		while ($i < $len) {
			#src/jotun/gaming/dataform/Pulsar.hx:277: characters 4-40
			$nr = ($nr??'null') . (\mb_substr($r1, $i, Pulsar::$BLOCK_SIZE)??'null') . "\x0A";
			#src/jotun/gaming/dataform/Pulsar.hx:278: characters 4-19
			$i += Pulsar::$BLOCK_SIZE;
		}
		#src/jotun/gaming/dataform/Pulsar.hx:280: characters 3-38
		return HxString::substring($nr, 0, mb_strlen($nr) - 1);
	}

	/**
	 * @param Spark $o
	 * @param string[]|\Array_hx $r
	 * 
	 * @return bool
	 */
	public function _exists ($o, $r) {
		#src/jotun/gaming/dataform/Pulsar.hx:84: lines 84-89
		if ($r->length >= 2) {
			#src/jotun/gaming/dataform/Pulsar.hx:85: characters 4-34
			$x = $this->link(($r->arr[0] ?? null));
			#src/jotun/gaming/dataform/Pulsar.hx:86: lines 86-88
			if ($x !== null) {
				#src/jotun/gaming/dataform/Pulsar.hx:87: characters 5-26
				return $x->exists(($r->arr[1] ?? null));
			}
		}
		#src/jotun/gaming/dataform/Pulsar.hx:90: characters 3-15
		return false;
	}

	/**
	 * @param string $name
	 * 
	 * @return PulsarLink
	 */
	public function _getOrCreate ($name) {
		#src/jotun/gaming/dataform/Pulsar.hx:75: characters 3-55
		$x = \Reflect::field($this->_open_links, $name);
		#src/jotun/gaming/dataform/Pulsar.hx:76: lines 76-79
		if ($x === null) {
			#src/jotun/gaming/dataform/Pulsar.hx:77: characters 4-28
			$x = new PulsarLink($name);
			#src/jotun/gaming/dataform/Pulsar.hx:78: characters 4-42
			\Reflect::setField($this->_open_links, $name, $x);
		}
		#src/jotun/gaming/dataform/Pulsar.hx:80: characters 3-11
		return $x;
	}

	/**
	 * @param string[]|\Array_hx $r
	 * 
	 * @return Spark
	 */
	public function _grab ($r) {
		#src/jotun/gaming/dataform/Pulsar.hx:94: lines 94-99
		if ($r->length >= 2) {
			#src/jotun/gaming/dataform/Pulsar.hx:95: characters 4-34
			$x = $this->link(($r->arr[0] ?? null));
			#src/jotun/gaming/dataform/Pulsar.hx:96: lines 96-98
			if ($x !== null) {
				#src/jotun/gaming/dataform/Pulsar.hx:97: characters 5-23
				return $x->get(($r->arr[1] ?? null));
			}
		}
		#src/jotun/gaming/dataform/Pulsar.hx:100: characters 3-14
		return null;
	}

	/**
	 * @param Spark $o
	 * 
	 * @return void
	 */
	public function _onLinkAdd ($o) {
		#src/jotun/gaming/dataform/Pulsar.hx:113: characters 3-46
		$this->signals->call(PulsarSignals::$LINK_CREATED, $o);
	}

	/**
	 * @param Spark $o
	 * 
	 * @return void
	 */
	public function _onLinkDelete ($o) {
		#src/jotun/gaming/dataform/Pulsar.hx:123: characters 3-46
		$this->signals->call(PulsarSignals::$LINK_DELETED, $o);
	}

	/**
	 * @param Spark $o
	 * 
	 * @return void
	 */
	public function _onLinkUpdate ($o) {
		#src/jotun/gaming/dataform/Pulsar.hx:133: characters 3-46
		$this->signals->call(PulsarSignals::$LINK_UPDATED, $o);
	}

	/**
	 * @param Spark $o
	 * 
	 * @return void
	 */
	public function _onObjectAdd ($o) {
		#src/jotun/gaming/dataform/Pulsar.hx:117: lines 117-119
		if ($o !== null) {
			#src/jotun/gaming/dataform/Pulsar.hx:118: characters 4-48
			$this->signals->call(PulsarSignals::$SPARK_CREATED, $o);
		}
	}

	/**
	 * @param Spark $o
	 * 
	 * @return void
	 */
	public function _onObjectDelete ($o) {
		#src/jotun/gaming/dataform/Pulsar.hx:127: lines 127-129
		if ($o !== null) {
			#src/jotun/gaming/dataform/Pulsar.hx:128: characters 4-48
			$this->signals->call(PulsarSignals::$SPARK_DELETED, $o);
		}
	}

	/**
	 * @param Spark $o
	 * 
	 * @return void
	 */
	public function _onObjectUpdate ($o) {
		#src/jotun/gaming/dataform/Pulsar.hx:137: lines 137-139
		if ($o !== null) {
			#src/jotun/gaming/dataform/Pulsar.hx:138: characters 4-48
			$this->signals->call(PulsarSignals::$SPARK_UPDATED, $o);
		}
	}

	/**
	 * @param bool $encode
	 * @param bool $changes
	 * @param string $name
	 * 
	 * @return string
	 */
	public function _toString ($encode = null, $changes = null, $name = null) {
		#src/jotun/gaming/dataform/Pulsar.hx:284: characters 3-21
		$r = "";
		#src/jotun/gaming/dataform/Pulsar.hx:285: characters 3-23
		$c = null;
		#src/jotun/gaming/dataform/Pulsar.hx:286: lines 286-296
		Dice::Values($this->_open_links, function ($list) use (&$name, &$c, &$changes, &$r) {
			#src/jotun/gaming/dataform/Pulsar.hx:287: lines 287-295
			if (($name === null) || $list->is($name)) {
				#src/jotun/gaming/dataform/Pulsar.hx:288: characters 5-32
				$c = $list->stringify($changes);
				#src/jotun/gaming/dataform/Pulsar.hx:289: lines 289-294
				if ($c !== null) {
					#src/jotun/gaming/dataform/Pulsar.hx:290: lines 290-292
					if (mb_strlen($r) > 0) {
						#src/jotun/gaming/dataform/Pulsar.hx:291: characters 7-16
						$r = ($r??'null') . "\x0A";
					}
					#src/jotun/gaming/dataform/Pulsar.hx:293: characters 6-12
					$r = ($r??'null') . ($c??'null');
				}
			}
		});
		#src/jotun/gaming/dataform/Pulsar.hx:297: lines 297-299
		if ($encode) {
			#src/jotun/gaming/dataform/Pulsar.hx:298: characters 4-18
			$r = $this->_encode($r);
		}
		#src/jotun/gaming/dataform/Pulsar.hx:300: characters 3-11
		return $r;
	}

	/**
	 * @return Pulsar
	 */
	public function clone () {
		#src/jotun/gaming/dataform/Pulsar.hx:352: characters 3-31
		$o = new Pulsar();
		#src/jotun/gaming/dataform/Pulsar.hx:353: characters 3-27
		$o->parse($this->toString(false));
		#src/jotun/gaming/dataform/Pulsar.hx:354: characters 3-11
		return $o;
	}

	/**
	 * @return void
	 */
	public function commit () {
		#src/jotun/gaming/dataform/Pulsar.hx:346: lines 346-348
		Dice::Values($this->_open_links, function ($list) {
			#src/jotun/gaming/dataform/Pulsar.hx:347: characters 4-17
			$list->commit();
		});
	}

	/**
	 * @param \Closure $handler
	 * 
	 * @return void
	 */
	public function each ($handler) {
		#src/jotun/gaming/dataform/Pulsar.hx:334: characters 3-36
		Dice::Values($this->_open_links, $handler);
	}

	/**
	 * @param string $name
	 * 
	 * @return bool
	 */
	public function exists ($name) {
		#src/jotun/gaming/dataform/Pulsar.hx:320: characters 3-45
		return \Reflect::hasField($this->_open_links, $name);
	}

	/**
	 * @param	o
	 * @return
	 * 
	 * @param Spark $o
	 * 
	 * @return bool
	 */
	public function insert ($o) {
		#src/jotun/gaming/dataform/Pulsar.hx:158: characters 3-33
		$name = $o->getName();
		#src/jotun/gaming/dataform/Pulsar.hx:159: lines 159-170
		if (($name !== null) && (mb_strlen($name) > 0)) {
			#src/jotun/gaming/dataform/Pulsar.hx:160: characters 4-42
			$x = $this->_getOrCreate($name);
			#src/jotun/gaming/dataform/Pulsar.hx:162: lines 162-166
			if (Pulsar::isIndexable($name)) {
				#src/jotun/gaming/dataform/Pulsar.hx:163: lines 163-165
				while (($o->id === null) && !$x->exists($o->id)) {
					#src/jotun/gaming/dataform/Pulsar.hx:164: characters 6-29
					$o->id = Key::GEN(Pulsar::$ID_SIZE);
				}
			}
			#src/jotun/gaming/dataform/Pulsar.hx:167: characters 4-15
			$x->insert($o);
		} else {
			#src/jotun/gaming/dataform/Pulsar.hx:169: characters 4-12
			$o = null;
		}
		#src/jotun/gaming/dataform/Pulsar.hx:171: characters 3-19
		return $o !== null;
	}

	/**
	 * @param string $name
	 * 
	 * @return PulsarLink
	 */
	public function link ($name) {
		#src/jotun/gaming/dataform/Pulsar.hx:324: characters 3-42
		return \Reflect::field($this->_open_links, $name);
	}

	/**
	 * @return PulsarLink[]|\Array_hx
	 */
	public function links () {
		#src/jotun/gaming/dataform/Pulsar.hx:328: characters 3-32
		$r = new \Array_hx();
		#src/jotun/gaming/dataform/Pulsar.hx:329: characters 3-35
		Dice::Values($this->_open_links, Boot::getInstanceClosure($r, 'push'));
		#src/jotun/gaming/dataform/Pulsar.hx:330: characters 3-11
		return $r;
	}

	/**
	 * @param	data
	 * 
	 * @param string $data
	 * 
	 * @return int
	 */
	public function parse ($data) {
		#src/jotun/gaming/dataform/Pulsar.hx:178: lines 178-263
		$_gthis = $this;
		#src/jotun/gaming/dataform/Pulsar.hx:179: lines 179-192
		if (\mb_substr($data, 0, 1) === "#") {
			#src/jotun/gaming/dataform/Pulsar.hx:180: characters 4-36
			$data = HxString::split($data, "\x0A")->join("");
			#src/jotun/gaming/dataform/Pulsar.hx:181: characters 4-43
			$key = HxString::substring($data, 1, 33);
			#src/jotun/gaming/dataform/Pulsar.hx:182: characters 4-53
			$e = \Std::parseInt(HxString::substring($data, 33, 34));
			#src/jotun/gaming/dataform/Pulsar.hx:183: characters 4-42
			$data = HxString::substring($data, 34, mb_strlen($data));
			#src/jotun/gaming/dataform/Pulsar.hx:184: lines 184-186
			if (Packager::md5Encode($data) !== $key) {
				#src/jotun/gaming/dataform/Pulsar.hx:185: characters 5-10
				throw Exception::thrown(new Error(1, "Invalid data object"));
			}
			#src/jotun/gaming/dataform/Pulsar.hx:187: lines 187-190
			while ($e > 0) {
				#src/jotun/gaming/dataform/Pulsar.hx:188: characters 5-16
				$data = ($data??'null') . "=";
				#src/jotun/gaming/dataform/Pulsar.hx:189: characters 5-8
				--$e;
			}
			#src/jotun/gaming/dataform/Pulsar.hx:191: characters 4-38
			$data = Packager::decodeBase64($data);
		}
		#src/jotun/gaming/dataform/Pulsar.hx:193: characters 3-19
		$len = 0;
		#src/jotun/gaming/dataform/Pulsar.hx:194: characters 3-42
		$i = HxString::split($data, "\x0A");
		#src/jotun/gaming/dataform/Pulsar.hx:195: characters 3-22
		$l = null;
		#src/jotun/gaming/dataform/Pulsar.hx:196: lines 196-257
		Dice::Values($i, function ($v) use (&$len, &$l, &$_gthis) {
			#src/jotun/gaming/dataform/Pulsar.hx:197: characters 4-42
			$q = HxString::split($v, " @::");
			#src/jotun/gaming/dataform/Pulsar.hx:198: characters 4-42
			$r = HxString::split(($q->arr[0] ?? null), " ");
			#src/jotun/gaming/dataform/Pulsar.hx:199: characters 4-22
			$r->offsetSet($r->length, ($q->arr[1] ?? null));
			#src/jotun/gaming/dataform/Pulsar.hx:200: lines 200-256
			if ($r->length > 0) {
				#src/jotun/gaming/dataform/Pulsar.hx:201: characters 5-13
				$v = ($r->arr[0] ?? null);
				#src/jotun/gaming/dataform/Pulsar.hx:202: characters 5-40
				$cmd = HxString::substring($v, 0, 1);
				#src/jotun/gaming/dataform/Pulsar.hx:203: characters 5-24
				$o = null;
				#src/jotun/gaming/dataform/Pulsar.hx:204: lines 204-255
				if ($cmd === "-") {
					#src/jotun/gaming/dataform/Pulsar.hx:227: characters 7-17
					$cmd = ($r->arr[0] ?? null);
					#src/jotun/gaming/dataform/Pulsar.hx:228: characters 7-42
					$r->offsetSet(0, HxString::substring($cmd, 1, mb_strlen($cmd)));
					#src/jotun/gaming/dataform/Pulsar.hx:229: lines 229-231
					if ($_gthis->_exists(null, $r)) {
						#src/jotun/gaming/dataform/Pulsar.hx:230: characters 8-18
						$_gthis->_delete($r);
					}
				} else if ($cmd === "/") {
					#src/jotun/gaming/dataform/Pulsar.hx:222: lines 222-224
					if ($l !== null) {
						#src/jotun/gaming/dataform/Pulsar.hx:223: characters 8-45
						$_gthis->_onObjectDelete($l->delete(($r->arr[1] ?? null), true));
					}
				} else if ($cmd === ">") {
					#src/jotun/gaming/dataform/Pulsar.hx:206: lines 206-219
					if ($l !== null) {
						#src/jotun/gaming/dataform/Pulsar.hx:207: characters 8-36
						$v = HxString::substring($v, 1, mb_strlen($v));
						#src/jotun/gaming/dataform/Pulsar.hx:208: lines 208-218
						if (($r->length === 3) && $l->exists(($r->arr[1] ?? null))) {
							#src/jotun/gaming/dataform/Pulsar.hx:209: characters 9-24
							$o = $l->get(($r->arr[1] ?? null));
							#src/jotun/gaming/dataform/Pulsar.hx:210: characters 9-22
							$o->merge(($r->arr[2] ?? null));
							#src/jotun/gaming/dataform/Pulsar.hx:211: characters 9-27
							$_gthis->_onObjectUpdate($o);
						} else {
							#src/jotun/gaming/dataform/Pulsar.hx:213: characters 9-28
							$o = Pulsar::construct($v, $r);
							#src/jotun/gaming/dataform/Pulsar.hx:214: lines 214-217
							if ($l->insert($o)) {
								#src/jotun/gaming/dataform/Pulsar.hx:215: characters 10-18
								$len += 1;
								#src/jotun/gaming/dataform/Pulsar.hx:216: characters 10-25
								$_gthis->_onObjectAdd($o);
							}
						}
					}
				} else {
					#src/jotun/gaming/dataform/Pulsar.hx:234: lines 234-253
					if ($_gthis->_exists(null, $r)) {
						#src/jotun/gaming/dataform/Pulsar.hx:235: characters 8-20
						$o = $_gthis->_grab($r);
						#src/jotun/gaming/dataform/Pulsar.hx:236: lines 236-239
						if ($r->length === 3) {
							#src/jotun/gaming/dataform/Pulsar.hx:237: characters 9-22
							$o->merge(($r->arr[2] ?? null));
							#src/jotun/gaming/dataform/Pulsar.hx:238: characters 9-25
							$_gthis->_onLinkUpdate($o);
						}
						#src/jotun/gaming/dataform/Pulsar.hx:240: characters 8-13
						$l = $o;
					} else {
						#src/jotun/gaming/dataform/Pulsar.hx:242: characters 8-27
						$o = Pulsar::construct($v, $r);
						#src/jotun/gaming/dataform/Pulsar.hx:243: lines 243-252
						if ($_gthis->insert($o)) {
							#src/jotun/gaming/dataform/Pulsar.hx:244: lines 244-246
							if ($l !== null) {
								#src/jotun/gaming/dataform/Pulsar.hx:245: characters 10-21
								$l->refresh();
							}
							#src/jotun/gaming/dataform/Pulsar.hx:247: characters 9-14
							$l = $o;
							#src/jotun/gaming/dataform/Pulsar.hx:248: characters 9-17
							$len += 1;
							#src/jotun/gaming/dataform/Pulsar.hx:249: characters 9-22
							$_gthis->_onLinkAdd($o);
						} else {
							#src/jotun/gaming/dataform/Pulsar.hx:251: characters 9-17
							$l = null;
						}
					}
				}
			}
		});
		#src/jotun/gaming/dataform/Pulsar.hx:258: lines 258-260
		if ($l !== null) {
			#src/jotun/gaming/dataform/Pulsar.hx:259: characters 4-15
			$l->refresh();
		}
		#src/jotun/gaming/dataform/Pulsar.hx:261: characters 3-12
		$this->refresh();
		#src/jotun/gaming/dataform/Pulsar.hx:262: characters 3-13
		return $len;
	}

	/**
	 * @param string $name
	 * 
	 * @return void
	 */
	public function refresh ($name = null) {
		#src/jotun/gaming/dataform/Pulsar.hx:338: lines 338-342
		Dice::Values($this->_open_links, function ($list) use (&$name) {
			#src/jotun/gaming/dataform/Pulsar.hx:339: lines 339-341
			if (($name === null) || $list->is($name)) {
				#src/jotun/gaming/dataform/Pulsar.hx:340: characters 5-19
				$list->refresh();
			}
		});
	}

	/**
	 * @return
	 * 
	 * @param bool $encode
	 * @param string $name
	 * 
	 * @return string
	 */
	public function toChangedString ($encode = null, $name = null) {
		#src/jotun/gaming/dataform/Pulsar.hx:316: characters 3-39
		return $this->_toString($encode, true, $name);
	}

	/**
	 * @return
	 * 
	 * @param bool $encode
	 * @param string $name
	 * 
	 * @return string
	 */
	public function toString ($encode = null, $name = null) {
		#src/jotun/gaming/dataform/Pulsar.hx:308: characters 3-40
		return $this->_toString($encode, false, $name);
	}

	public function __toString() {
		return $this->toString();
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


		self::$_dictio = new HxAnon();
	}
}

class _HxAnon_Pulsar0 extends HxAnon {
	function __construct($_hx_0, $Properties, $Indexable, $Tag) {
		$this->{"Construct"} = $_hx_0;
		$this->Properties = $Properties;
		$this->Indexable = $Indexable;
		$this->Tag = $Tag;
	}
}

Boot::registerClass(Pulsar::class, 'jotun.gaming.dataform.Pulsar');
Pulsar::__hx__init();
