package jotun.gateway.domain;
import jotun.Jotun;
import jotun.serial.Packager;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.gateway.database.objects.ZoneCoreSession;
import jotun.gateway.domain.Output;
import jotun.gateway.domain.zones.pass.ZonePass;

/**
 * ...
 * @author 
 */
class Input {
	
	static public var ME(get, null):Input;
	static private function get_ME():Input {
		if (ME == null){
			ME = new Input();
		}
		return ME;
	}
	
	private var _testToken:String;
	
	public var params:Dynamic;
	
	public var object:Dynamic;
	
	public var session:ZoneCoreSession;
	
	public function new() {
		params = Jotun.domain.params;
		object = Jotun.domain.input;
		_loadAuthToken();
	}
	
	final private function _loadAuthToken():Void {
		var authorization:String = Jotun.header.getOAuth();
		if (_testToken != null && !Utils.isValid(authorization)){
			authorization = _testToken;
		}
		if (authorization != null){
			authorization = Packager.decodeBase64(authorization);
			if (authorization.substr(0, ZoneCoreSession.OAUTH_HEAD_IN.length) == ZoneCoreSession.OAUTH_HEAD_IN){
				authorization = authorization.substring(ZoneCoreSession.OAUTH_HEAD_IN.length, authorization.length);
				session = new ZoneCoreSession();
				if (session.loadFromToken(authorization)){
					session.exposeToken();
				}else{
					authorization = null;
					session.revoke();
					session = null;
				}
			}
		}
	}
	
	final public function hasAnyParam():Bool {
		return Dice.Params(params, function(p:String){
			return true;
		}).param != null;
	}
	
	final public function setTestToken(token:String):Void {
		_testToken = token;
		if (_testToken != null){
			_loadAuthToken();
		}
	}
	
	final public function isAuthenticated():Bool {
		return session != null;
	}
	
	final public function hasAuthentication(pass:ZonePass):Bool {
		return isAuthenticated() && pass.validate(session.carrier);
	}
	
}