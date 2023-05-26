package jotun.gateway.database.objects;
import jotun.Jotun;
import jotun.errors.SessionErrorCodes;
import jotun.gateway.database.DataAccess;
import jotun.gateway.database.SessionDataAccess;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.logical.Flag;
import jotun.php.db.Clause;
import jotun.serial.Packager;
import jotun.tools.Utils;
import jotun.gateway.database.objects.ZoneCoreObject;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.errors.ErrorCodes;
import jotun.utils.Omnitools;

/**
 * ...
 * @author 
 */
class ZoneCoreSession extends ZoneCoreObject implements IPassCarrier {

	static public inline var OAUTH_HEAD_IN:String = "(y)=>";
	
	static public inline var OAUTH_HEAD_OUT:String = "(y)<=";
	
	public var _uid:String;
	
	public var _token:String;
	
	public var _ip:String;
	
	public var _device:String;
	
	public var _read:Int;
	
	public var _write:Int;
	
	public var _ctd:Float;
	
	public var _upd:Float;
	
	public var carrier(get, null):IPassCarrier;
	private  function get_carrier():IPassCarrier {
		return _loadCarrier();
	}
	
	private function _loadCarrier():IPassCarrier {
		// todo: load user
		return null;
	}
	
	public function new() {
		super();
	}
	
	public function save(id:String, device:String, read:Int, write:Int):Bool {
		if (_token == null && _uid == null){
			_uid = id;
			_token = Omnitools.genRandomIDx65();
			_ip = Jotun.domain.client;
			_device = Utils.getValidOne(device, "");
			_read = read;
			_write = write;
			_ctd = Omnitools.timeNow();
			_upd = _ctd;
			if (RunSQL(function(){
				return cast (_database, SessionDataAccess).sessions.add({
					_uid: id,
					_token: _token,
					_ip: _ip,
					_device: _device,
					_read: _read,
					_write: _write,
					_ctd: _ctd,
					_upd: _upd,
				});
			}).success){
				return true;
			}else{
				return _error(SessionErrorCodes.CREATION_ERROR);
			}
		}else{
			return _error(SessionErrorCodes.INVALID_PARAMETERS);
		}
	}
	
	public function load(oauth:String):Bool {
		var current:ZoneCoreSession = RunSQL(function(){
			return cast (_database, SessionDataAccess).sessions.findOne("*", Clause.EQUAL('_token', oauth));
		});
		if (current != null){
			_uid = current._uid;
			_token = current._token;
			_ip = current._ip;
			_device = current._device;
			_read = current._read;
			_write = current._write;
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
				cast (_database, SessionDataAccess).sessions.updateOne({_upd:_upd}, Clause.EQUAL("_token", _token));
			});
		}
	}
	
	public function drop():Void {
		RunSQL(function(){
			cast (_database, SessionDataAccess).sessions.deleteOne(Clause.EQUAL("_token", _token));
		});
	}
	
	public function dropAll():Void {
		if (isValid()){
			RunSQL(function(){
				cast (_database, SessionDataAccess).sessions.delete(Clause.EQUAL("_uid", _uid));
			});
		}
	}
	
	public function getToken():String {
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
		OutputCore.getInstance().registerOAuth(Packager.encodeBase64(token));
	}
	
	/**
	 * 
	 * @param	force
	 */
	public function exposeCarrier(?force:Bool):Void {
		if (carrier == null && force){
			_loadCarrier();
		}
		if (carrier != null){
			OutputCore.getInstance().object('carrier').info = carrier.getInfo();
		}
	}
	
	/**
	 * Remove auhtorization from header
	 */
	public function revoke():Void {
		OutputCore.getInstance().registerOAuth(Packager.encodeBase64(ZoneCoreSession.OAUTH_HEAD_OUT + 'REVOKE'));
	}
	
	
	/* INTERFACE jotun.gateway.domain.zones.pass.IPassCarrier */
	
	public function canRead(read:Int):Bool {
		return Flag.FTest(_read, read);
	}
	
	public function canWrite(write:Int):Bool {
		return Flag.FTest(_write, write);
	}
	
	public function getInfo():Dynamic {
		return null; // user object;
	}
	
}