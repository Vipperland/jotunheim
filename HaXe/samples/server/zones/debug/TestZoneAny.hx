package zones.debug;
import jotun.gateway.domain.zones.DomainZoneCore;
import jotun.gateway.domain.zones.NotFoundZone;

/**
 * ...
 * @author Rafael Moreira
 */
class TestZoneAny extends DomainZoneCore {
	
	override function _buildZoneMap():Void {
		_setZoneMap({
			// Any value will be carried to NotFoundZone
			"end" : TestZoneEnd,
			"*" : NotFoundZone,
		});
	}
	
	// Create value from current service value
	override function _buildup(data:Array<String>):Void {
		_value = data;
	}
	
	public function new() {
		super();
	}
	
}