package jotun.gateway.domain.zones.session;
import jotun.gateway.database.objects.ZoneCoreSession;
import jotun.serial.Packager;

/**
 * ...
 * @author Rafael Moreira
 */
class SessionVerifyTestZone extends ZoneServices {

	override function _buildZoneMap():Void {
		setEndZone();
	}
	
	override function _execute(data:Array<String>):Void {
		var testToken:String = Packager.encodeBase64(ZoneCoreSession.OAUTH_HEAD_IN + data[0]);
		input.setTestToken(testToken);
	}
	
	public function new() {
		super();
	}
	
}