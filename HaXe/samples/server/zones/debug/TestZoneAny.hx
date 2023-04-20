package zones.debug;
import jotun.gateway.domain.zones.ZoneServices;
import jotun.gateway.domain.zones.ForbiddenZone;
import jotun.gateway.domain.zones.NotFoundZone;

/**
 * ...
 * @author Rafael Moreira
 */
class TestZoneAny extends ZoneServices {
	
	override function _buildZoneMap():Void {
		_setZoneMap({
			// Any value will be carried to TestZoneEnd
			"end" : TestZoneEnd,
			"*" : NotFoundZone,
		});
	}
	
	// Create value from current service value
	override function _buildup(zoneName:String):Void {
		_value = zoneName;
	}
	
	public function new() {
		super();
	}
	
}