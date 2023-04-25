package zones.debug;
import jotun.gateway.domain.zones.DomainZoneCore;
import zones.debug.TestZoneAny;

/**
 * ...
 * @author Rafael Moreira
 */
class TestZone extends DomainZoneCore {
	
	override function _buildZoneMap():Void {
		_setZoneMap({
			// Any value will be carried to TestZoneEnd
			"*" : TestZoneAny,
		});
	}
	
	override function _execute(data:Array<String>):Void {
	}
	
	public function new() {
		super();
	}
	
}