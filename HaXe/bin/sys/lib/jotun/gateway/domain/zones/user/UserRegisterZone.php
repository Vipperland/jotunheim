<?php
/**
 * Generated by Haxe 4.3.0
 */

namespace jotun\gateway\domain\zones\user;

use \jotun\gateway\domain\zones\ZonePass;
use \jotun\gateway\domain\zones\ZoneServices;
use \php\_Boot\HxAnon;
use \jotun\gateway\database\objects\PA_UserSession;
use \php\Boot;
use \jotun\gateway\database\objects\PA_User;

/**
 * ...
 * @author
 */
class UserRegisterZone extends ZoneServices {
	/**
	 * @return void
	 */
	public function __construct () {
		#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:22: characters 3-56
		parent::__construct(new ZonePass(0, 1));
	}

	/**
	 * @param string[]|\Array_hx $data
	 * 
	 * @return void
	 */
	public function _execute ($data) {
		#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:27: characters 3-36
		$user = new PA_User();
		#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:28: characters 3-23
		$user->loadFromInput();
		#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:29: lines 29-39
		if ($user->save()) {
			#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:30: lines 30-32
			if ($this->get_input()->session !== null) {
				#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:31: characters 5-25
				$this->get_input()->session->drop();
			}
			#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:33: characters 4-54
			$session = new PA_UserSession();
			#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:34: lines 34-38
			if ($session->save($user->id, Boot::dynamicField($this->get_input()->object, 'device'))) {
				#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:35: characters 5-26
				$session->setUser($user);
				#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:36: characters 5-26
				$session->exposeToken();
				#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:37: characters 5-29
				$session->exposeUserInfo();
			}
		}
	}

	/**
	 * @return mixed
	 */
	public function getZoneMap () {
		#server/jotun/gateway/domain/zones/user/UserRegisterZone.hx:16: lines 16-18
		return new HxAnon(["test" => Boot::getClass(UserRegisterTestZone::class)]);
	}
}

Boot::registerClass(UserRegisterZone::class, 'jotun.gateway.domain.zones.user.UserRegisterZone');