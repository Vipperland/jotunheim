<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace jotun\gateway\domain;

use \jotun\gaming\dataform\Pulsar;
use \jotun\utils\Omnitools;
use \php\Boot;
use \jotun\logical\Flag;
use \jotun\gaming\dataform\SparkCore;
use \jotun\Jotun;
use \jotun\utils\Dice;
use \jotun\gaming\dataform\Spark;

/**
 * ...
 * @author Rafael Moreira
 */
class PulsarOutput extends OutputCore {
	/**
	 * @return void
	 */
	public function __construct () {
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:21: characters 3-22
		parent::__construct(new Pulsar());
	}

	/**
	 * @param int $code
	 * @param bool $check
	 * 
	 * @return void
	 */
	public function error ($code, $check = false) {
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:61: characters 3-67
		if ($check === null) {
			$check = false;
		}
		$this->list("errors")->insert((new Spark("error"))->set("code", $code));
	}

	/**
	 * @return void
	 */
	public function flush () {
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:65: characters 3-53
		Pulsar::map("error", \Array_hx::wrap(["code"]), Boot::getClass(Spark::class), false, false);
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:66: characters 3-49
		Pulsar::map("time", \Array_hx::wrap(["*"]), Boot::getClass(Spark::class), false, false);
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:67: characters 3-51
		Pulsar::map("status", \Array_hx::wrap(["*"]), Boot::getClass(Spark::class), false, false);
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:68: characters 3-54
		$this->_data->insert((new Spark("status"))->set("*", $this->_status));
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:69: characters 3-64
		$this->_data->insert((new Spark("time"))->set("*", Omnitools::timeNow()));
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:70: characters 3-58
		Jotun::$header->setPulsar($this->_data, $this->_encode_out, $this->_chunk_size);
	}

	/**
	 * @param string $name
	 * 
	 * @return Spark
	 */
	public function list ($name) {
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:51: characters 3-29
		return $this->object($name)->get(0);
	}

	/**
	 * @param mixed $message
	 * @param string $list
	 * 
	 * @return void
	 */
	public function log ($message, $list = "trace") {
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:55: lines 55-57
		if ($list === null) {
			$list = "trace";
		}
		if ($this->_log) {
			#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:56: characters 4-67
			$this->list("_logs")->insert((new Spark("_logq"))->set("*", $message));
		}
	}

	/**
	 * @param string $name
	 * 
	 * @return SparkCore
	 */
	public function object ($name) {
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:44: lines 44-46
		if (!(Boot::typedCast(Boot::getClass(Pulsar::class), $this->_data))->exists($name)) {
			#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:45: characters 4-48
			(Boot::typedCast(Boot::getClass(Pulsar::class), $this->_data))->insert(new Spark($name));
		}
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:47: characters 3-41
		return (Boot::typedCast(Boot::getClass(Pulsar::class), $this->_data))->link($name);
	}

	/**
	 * @param int $value
	 * 
	 * @return void
	 */
	public function setOptions ($value) {
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:24: lines 24-41
		$_gthis = $this;
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:25: lines 25-36
		if (Flag::FTest($value, 2)) {
			#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:27: characters 4-63
			Pulsar::map("_logp", \Array_hx::wrap([
				"name",
				"value",
			]), Boot::getClass(Spark::class), false, false);
			#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:29: characters 4-55
			Pulsar::map("_logo", \Array_hx::wrap(["value"]), Boot::getClass(Spark::class), false, false);
			#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:30: lines 30-32
			Dice::All($this->get_input()->params, function ($p, $v) use (&$_gthis) {
				#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:31: characters 5-82
				$_gthis->list("_input")->insert((new Spark("_logp"))->set("name", $p)->set("value", $v));
			});
			#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:33: lines 33-35
			if ($this->get_input()->object !== null) {
				#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:34: characters 5-78
				$this->list("_input")->insert((new Spark("_logo"))->set("value", $this->get_input()->object));
			}
		}
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:37: characters 3-26
		parent::setOptions($value);
		#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:38: lines 38-40
		if ($this->_log) {
			#src+extras/gateway/jotun/gateway/domain/PulsarOutput.hx:39: characters 4-51
			Pulsar::map("_logq", \Array_hx::wrap(["*"]), Boot::getClass(Spark::class), false, false);
		}
	}
}

Boot::registerClass(PulsarOutput::class, 'jotun.gateway.domain.PulsarOutput');