package ;
import jotun.gateway.domain.SessionDomainCore;
import jotun.gateway.domain.DomainAccessCore;
import zones.debug.TestZone;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomDomain extends SessionDomainCore {

	override function _buildZoneMap():Void {
		_setZoneMap({
			"test" : TestZone,
		});
		super._buildZoneMap();
	}
	
	public function new() {
		super();
	}
	
}