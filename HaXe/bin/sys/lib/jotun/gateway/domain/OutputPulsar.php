<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace jotun\gateway\domain;

use \jotun\gaming\dataform\Pulsar;
use \jotun\gateway\utils\Omnitools;
use \php\Boot;
use \jotun\gaming\dataform\SparkCore;
use \jotun\Jotun;
use \jotun\gaming\dataform\Spark;

/**
 * ...
 * @author Rafael Moreira
 */
class OutputPulsar extends Output {
	/**
	 * @return void
	 */
	public function __construct () {
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:19: characters 3-22
		parent::__construct(new Pulsar());
	}

	/**
	 * @param int $code
	 * @param bool $check
	 * 
	 * @return void
	 */
	public function error ($code, $check = false) {
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:40: characters 3-60
		if ($check === null) {
			$check = false;
		}
		$this->list("errors")->insert((new Spark("q"))->set("r", $code));
	}

	/**
	 * @return void
	 */
	public function flush () {
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:44: characters 3-46
		Pulsar::map("q", \Array_hx::wrap(["r"]), Boot::getClass(Spark::class), false, false);
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:45: characters 3-53
		Pulsar::map("time", \Array_hx::wrap(["value"]), Boot::getClass(Spark::class), false, false);
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:47: lines 47-50
		if ($this->_log) {
			#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:48: characters 4-56
			Pulsar::map("_input", \Array_hx::wrap([
				"s",
				"o",
			]), Boot::getClass(Spark::class), false, false);
			#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:49: characters 4-111
			$this->_data->insert((new Spark("_input"))->set("s", Input::getInstance()->params)->set("o", Input::getInstance()->object));
		}
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:51: characters 3-68
		$this->_data->insert((new Spark("time"))->set("value", Omnitools::timeNow()));
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:52: characters 3-39
		Jotun::$header->setPulsar($this->_data, false);
	}

	/**
	 * @param string $name
	 * 
	 * @return Spark
	 */
	public function list ($name) {
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:30: characters 3-29
		return $this->object($name)->get(0);
	}

	/**
	 * @param mixed $message
	 * @param string $list
	 * 
	 * @return void
	 */
	public function log ($message, $list = "trace") {
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:34: lines 34-36
		if ($list === null) {
			$list = "trace";
		}
		if ($this->_log) {
			#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:35: characters 4-63
			$this->list("_logs")->insert((new Spark("q"))->set("r", $message));
		}
	}

	/**
	 * @param string $name
	 * 
	 * @return SparkCore
	 */
	public function object ($name) {
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:23: lines 23-25
		if (!(Boot::typedCast(Boot::getClass(Pulsar::class), $this->_data))->exists($name)) {
			#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:24: characters 4-48
			(Boot::typedCast(Boot::getClass(Pulsar::class), $this->_data))->insert(new Spark($name));
		}
		#src+extras/gateway/jotun/gateway/domain/OutputPulsar.hx:26: characters 3-41
		return (Boot::typedCast(Boot::getClass(Pulsar::class), $this->_data))->link($name);
	}
}

Boot::registerClass(OutputPulsar::class, 'jotun.gateway.domain.OutputPulsar');