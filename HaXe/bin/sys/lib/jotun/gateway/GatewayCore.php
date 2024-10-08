<?php
/**
 * Generated by Haxe 4.3.4
 */

namespace jotun\gateway;

use \jotun\gateway\domain\OutputCore;
use \php\Boot;
use \jotun\logical\Flag;
use \jotun\Jotun;
use \jotun\gateway\domain\zones\DomainZoneCore;
use \jotun\gateway\database\DataAccess;
use \jotun\gateway\domain\InputCore;

/**
 * ...
 * @author Rafael Moreira
 */
class GatewayCore {
	/**
	 * @var GatewayCore
	 */
	static public $_instance;

	/**
	 * @var DataAccess
	 */
	public $_database;
	/**
	 * @var DomainZoneCore
	 */
	public $_domain;
	/**
	 * @var InputCore
	 */
	public $_input;
	/**
	 * @var OutputCore
	 */
	public $_output;

	/**
	 * @return GatewayCore
	 */
	public static function getInstance () {
		#src+extras/gateway/jotun/gateway/GatewayCore.hx:20: characters 3-19
		return GatewayCore::$_instance;
	}

	/**
	 * Classes will be available in this order: Gateway > Output > DataAccess > Input > Domain.
	 * @param	TGateway
	 * @param	TOutput
	 * @param	TDataAccess
	 * @param	TInput
	 * @param	TDomain
	 * @param	maintenance
	 * @param	onInit
	 * 
	 * @param mixed $TGateway
	 * @param mixed $TOutput
	 * @param mixed $TDataAccess
	 * @param mixed $TInput
	 * @param mixed $TDomain
	 * @param int $options
	 * 
	 * @return void
	 */
	public static function init ($TGateway, $TOutput, $TDataAccess, $TInput, $TDomain, $options) {
		#src+extras/gateway/jotun/gateway/GatewayCore.hx:35: characters 3-56
		$gateway = new $TGateway->phpClassName();
		#src+extras/gateway/jotun/gateway/GatewayCore.hx:37: characters 3-24
		Jotun::$header->access();
		#src+extras/gateway/jotun/gateway/GatewayCore.hx:40: characters 3-46
		$gateway->_output = new $TOutput->phpClassName();
		#src+extras/gateway/jotun/gateway/GatewayCore.hx:43: lines 43-56
		if (!Flag::FTest($options, 16)) {
			#src+extras/gateway/jotun/gateway/GatewayCore.hx:46: characters 4-45
			$gateway->_input = new $TInput->phpClassName();
			#src+extras/gateway/jotun/gateway/GatewayCore.hx:47: characters 4-39
			$gateway->_output->setOptions($options);
			#src+extras/gateway/jotun/gateway/GatewayCore.hx:48: characters 4-53
			$gateway->_database = new $TDataAccess->phpClassName();
			#src+extras/gateway/jotun/gateway/GatewayCore.hx:49: characters 4-41
			$gateway->_database->setOptions($options);
			#src+extras/gateway/jotun/gateway/GatewayCore.hx:50: characters 4-47
			$gateway->_domain = new $TDomain->phpClassName();
		} else {
			#src+extras/gateway/jotun/gateway/GatewayCore.hx:54: characters 4-54
			$gateway->_output->error(1);
		}
		#src+extras/gateway/jotun/gateway/GatewayCore.hx:58: lines 58-60
		if (Flag::FTest($options, 32)) {
			#src+extras/gateway/jotun/gateway/GatewayCore.hx:59: characters 4-34
			$gateway->_output->mode(true, 64);
		}
		#src+extras/gateway/jotun/gateway/GatewayCore.hx:63: characters 3-18
		$gateway->flush();
	}

	/**
	 * @return void
	 */
	public function __construct () {
		#src+extras/gateway/jotun/gateway/GatewayCore.hx:73: lines 73-77
		if (GatewayCore::$_instance === null) {
			#src+extras/gateway/jotun/gateway/GatewayCore.hx:74: characters 4-20
			GatewayCore::$_instance = $this;
		} else {
			#src+extras/gateway/jotun/gateway/GatewayCore.hx:76: characters 4-9
			throw new \ErrorException("Gateway is a Singleton");
		}
	}

	/**
	 * @return void
	 */
	public function flush () {
		#src+extras/gateway/jotun/gateway/GatewayCore.hx:81: characters 3-18
		$this->_output->flush();
	}
}

Boot::registerClass(GatewayCore::class, 'jotun.gateway.GatewayCore');
