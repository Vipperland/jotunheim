package jotun.gateway.domain;
import jotun.errors.SessionErrorCodes;
import jotun.gateway.database.objects.ZoneCoreSession;
import jotun.gateway.domain.InputCore;
import jotun.serial.Packager;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class BasicSessionInput extends InputCore {

	private var _tokenStatus:Int;
	
	public var session:ZoneCoreSession;
	
	public function getTokenSatus():Int {
		return _tokenStatus;
	}
	
	public function new() {
		super();
		_loadAuthToken();
	}
	
	public function setTestToken(token:String):Void {
		_testToken = token;
		if (_testToken != null){
			_loadAuthToken();
		}
	}
	
	private function _disposeSession(status:Int):Void {
		_tokenStatus = status;
		if (session != null){
			session.revoke();
			session = null;
		}
	}
	
	private function _loadAuthToken():Void {
		var authorization:String = Jotun.header.getOAuth();
		if (_testToken != null && !Utils.isValid(authorization)){
			authorization = _testToken;
		}
		if (Utils.isValid(authorization)){
			authorization = Packager.decodeBase64(authorization);
			if (authorization.substr(0, ZoneCoreSession.OAUTH_HEAD_IN.length) == ZoneCoreSession.OAUTH_HEAD_IN){
				authorization = authorization.substring(ZoneCoreSession.OAUTH_HEAD_IN.length, authorization.length);
				session = new ZoneCoreSession();
				if (session.load(authorization)){
					if (session.isValid()){
						session.exposeToken();
						
					}else{
						_disposeSession(SessionErrorCodes.TOKEN_EXPIRED);
					}
				}else{
					_disposeSession(SessionErrorCodes.NO_SESSION);
				}
			}else{
				_disposeSession(SessionErrorCodes.INVALID_TOKEN);
			}
		}else{
			_disposeSession(SessionErrorCodes.TOKEN_REQUIRED);
		}
	}
	
}