package jotun.gateway.database.objects;
import jotun.Jotun;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.php.db.Clause;
import jotun.serial.Packager;
import jotun.tools.Utils;
import jotun.gateway.database.objects.ZoneCoreObject;
import jotun.gateway.domain.Output;
import jotun.gateway.errors.ErrorCodes;
import jotun.gateway.utils.Omnitools;

/**
 * ...
 * @author 
 */
class ZoneCoreSession extends ZoneCoreObject {

	static public inline var OAUTH_HEAD_IN:String = "(y)=>";
	
	static public inline var OAUTH_HEAD_OUT:String = "(y)<=";
	
	public var _uid:String;
	
	public var _token:String;
	
	public var _ip:String;
	
	public var _device:String;
	
	public var _ctd:Float;
	
	public var _upd:Float;
	
	public var carrier(get, null):IPassCarrier;
	private  function get_carrier():IPassCarrier {
		return _loadCarrier();
	}
	
	private function _loadCarrier():IPassCarrier {
		return null;
	}
	
	public function new() {
		super();
	}
	
	public function save(id:String, device:String):Bool {
		if (_token == null && _uid == null){
			_uid = id;
			_token = Omnitools.genRandomIDx65();
			_ip = Jotun.domain.client;
			_device = Utils.getValidOne(device, "");
			_ctd = Omnitools.timeNow();
			_upd = _ctd;
			if (RunSQL(function(){
				return _database.user_session.add({
					_uid: id,
					_token: _token,
					_ip: _ip,
					_device: _device,
					_ctd: _ctd,
					_upd: _upd,
				});
			}).success){
				return true;
			}else{
				return _error(ErrorCodes.SESSION_CREATION_ERROR);
			}
		}else{
			return _error(ErrorCodes.SESSION_INVALID_PARAMETERS);
		}
	}
	
	public function loadFromToken(oauth:String):Bool {
		var current:ZoneCoreSession = RunSQL(function(){
			return _database.user_session.findOne("*", Clause.EQUAL('_token', oauth));
		});
		if (current != null){
			_uid = current._uid;
			_token = current._token;
			_ip = current._ip;
			_device = current._device;
			_ctd = current._ctd;
			_upd = current._upd;
		}
		return current != null;
	}
	
	public function isValid():Bool {
		return (Omnitools.timeFromNow(24 * 7) - _upd) > 0;
	}
	
	public function refresh():Void {
		if (_uid != null && _token != null){
			_upd = Omnitools.timeNow();
			RunSQL(function(){
				_database.user_session.updateOne({_upd:_upd}, Clause.EQUAL("_token", _token));
			});
		}
	}
	
	public function drop():Void {
		RunSQL(function(){
			_database.user_session.deleteOne(Clause.EQUAL("_token", _token));
		});
	}
	
	public function dropAll():Void {
		if (isValid()){
			RunSQL(function(){
				_database.user_session.deleteOne(Clause.EQUAL("_uid", _uid));
			});
		}
	}
	
	public function getOAuthCode():String {
		return OAUTH_HEAD_OUT + _token;
	}
	
	public function exposeToken():Void {
		var token:String = ZoneCoreSession.OAUTH_HEAD_OUT;
		if(isValid()){
			token += _token;
		}else{
			token += "EXPIRED";
			drop();
		}
		Output.ME.registerOAuth(Packager.encodeBase64(token));
	}
	
	public function exposeUserInfo(?force:Bool):Void {
		if (carrier == null && force){
			_loadCarrier();
		}
		if (carrier != null){
			Output.ME.object('carrier').info = carrier.getInfo();
		}
	}
	
	public function revoke():Void {
		Output.ME.registerOAuth(Packager.encodeBase64(ZoneCoreSession.OAUTH_HEAD_OUT + 'REVOKE'));
	}
	
}