package ;
import jotun.gateway.domain.CustomSessionDomain;
import jotun.gateway.domain.DomainAccessCore;
import zones.debug.TestZone;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomDomain extends CustomSessionDomain {

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