package jotun.gateway.domain;
import jotun.gateway.domain.DomainAccessCore;
import jotun.gateway.domain.zones.session.SessionZone;

/**
 * ...
 * @author Rafael Moreira
 */
class SessionDomainCore extends DomainAccessCore {

	override function _buildZoneMap():Void {
		_setZoneMap({
			"session" : SessionZone,
		});
		super._buildZoneMap();
	}
	
	public function new() {
		super();
		setDatabaseRequired(true);
	}
	
}