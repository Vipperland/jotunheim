package ;
import jotun.gateway.domain.Domain;
import zones.debug.TestZone;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomDomain extends Domain {

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