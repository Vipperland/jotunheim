package jotun.gateway.database;
import jotun.gateway.database.DataAccess;
import jotun.gateway.database.objects.ZoneCoreSession;
import jotun.php.db.Token;
import jotun.php.db.objects.IDataTable;

/**
 * ...
 * @author Rafael Moreira
 */
class SessionDataAccess extends DataAccess {

	public function new(token:Token) {
		super(token);
	}
	
	public var user_session(get, null):IDataTable;
	private function get_user_session():IDataTable {
		return _tryAssemble('rp_data_session', ZoneCoreSession);
	}
	
	
}