package jotun.gateway.database.objects;
import jotun.utils.Omnitools;

/**
 * SQL

	 CREATE TABLE `rp_user_pwd` (
		 `_uid` varchar(65) COLLATE utf8mb4_general_ci NOT NULL,
		 `_hash` varchar(65) COLLATE utf8mb4_general_ci NOT NULL,
		 `_upd` int NOT NULL,
	 PRIMARY KEY (`_uid`),
	 UNIQUE KEY `_uid` (`_uid`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci
 
 * @author Rafael Moreira
 */
class UserPwdObject extends ZoneCoreObject {
	
	/* 
		Fields defined in the database table
		The column names pefixed with _ will not be exposed to reponses
	*/
	
	public var _uid:String;
	
	public var _hash:String;
	
	public var _upd:Float;
	
	public function new() {
		super();
	}
	
	public function match(pwd:String):Bool {
		return Omnitools.verifyPwdHash(pwd, _hash);
	}
	
}