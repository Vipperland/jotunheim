package jotun.gateway.domain.zones.session;

/**
 * ...
 * @author 
 */
class SessionVerifyZone extends ZoneServices {
	
	override function _buildZoneMap():Void {
		_setZoneMap({
			"test" : SessionVerifyTestZone,
		});
	}
	
	public function new() {
		super();
	}
	
	override function _execute(data:Array<String>):Void {
		if (input.session != null){
			input.session.exposeUserInfo(true);
			input.session.refresh();
		}
	}
	
}