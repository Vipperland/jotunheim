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
		super(Token.localhost("pipastudios_admin"));
	}
	
	override function get_user_session():IDataTable {
		if (this.user_session == null){
			this.user_session = _tryAssemble("pa_user_session", ZoneCoreSession);
		}
		return this.user_session;
	}
	
}