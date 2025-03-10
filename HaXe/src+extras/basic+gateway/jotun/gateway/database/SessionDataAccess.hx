package jotun.gateway.database;
import jotun.gateway.database.DataAccess;
import jotun.gateway.database.objects.UserSessionObject;
import jotun.gateway.database.objects.UserObject;
import jotun.gateway.database.objects.UserPwdObject;
import jotun.php.db.Token;
import jotun.php.db.objects.DataTable;

/**
 * ...
 * @author Rafael Moreira
 */
class SessionDataAccess extends DataAccess {

	public function new(token:Token) {
		super(token);
	}
	
	public var session(get, null):DataTable;
	private function get_session():DataTable {
		return _tryAssemble('user_session', UserSessionObject);
	}
	
	public var user(get, null):DataTable;
	private function get_user():DataTable {
		return _tryAssemble('user', UserObject);
	}
	
	public var user_pwd(get, null):DataTable;
	private function get_user_pwd():DataTable {
		return _tryAssemble('user_pwd', UserPwdObject);
	}
	
}