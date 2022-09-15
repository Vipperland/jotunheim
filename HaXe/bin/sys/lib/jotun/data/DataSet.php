<?php
/**
 */

namespace jotun\data;

use \php\_Boot\HxDynamicStr;
use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\utils\Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class DataSet implements IDataSet {
	/**
	 * @var mixed
	 */
	public $_content;

	/**
	 * @param mixed $q
	 * 
	 * @return void
	 */
	public function __construct ($q = null) {
		#src/jotun/data/DataSet.hx:15: characters 3-32
		$this->_content = ($q !== null ? $q : new HxAnon());
	}

	/**
	 * @return IDataSet
	 */
	public function clear () {
		#src/jotun/data/DataSet.hx:39: characters 3-17
		$this->_content = new HxAnon();
		#src/jotun/data/DataSet.hx:40: characters 3-14
		return $this;
	}

	/**
	 * @return mixed
	 */
	public function data () {
		#src/jotun/data/DataSet.hx:82: characters 3-18
		return $this->_content;
	}

	/**
	 * @param mixed $handler
	 * 
	 * @return void
	 */
	public function each ($handler) {
		#src/jotun/data/DataSet.hx:78: characters 3-30
		Dice::All($this->_content, $handler);
	}

	/**
	 * @param mixed $p
	 * 
	 * @return bool
	 */
	public function exists ($p) {
		#src/jotun/data/DataSet.hx:35: characters 3-39
		return \Reflect::hasField($this->_content, $p);
	}

	/**
	 * @param mixed $p
	 * @param mixed $handler
	 * 
	 * @return IDataSet
	 */
	public function filter ($p, $handler = null) {
		#src/jotun/data/DataSet.hx:65: characters 3-34
		$r = new DataSet();
		#src/jotun/data/DataSet.hx:66: characters 3-32
		$h = $handler !== null;
		#src/jotun/data/DataSet.hx:67: lines 67-73
		Dice::All($this->_content, function ($p2, $v) use (&$r, &$handler, &$p, &$h) {
			#src/jotun/data/DataSet.hx:68: lines 68-72
			if (($v instanceof IDataSet)) {
				#src/jotun/data/DataSet.hx:69: characters 5-58
				if ($v->exists($p)) {
					#src/jotun/data/DataSet.hx:69: characters 22-58
					$r->set($p2, ($h ? $handler($v) : $v->get($p)));
				}
			} else if (\Reflect::hasField($v, $p)) {
				#src/jotun/data/DataSet.hx:71: characters 5-52
				$r->set($p2, ($h ? $handler($v) : \Reflect::field($v, $p)));
			}
		});
		#src/jotun/data/DataSet.hx:74: characters 3-11
		return $r;
	}

	/**
	 * @param mixed $v
	 * 
	 * @return mixed[]|\Array_hx
	 */
	public function find ($v) {
		#src/jotun/data/DataSet.hx:44: characters 3-28
		$r = new \Array_hx();
		#src/jotun/data/DataSet.hx:45: lines 45-48
		Dice::All($this->_content, function ($p, $x) use (&$r, &$v) {
			#src/jotun/data/DataSet.hx:46: lines 46-47
			if (is_string($x) && !Boot::equal(HxDynamicStr::wrap($x)->indexOf($v), -1)) {
				#src/jotun/data/DataSet.hx:46: characters 55-70
				$r->offsetSet($r->length, $p);
			} else if (Boot::equal($x, $v)) {
				#src/jotun/data/DataSet.hx:47: characters 20-35
				$r->offsetSet($r->length, $p);
			}
		});
		#src/jotun/data/DataSet.hx:49: characters 3-11
		return $r;
	}

	/**
	 * @param mixed $p
	 * 
	 * @return mixed
	 */
	public function get ($p) {
		#src/jotun/data/DataSet.hx:21: characters 3-36
		return \Reflect::field($this->_content, $p);
	}

	/**
	 * @return string[]|\Array_hx
	 */
	public function index () {
		#src/jotun/data/DataSet.hx:53: characters 3-28
		$r = new \Array_hx();
		#src/jotun/data/DataSet.hx:54: characters 3-32
		Dice::Params($this->_content, Boot::getInstanceClosure($r, 'push'));
		#src/jotun/data/DataSet.hx:55: characters 3-11
		return $r;
	}

	/**
	 * @param mixed $p
	 * @param mixed $v
	 * 
	 * @return IDataSet
	 */
	public function set ($p, $v) {
		#src/jotun/data/DataSet.hx:25: characters 3-35
		\Reflect::setField($this->_content, $p, $v);
		#src/jotun/data/DataSet.hx:26: characters 3-14
		return $this;
	}

	/**
	 * @param mixed $p
	 * 
	 * @return IDataSet
	 */
	public function unset ($p) {
		#src/jotun/data/DataSet.hx:30: characters 3-35
		\Reflect::deleteField($this->_content, $p);
		#src/jotun/data/DataSet.hx:31: characters 3-14
		return $this;
	}

	/**
	 * @return mixed[]|\Array_hx
	 */
	public function values () {
		#src/jotun/data/DataSet.hx:59: characters 3-29
		$r = new \Array_hx();
		#src/jotun/data/DataSet.hx:60: characters 3-32
		Dice::Values($this->_content, Boot::getInstanceClosure($r, 'push'));
		#src/jotun/data/DataSet.hx:61: characters 3-11
		return $r;
	}
}

Boot::registerClass(DataSet::class, 'jotun.data.DataSet');
