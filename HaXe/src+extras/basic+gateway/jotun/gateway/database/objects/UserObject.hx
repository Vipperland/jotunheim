package jotun.gateway.database.objects;
import jotun.Jotun;
import jotun.gateway.database.SessionDataAccess;
import jotun.gateway.database.objects.UserSessionObject;
import jotun.gateway.database.objects.defs.UserDeviceParams;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.gateway.domain.zones.pass.ZonePass;
import jotun.logical.Flag;
import jotun.utils.Omnitools;

/**
 * SQL
 * 
	CREATE TABLE `rp_user` (
		 `id` varchar(65) COLLATE utf8mb4_general_ci NOT NULL,
		 `_email` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
		 `username` varchar(32) COLLATE utf8mb4_general_ci NOT NULL,
		 `_flags` int NOT NULL,
		 `_ctd` int NOT NULL,
		 `_upd` int NOT NULL,
		 PRIMARY KEY (`id`),
		 UNIQUE KEY `id` (`id`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci

 * @author Rafael Moreira
 */
class UserObject extends ZoneCarrierObject {

	/**
	 * User unique id
	 */
	public var id:String;
	
	/**
	 * User email
	 */
	public var _email:String;
	
	/**
	 * User common flags
	 */
	public var _flags:Int;
	
	/**
	 * User created time
	 */
	public var _ctd:Float;
	
	/**
	 * User updated time
	 */
	public var _upd:Float;
	
	public function new() {
		super();
	}
	
	
	public function createNewSession():Bool {
		var token:String = Omnitools.genRandomIDx65();
		var pass:ZonePass = getZonePass();
		var session:UserSessionObject = new UserSessionObject();
		var device:String = cast (_input.construct(UserDeviceParams), UserDeviceParams).device;
		if (session.save(id, device, pass.getRead(), pass.getWrite())){
			session.exposeToken();
			session.exposeCarrier();
			return true;
		}
		return false;
	}
	
	public function getZonePass():ZonePass {
		return isAdmin() ? ZonePass.MASTER_PASS : ZonePass.BASIC_PASS;
	}
	
	public function isAdmin():Bool {
		return Flag.FTest(_flags, 1 >> 31);
	}
	
	
}