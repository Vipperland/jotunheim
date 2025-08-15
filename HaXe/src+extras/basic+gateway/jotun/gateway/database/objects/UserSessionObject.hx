package jotun.gateway.database.objects;
import jotun.Jotun;
import jotun.errors.SessionErrorCodes;
import jotun.gateway.database.SessionDataAccess;
import jotun.gateway.database.objects.UserObject;
import jotun.gateway.database.objects.ZoneCoreObject;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.logical.Flag;
import jotun.php.db.Clause;
import jotun.serial.Packager;
import jotun.tools.Utils;
import jotun.utils.Omnitools;

/**
 * SQL

	 CREATE TABLE `rp_user_session` (
		 `_uid` varchar(65) COLLATE utf8mb4_general_ci NOT NULL,
		 `_token` varchar(65) COLLATE utf8mb4_general_ci NOT NULL,
		 `_ip` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
		 `_device` varchar(128) COLLATE utf8mb4_general_ci NOT NULL,
		 `_read` int NOT NULL,
		 `_write` int NOT NULL,
		 `_ctd` int NOT NULL,
		 `_upd` int NOT NULL,
		 PRIMARY KEY (`_token`),
		 UNIQUE KEY `_token` (`_token`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
 
 * @author 
 */
class UserSessionObject extends ZoneCoreObject implements IPassCarrier {

	static public var OAUTH_HEAD_IN:String = "(y)=>";
	
	static public var OAUTH_HEAD_OUT:String = "(y)<=";
	
	/**
	 * User id
	 */
	public var _uid:String;
	
	/**
	 * Session token
	 */
	public var _token:String;
	
	/**
	 * IP address
	 */
	public var _ip:String;
	
	/**
	 * Device name
	 */
	public var _device:String;
	
	/**
	 * Read permission
	 */
	public var _read:Int;
	
	/**
	 * Write permission
	 */
	public var _write:Int;
	
	/**
	 * Session created time
	 */
	public var _ctd:Float;
	
	/**
	 * Session updated time
	 */
	public var _upd:Float;
	
	
	private var _carrier:IPassCarrier;
	public function getCarrier():IPassCarrier {
		if(isValid()){
			_carrier = cast (_database, SessionDataAccess).user.findOne(Clause.ID(_uid));
		}
		return _carrier;
	}
	
	private function _testSession():Bool {
		if (isValid()){
			return _error(SessionErrorCodes.NO_SESSION);
		}
		return true;
	}
	
	public function new() {
		super();
	}
	
	public function isExpired():Bool {
		return (Omnitools.timeFromNow(24 * 7) - _upd) < 0;
	}
	
	public function isValid():Bool {
		return _uid != null && _token != null;
	}
	
	public function save(id:String, device:String, read:Int, write:Int):Bool {
		if (!isValid()){
			return _error(SessionErrorCodes.TOKEN_ALREADY_EXISTS);
		}
		if(id == null){
			return _error(SessionErrorCodes.INVALID_PARAMETERS);
		}
		_uid = id;
		_token = Omnitools.genRandomIDx65();
		_ip = Jotun.domain.client;
		_device = Utils.getValidOne(device, "");
		_read = read;
		_write = write;
		_ctd = Omnitools.timeNow();
		_upd = _ctd;
		if (!RunSQL(function(){
			return cast (_database, SessionDataAccess).session.add(this);
		}).success){
			_uid = null;
			_token = null;
			return _error(SessionErrorCodes.CREATION_ERROR);
		}
		// session created
		return true;
	}
	
	public function load(oauth:String):Bool {
		if(!isValid()){
			return _error(SessionErrorCodes.TOKEN_ALREADY_EXISTS);
		}
		var current:UserSessionObject = RunSQL(function(){
			return cast (_database, SessionDataAccess).session.findOne("*", Clause.EQUAL('_token', oauth));
		});
		if (current != null){
			merge(current);
		}
		return current != null;
	}
	
	public function refresh():Void {
		if (_testSession()){
			_upd = Omnitools.timeNow();
			RunSQL(function(){
				cast (_database, SessionDataAccess).session.updateOne({_upd:_upd}, Clause.EQUAL("_token", _token));
			});
		}
	}
	
	public function drop():Void {
		if (_testSession()){
			RunSQL(function(){
				cast (_database, SessionDataAccess).session.deleteOne(Clause.EQUAL("_token", _token));
				revoke();
			});
		}
	}
	
	public function dropAll():Void {
		if (_testSession()){
			RunSQL(function(){
				cast (_database, SessionDataAccess).session.delete(Clause.EQUAL("_uid", _uid));
				revoke();
			});
		}
	}
	
	public function getToken():String {
		return OAUTH_HEAD_OUT + _token;
	}
	
	public function exposeToken():Void {
		if (_testSession()){
			var token:String = UserSessionObject.OAUTH_HEAD_OUT;
			if(isExpired()){
				token += "EXPIRED";
				drop();
			}else{
				token += _token;
			}
			_output.registerOAuth(Packager.encodeBase64(token));
		}
	}
	
	/**
	 * 
	 * @param	force
	 */
	public function exposeCarrier(?force:Bool):Void {
		if (_testSession()){
			if (getCarrier() != null){
				_output.object('carrier').info = _carrier.getInfo();
			}
		}
	}
	
	/**
	 * Remove auhtorization from header
	 */
	public function revoke():Void {
		if (_testSession()){
			_output.registerOAuth(Packager.encodeBase64(UserSessionObject.OAUTH_HEAD_OUT + 'REVOKE'));
		}
	}
	
	/* INTERFACE jotun.gateway.domain.zones.pass.IPassCarrier */
	
	public function canRead(read:Int):Bool {
		return Flag.FTest(_read, read);
	}
	
	public function canWrite(write:Int):Bool {
		return Flag.FTest(_write, write);
	}
	
	public function getInfo():Dynamic {
		// Print data
		return {
			_uid: _uid, 
			pass: {
				r:_read, 
				w: _write
			}
		};
	}
	
}