package jotun.gateway.domain;
import jotun.errors.SessionErrorCodes;
import jotun.gateway.database.objects.UserSessionObject;
import jotun.gateway.domain.InputCore;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.serial.Packager;
import jotun.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class BasicSessionInput extends InputCore {

	private var _tokenStatus:Int;
	
	public var session:UserSessionObject;
	
	public function getTokenSatus():Int {
		return _tokenStatus;
	}
	
	public function new() {
		super();
		_loadAuthToken();
	}
	
	private var _testToken:String;
	
	final public function setTestToken(token:String):Void {
		_testToken = token;
		if (_testToken != null){
			_loadAuthToken();
		}
	}
	
	final private function _disposeSession(status:Int):Void {
		_tokenStatus = status;
		if (session != null){
			session.revoke();
			session = null;
		}
	}
	
	final private function _loadAuthToken():Void {
		var authorization:String = Jotun.header.getOAuth();
		if (_testToken != null && !Utils.isValid(authorization)){
			authorization = _testToken;
		}
		if (Utils.isValid(authorization)){
			authorization = Packager.decodeBase64(authorization);
			if (authorization.substr(0, UserSessionObject.OAUTH_HEAD_IN.length) == UserSessionObject.OAUTH_HEAD_IN){
				authorization = authorization.substring(UserSessionObject.OAUTH_HEAD_IN.length, authorization.length);
				session = new UserSessionObject();
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
	
	override public function get_carrier():IPassCarrier {
		if(this.carrier == null){
			this.carrier = this.session != null ? this.session.carrier : null;
		}
		return this.carrier;
	}
	
}