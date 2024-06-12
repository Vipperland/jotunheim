package jotun.gateway.domain.zones.session;
import jotun.gateway.domain.zones.session.services.SessionCreateZone;
import jotun.gateway.domain.zones.session.services.SessionExposeZone;
import jotun.gateway.domain.zones.session.services.SessionVerifyZone;

/**
 * ...
 * @author 
 */
class SessionZone extends DomainZoneCore {
	
	override function _buildZoneMap():Void {
		_setZoneMap({
			"verify" : SessionVerifyZone,
			"create" : SessionCreateZone,
		});
		super._buildZoneMap();
	}
	
	public function new() {
		super();
	}
	
	override function _execute(data:Array<String>):Void {
		super._setStatusUnauthorized();
	}
	
}