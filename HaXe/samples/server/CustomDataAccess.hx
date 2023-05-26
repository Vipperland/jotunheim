package ;
import jotun.gateway.database.DataAccess;
import jotun.gateway.database.SessionDataAccess;
import jotun.gateway.database.objects.ZoneCoreSession;
import jotun.php.db.Token;
import jotun.php.db.objects.IDataTable;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomDataAccess extends SessionDataAccess {

	public function new() {
		super(Token.localhost("realms_gateway"));
	}
	
	override function get_sessions():IDataTable {
		if (this.sessions == null){
			this.sessions = _tryAssemble("pa_user_session", ZoneCoreSession);
		}
		return this.sessions;
	}
	
}