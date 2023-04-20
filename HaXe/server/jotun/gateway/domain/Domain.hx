package jotun.gateway.domain;
import jotun.Jotun;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.gateway.domain.zones.ForbiddenZone;
import jotun.gateway.domain.zones.NotFoundZone;
import jotun.gateway.domain.zones.session.SessionZone;
import jotun.gateway.domain.zones.ZoneServices;
import jotun.gateway.errors.ErrorCodes;
import php.ErrorException;

/**
 * ...
 * @author 
 */
class Domain extends ZoneServices {

	static public var _me:Domain;
	
	static public function getInstance():Domain {
		return _me;
	}
	
	override function _buildZoneMap():Void {
		_setZoneMap({
			"session" : SessionZone,
		});
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
	
	public function new() {
		if (_me != null){
			throw new ErrorException("Domain is a Singleton");
		}
		_me = this;
		super();
		carry(this, getServices());
		Reflect.deleteField(Jotun.domain.params, "service");
	}
	
	private function getServices():Array<String>{
		var service:String = Utils.getValidOne(Jotun.domain.params.service, "");
		return cast Dice.nullSkip(service.split('/'));
	}
	
}