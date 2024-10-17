package jotun.gateway.domain;
import jotun.Jotun;
import jotun.gateway.domain.zones.DomainZoneCore;
import jotun.utils.Dice;
import php.ErrorException;

/**
 * ...
 * @author 
 */
class DomainAccessCore extends DomainZoneCore {

	static public var _me:DomainAccessCore;
	
	static public function getInstance():DomainAccessCore {
		return _me;
	}
	
	/**
	 * Will carry zone parameters based on service pieces. Ex.:
	 * 	/api/user => UserZone
	 * 		/api/user/login => UserLoginZone
	 * 		/api/user/register => UserRegisterZone
	 * 		/api/user/test => UserRegisterTestZone
	 * 	/api/session => session
	 * 
	 *  Note:
	 * 	Zones can required a read or write access pass see UserRegisterZone constructor
	 * 
	 */
	
	private var _activated:Bool;
	
	private function _preInit():Void { }
	
	public function new() {
		if (_me != null){
			throw new ErrorException("Domain is a Singleton");
		}
		_me = this;
		_preInit();
		super();
		carry(this, _getServices());
	}
	
	private function _getServices():Array<String> {
		var services:Array<String> = cast Dice.nullSkip(Jotun.params.array('service', '/'));
		Jotun.params.remove("service");
		return services;
	}
	
}