package jotun.gateway.domain.zones.session.services;
import jotun.gateway.domain.BasicSessionInput;
import jotun.gateway.domain.zones.session.services.SessionExposeZone;
import jotun.gateway.domain.zones.session.services.SessionRefreshZone;
import jotun.gateway.errors.ErrorCodes;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class SessionDropZone extends DomainZoneCore {
	
	public function new() {
		super();
		setEndZone();
	}
	
	override function _execute(data:Array<String>):Void {
		cast (input, BasicSessionInput).session.drop(data[0] == 'all');
	}
	
}