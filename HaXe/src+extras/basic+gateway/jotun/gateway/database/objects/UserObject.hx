package jotun.gateway.database.objects;
import jotun.gateway.domain.zones.pass.IPassCarrier;

/**
 * CREATE TABLE `<DATABASE_NAME>`.`user` (`id` VARCHAR(65) NOT NULL , `_email` VARCHAR(255) NOT NULL , `_flags` INT NOT NULL , `_ctd` INT NOT NULL , `_upd` INT NOT NULL ) ENGINE = MyISAM;
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
	
	
}