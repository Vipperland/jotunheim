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
	
	public var sessions(get, null):IDataTable;
	private function get_sessions():IDataTable {
		return _tryAssemble('sessions', ZoneCoreSession);
	}
	
}