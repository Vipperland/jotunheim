package jotun.gateway.domain.zones.session.services;
import haxe.Rest;
import jotun.gateway.domain.BasicSessionInput;
import jotun.gateway.domain.zones.session.services.SessionExposeZone;
import jotun.gateway.domain.zones.session.services.SessionRefreshZone;
import jotun.gateway.errors.ErrorCodes;
import jotun.utils.Dice;

/**
 * ...
 * @author 
 */
class SessionVerifyZone extends DomainZoneCore {
	
	override function _buildZoneMap():Void {
		_setZoneMap({
			"refresh" : SessionRefreshZone,
			"expose" : SessionExposeZone,
			"drop" : SessionExposeZone,
		});
		super._buildZoneMap();
	}
	
	public function new() {
		super();
		setDatabaseRequired();
	}
	
	private function _verifySession():Bool {
		if(_matchDabaseRequirement()){
			if (cast (input, BasicSessionInput).session != null){
				return true;
			}
			error(cast (input, BasicSessionInput).getTokenSatus());
		}
		return false;
	}
	
	override function _prepare(data:Array<String>):Bool {
		return _verifySession();
	}
	
	override function _execute(data:Array<String>):Void {
		_verifySession();
	}
	
}