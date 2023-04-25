package jotun.gateway.domain.zones;
import jotun.gateway.errors.ErrorCodes;

/**
 * ...
 * @author Rafael Moreira
 */
class NotFoundZone extends DomainZoneCore {
	
	override function _execute(data:Array<String>):Void {
		error(ErrorCodes.SERVICE_NOT_FOUND);
	}
	
	public function new() {
		super();
	}
	
}