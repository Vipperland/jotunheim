package jotun.gateway.domain.zones;
import jotun.gateway.domain.zones.DomainZoneCore;
import haxe.DynamicAccess;
import jotun.gateway.domain.zones.NotFoundZone;
import jotun.gateway.domain.zones.pass.ZonePass;
import jotun.gateway.errors.ErrorCodes;

/**
 * ...
 * @author Rafael Moreira
 */
class DomainCarryEndZone extends DomainZoneCore {
	
	public function new(?pass:ZonePass) {
		super(pass);
		setEndZone();
	}
	
}