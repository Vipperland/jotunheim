<?php
/**
 */

namespace jotun\php\db\tools;

use \php\_Boot\HxAnon;
use \php\Boot;
use \jotun\utils\Filler;
use \jotun\php\db\Clause;
use \jotun\utils\Dice;
use \jotun\php\db\IGate;
use \jotun\php\db\objects\IDataTable;

/**
 * ...
 * @author Rafael Moreira
 */
class QueryBuilder implements IQueryBuilder {
	/**
	 * @var IGate
	 */
	public $_gate;

	/**
	 * @param IGate $gate
	 * 
	 * @return void
	 */
	public function __construct ($gate) {
		#src/jotun/php/db/tools/QueryBuilder.hx:18: characters 3-15
		$this->_gate = $gate;
	}

	/**
	 * @param mixed $clause
	 * @param mixed[]|\Array_hx $parameters
	 * @param mixed $order
	 * @param string $limit
	 * 
	 * @return string
	 */
	public function _assembleBody ($clause = null, $parameters = null, $order = null, $limit = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:114: characters 3-21
		$q = "";
		#src/jotun/php/db/tools/QueryBuilder.hx:115: lines 115-116
		if ($clause !== null) {
			#src/jotun/php/db/tools/QueryBuilder.hx:116: characters 4-68
			$q = ($q??'null') . " WHERE " . ($this->_conditions($clause, $parameters, " || ", false)??'null');
		}
		#src/jotun/php/db/tools/QueryBuilder.hx:117: lines 117-118
		if ($order !== null) {
			#src/jotun/php/db/tools/QueryBuilder.hx:118: characters 4-37
			$q = ($q??'null') . " ORDER BY " . ($this->_order($order)??'null');
		}
		#src/jotun/php/db/tools/QueryBuilder.hx:119: lines 119-120
		if ($limit !== null) {
			#src/jotun/php/db/tools/QueryBuilder.hx:120: characters 4-26
			$q = ($q??'null') . " LIMIT " . ($limit??'null');
		}
		#src/jotun/php/db/tools/QueryBuilder.hx:121: characters 3-11
		return $q;
	}

	/**
	 * @param mixed $obj
	 * @param mixed $props
	 * @param string $joiner
	 * @param bool $skip
	 * 
	 * @return string
	 */
	public function _conditions ($obj, $props, $joiner, $skip) {
		#src/jotun/php/db/tools/QueryBuilder.hx:51: lines 51-111
		$_gthis = $this;
		#src/jotun/php/db/tools/QueryBuilder.hx:53: characters 3-28
		$r = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:54: characters 3-25
		$s = $joiner;
		#src/jotun/php/db/tools/QueryBuilder.hx:55: characters 3-21
		$b = true;
		#src/jotun/php/db/tools/QueryBuilder.hx:58: lines 58-102
		if (($obj instanceof Clause)) {
			#src/jotun/php/db/tools/QueryBuilder.hx:59: lines 59-63
			Dice::Values(Boot::dynamicField($obj, 'conditions'), function ($v) use (&$skip, &$r, &$_gthis, &$props, &$joiner) {
				#src/jotun/php/db/tools/QueryBuilder.hx:60: characters 5-44
				$v = $_gthis->_conditions($v, $props, $joiner, $skip);
				#src/jotun/php/db/tools/QueryBuilder.hx:61: lines 61-62
				if ($v !== null) {
					#src/jotun/php/db/tools/QueryBuilder.hx:62: characters 6-21
					$r->offsetSet($r->length, $v);
				}
			});
			#src/jotun/php/db/tools/QueryBuilder.hx:64: characters 4-20
			$s = $obj->joiner();
		} else if (($obj instanceof \Array_hx)) {
			#src/jotun/php/db/tools/QueryBuilder.hx:68: lines 68-78
			Dice::All($obj, function ($p, $v) use (&$skip, &$r, &$_gthis, &$props, &$joiner) {
				#src/jotun/php/db/tools/QueryBuilder.hx:69: lines 69-77
				if (($v instanceof Clause)) {
					#src/jotun/php/db/tools/QueryBuilder.hx:70: characters 6-49
					$v = $_gthis->_conditions($v, $props, $v->joiner(), $skip);
					#src/jotun/php/db/tools/QueryBuilder.hx:71: lines 71-72
					if ($v !== null) {
						#src/jotun/php/db/tools/QueryBuilder.hx:72: characters 7-22
						$r->offsetSet($r->length, $v);
					}
				} else {
					#src/jotun/php/db/tools/QueryBuilder.hx:74: characters 6-45
					$v = $_gthis->_conditions($v, $props, $joiner, $skip);
					#src/jotun/php/db/tools/QueryBuilder.hx:75: lines 75-76
					if ($v !== null) {
						#src/jotun/php/db/tools/QueryBuilder.hx:76: characters 7-22
						$r->offsetSet($r->length, $v);
					}
				}
			});
		} else if (is_string($obj)) {
			#src/jotun/php/db/tools/QueryBuilder.hx:81: characters 4-21
			$r->offsetSet($r->length, $obj);
		} else if ($obj !== null) {
			#src/jotun/php/db/tools/QueryBuilder.hx:85: lines 85-101
			if ((Boot::dynamicField($obj, 'value') instanceof \Array_hx)) {
				#src/jotun/php/db/tools/QueryBuilder.hx:86: characters 5-61
				$r->offsetSet($r->length, Filler::to(Boot::dynamicField($obj, 'condition'), new _HxAnon_QueryBuilder0(Boot::dynamicField($obj, 'param'))));
				#src/jotun/php/db/tools/QueryBuilder.hx:87: lines 87-89
				Dice::All(Boot::dynamicField($obj, 'value'), function ($p, $v) use (&$props) {
					#src/jotun/php/db/tools/QueryBuilder.hx:88: characters 6-29
					$props[Boot::dynamicField($props, 'length')] = $v;
				});
			} else if ($skip) {
				#src/jotun/php/db/tools/QueryBuilder.hx:92: characters 6-97
				$r->offsetSet($r->length, Filler::splitter(Filler::to(Boot::dynamicField($obj, 'condition'), new _HxAnon_QueryBuilder0(Boot::dynamicField($obj, 'param'))), "?", \Array_hx::wrap([Boot::dynamicField($obj, 'value')])));
			} else {
				#src/jotun/php/db/tools/QueryBuilder.hx:94: characters 6-62
				$r->offsetSet($r->length, Filler::to(Boot::dynamicField($obj, 'condition'), new _HxAnon_QueryBuilder0(Boot::dynamicField($obj, 'param'))));
				#src/jotun/php/db/tools/QueryBuilder.hx:95: lines 95-98
				if (!Boot::dynamicField($obj, 'skip')) {
					#src/jotun/php/db/tools/QueryBuilder.hx:96: characters 7-63
					$r->offsetSet($r->length, Filler::to(Boot::dynamicField($obj, 'condition'), new _HxAnon_QueryBuilder0(Boot::dynamicField($obj, 'param'))));
					#src/jotun/php/db/tools/QueryBuilder.hx:97: characters 7-38
					$props[Boot::dynamicField($props, 'length')] = Boot::dynamicField($obj, 'value');
				}
			}
		}
		#src/jotun/php/db/tools/QueryBuilder.hx:104: lines 104-109
		if ($r->length > 0) {
			#src/jotun/php/db/tools/QueryBuilder.hx:105: characters 4-20
			$b = $r->length > 1;
			#src/jotun/php/db/tools/QueryBuilder.hx:106: characters 4-54
			return ((($b ? "(" : ""))??'null') . ($r->join($s)??'null') . ((($b ? ")" : ""))??'null');
		} else {
			#src/jotun/php/db/tools/QueryBuilder.hx:108: characters 4-15
			return null;
		}
	}

	/**
	 * @param mixed $parameters
	 * @param mixed[]|\Array_hx $dataset
	 * 
	 * @return string
	 */
	public function _insert ($parameters, $dataset) {
		#src/jotun/php/db/tools/QueryBuilder.hx:22: characters 3-28
		$r = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:23: characters 3-28
		$q = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:24: characters 3-18
		$i = 0;
		#src/jotun/php/db/tools/QueryBuilder.hx:25: lines 25-30
		Dice::All($parameters, function ($p, $v) use (&$dataset, &$i, &$r, &$q) {
			#src/jotun/php/db/tools/QueryBuilder.hx:26: characters 4-12
			$r->offsetSet($i, $p);
			#src/jotun/php/db/tools/QueryBuilder.hx:27: characters 4-14
			$q->offsetSet($i, "?");
			#src/jotun/php/db/tools/QueryBuilder.hx:28: characters 4-7
			$i += 1;
			#src/jotun/php/db/tools/QueryBuilder.hx:29: characters 4-31
			$dataset->offsetSet($dataset->length, $v);
		});
		#src/jotun/php/db/tools/QueryBuilder.hx:31: characters 3-62
		return "(" . ($r->join(",")??'null') . ") VALUES (" . ($q->join(",")??'null') . ")";
	}

	/**
	 * @param mixed $obj
	 * 
	 * @return string
	 */
	public function _order ($obj) {
		#src/jotun/php/db/tools/QueryBuilder.hx:46: characters 3-28
		$r = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:47: characters 3-98
		Dice::All($obj, function ($p, $v) use (&$r) {
			#src/jotun/php/db/tools/QueryBuilder.hx:47: characters 49-93
			$r->offsetSet($r->length, ($p??'null') . ((($v !== null ? " " . \Std::string($v) : ""))??'null'));
		});
		#src/jotun/php/db/tools/QueryBuilder.hx:48: characters 3-21
		return $r->join(",");
	}

	/**
	 * @param mixed $parameters
	 * @param mixed[]|\Array_hx $dataset
	 * 
	 * @return string
	 */
	public function _updateSet ($parameters, $dataset) {
		#src/jotun/php/db/tools/QueryBuilder.hx:36: characters 3-28
		$q = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:37: lines 37-40
		Dice::All($parameters, function ($p, $v) use (&$dataset, &$q) {
			#src/jotun/php/db/tools/QueryBuilder.hx:38: characters 4-26
			$q->offsetSet($q->length, ($p??'null') . "=?");
			#src/jotun/php/db/tools/QueryBuilder.hx:39: characters 4-31
			$dataset->offsetSet($dataset->length, $v);
		});
		#src/jotun/php/db/tools/QueryBuilder.hx:41: characters 3-21
		return $q->join(",");
	}

	/**
	 * @param string $table
	 * @param mixed $parameters
	 * 
	 * @return ICommand
	 */
	public function add ($table, $parameters = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:125: characters 3-35
		$dataset = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:126: characters 3-124
		return $this->_gate->prepare("INSERT INTO " . ($table??'null') . ($this->_insert($parameters, $dataset)??'null') . ($this->_assembleBody(null, $dataset)??'null') . ";", $dataset);
	}

	/**
	 * @param string $from
	 * @param string $to
	 * @param mixed $clause
	 * @param \Closure $filter
	 * @param string $limit
	 * 
	 * @return mixed[]|\Array_hx
	 */
	public function copy ($from, $to, $clause = null, $filter = null, $limit = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:152: lines 152-164
		$_gthis = $this;
		#src/jotun/php/db/tools/QueryBuilder.hx:153: characters 3-69
		$entries = $this->find("*", $from, $clause, null, $limit)->result;
		#src/jotun/php/db/tools/QueryBuilder.hx:154: characters 3-34
		$result = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:155: lines 155-162
		Dice::Values($entries, function ($v) use (&$to, &$filter, &$_gthis, &$result) {
			#src/jotun/php/db/tools/QueryBuilder.hx:156: lines 156-158
			if ($filter !== null) {
				#src/jotun/php/db/tools/QueryBuilder.hx:157: characters 5-18
				$v = $filter($v);
			}
			#src/jotun/php/db/tools/QueryBuilder.hx:159: lines 159-161
			if ($_gthis->add($to, $v)->success) {
				#src/jotun/php/db/tools/QueryBuilder.hx:160: characters 5-30
				$result->offsetSet($result->length, $v);
			}
		});
		#src/jotun/php/db/tools/QueryBuilder.hx:163: characters 3-16
		return $result;
	}

	/**
	 * @param string $table
	 * @param mixed $clause
	 * @param mixed $order
	 * @param string $limit
	 * 
	 * @return ICommand
	 */
	public function delete ($table, $clause = null, $order = null, $limit = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:148: characters 3-31
		$parameters = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:149: characters 3-115
		return $this->_gate->prepare("DELETE FROM " . ($table??'null') . ($this->_assembleBody($clause, $parameters, $order, $limit)??'null') . ";", $parameters);
	}

	/**
	 * @param string $table
	 * @param string $reference
	 * @param string $key
	 * @param string $target
	 * @param string $field
	 * @param string $delete
	 * @param string $update
	 * 
	 * @return ICommand
	 */
	public function fKey ($table, $reference, $key = null, $target = null, $field = null, $delete = "RESTRICT", $update = "RESTRICT") {
		#src/jotun/php/db/tools/QueryBuilder.hx:167: lines 167-171
		if ($delete === null) {
			$delete = "RESTRICT";
		}
		if ($update === null) {
			$update = "RESTRICT";
		}
		if ($key === null) {
			#src/jotun/php/db/tools/QueryBuilder.hx:168: characters 4-81
			return $this->_gate->query("ALTER TABLE " . ($table??'null') . " DROP FOREIGN KEY " . ($reference??'null'));
		} else {
			#src/jotun/php/db/tools/QueryBuilder.hx:170: characters 4-230
			return $this->_gate->query("ALTER TABLE " . ($table??'null') . " ADD CONSTRAINT " . ($reference??'null') . " FOREIGN KEY (" . ($key??'null') . ") REFERENCES " . ($target??'null') . "(" . ($field??'null') . ") ON DELETE " . (\mb_strtoupper($delete)??'null') . " ON UPDATE " . (\mb_strtoupper($update)??'null') . ";");
		}
	}

	/**
	 * @param mixed $fields
	 * @param mixed $table
	 * @param mixed $clause
	 * @param mixed $order
	 * @param string $limit
	 * 
	 * @return IExtCommand
	 */
	public function find ($fields, $table, $clause = null, $order = null, $limit = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:130: lines 130-132
		if (($fields instanceof \Array_hx)) {
			#src/jotun/php/db/tools/QueryBuilder.hx:131: characters 4-29
			$fields = $fields->join(",");
		}
		#src/jotun/php/db/tools/QueryBuilder.hx:133: characters 3-27
		$joinner = "";
		#src/jotun/php/db/tools/QueryBuilder.hx:134: lines 134-137
		if (($table instanceof \Array_hx)) {
			#src/jotun/php/db/tools/QueryBuilder.hx:135: characters 4-37
			$main = $table->shift();
			#src/jotun/php/db/tools/QueryBuilder.hx:136: characters 4-40
			$table = \Std::string($main) . " " . \Std::string($table->join(" "));
		}
		#src/jotun/php/db/tools/QueryBuilder.hx:138: characters 3-31
		$parameters = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:139: characters 3-128
		return $this->_gate->query("SELECT " . \Std::string($fields) . " FROM " . \Std::string($table) . ($this->_assembleBody($clause, $parameters, $order, $limit)??'null') . ";", $parameters);
	}

	/**
	 * @param mixed $table
	 * @param string $name
	 * @param mixed $clause
	 * 
	 * @return string
	 */
	public function fullOuterJoin ($table, $name = null, $clause = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:203: characters 3-50
		return "FULL " . ($this->outerJoin($table, $name, $clause)??'null');
	}

	/**
	 * @param mixed $table
	 * @param string $name
	 * @param mixed $clause
	 * 
	 * @return string
	 */
	public function join ($table, $name = null, $clause = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:183: characters 3-162
		return "JOIN " . (((($table instanceof IDataTable) ? Boot::dynamicField($table, 'name') : $table))??'null') . ((($name !== null ? " AS " . ($name??'null') : ""))??'null') . " ON " . ($this->_conditions($clause, new \Array_hx(), " || ", true)??'null');
	}

	/**
	 * @param mixed $table
	 * @param string $name
	 * @param mixed $clause
	 * 
	 * @return string
	 */
	public function leftJoin ($table, $name = null, $clause = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:187: characters 3-45
		return "LEFT " . ($this->join($table, $name, $clause)??'null');
	}

	/**
	 * @param mixed $table
	 * @param string $name
	 * @param mixed $clause
	 * 
	 * @return string
	 */
	public function leftOuterJoin ($table, $name = null, $clause = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:195: characters 3-50
		return "LEFT " . ($this->outerJoin($table, $name, $clause)??'null');
	}

	/**
	 * @param mixed $table
	 * @param string $name
	 * @param mixed $clause
	 * 
	 * @return string
	 */
	public function outerJoin ($table, $name = null, $clause = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:191: characters 3-46
		return "OUTER " . ($this->join($table, $name, $clause)??'null');
	}

	/**
	 * @param string $table
	 * @param string $to
	 * 
	 * @return ICommand
	 */
	public function rename ($table, $to) {
		#src/jotun/php/db/tools/QueryBuilder.hx:179: characters 3-89
		return $this->_gate->prepare("RENAME TABLE :oldname TO :newname", new _HxAnon_QueryBuilder1($table, $to));
	}

	/**
	 * @param mixed $table
	 * @param string $name
	 * @param mixed $clause
	 * 
	 * @return string
	 */
	public function rightOuterJoin ($table, $name = null, $clause = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:199: characters 3-51
		return "RIGHT " . ($this->outerJoin($table, $name, $clause)??'null');
	}

	/**
	 * @param string $table
	 * 
	 * @return ICommand
	 */
	public function truncate ($table) {
		#src/jotun/php/db/tools/QueryBuilder.hx:175: characters 3-57
		return $this->_gate->prepare("TRUNCATE :table", new _HxAnon_QueryBuilder2($table));
	}

	/**
	 * @param string $table
	 * @param mixed $clause
	 * @param mixed $parameters
	 * @param mixed $order
	 * @param string $limit
	 * 
	 * @return ICommand
	 */
	public function update ($table, $clause = null, $parameters = null, $order = null, $limit = null) {
		#src/jotun/php/db/tools/QueryBuilder.hx:143: characters 3-35
		$dataset = new \Array_hx();
		#src/jotun/php/db/tools/QueryBuilder.hx:144: characters 3-148
		return $this->_gate->prepare("UPDATE " . ($table??'null') . " SET " . ($this->_updateSet($parameters, $dataset)??'null') . ($this->_assembleBody($clause, $dataset, $order, $limit)??'null') . ";", $dataset);
	}
}

class _HxAnon_QueryBuilder0 extends HxAnon {
	function __construct($p) {
		$this->p = $p;
	}
}

class _HxAnon_QueryBuilder1 extends HxAnon {
	function __construct($oldname, $newname) {
		$this->oldname = $oldname;
		$this->newname = $newname;
	}
}

class _HxAnon_QueryBuilder2 extends HxAnon {
	function __construct($table) {
		$this->table = $table;
	}
}

Boot::registerClass(QueryBuilder::class, 'jotun.php.db.tools.QueryBuilder');
