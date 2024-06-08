package jotun.gateway.database.objects;

/**
 * CREATE TABLE `DATABASE_NAME`.`TABLE_NAME` (`_uid` VARCHAR(65) NOT NULL , `_key` VARCHAR(60) NOT NULL , `_pwd` VARCHAR(60) NOT NULL , `_upd` INT NOT NULL ) ENGINE = MyISAM;
 * @author Rafael Moreira
 */
class UserPwdObject extends ZoneCoreObject {
	
	/* 
		Fields defined in the database table
		The column names pefixed with _ will not be exposed to reponses
	*/
	
	public var _uid:String;
	
	public var _key:String;
	
	public var _upd:Float;
	
	public function new() {
		super();
	}
	
}