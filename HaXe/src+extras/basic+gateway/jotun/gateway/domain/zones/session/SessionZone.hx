package jotun.gateway.domain.zones.session;
import jotun.gateway.domain.zones.session.SessionVerifyZone;

/**
 * ...
 * @author 
 */
class SessionZone extends DomainZoneCore {
	
	override function _buildZoneMap():Void {
		_setZoneMap({
			"verify" : SessionVerifyZone,
		});
	}
	
	public function new() {
		super();
	}
	
}