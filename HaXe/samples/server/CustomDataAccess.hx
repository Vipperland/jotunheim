package ;
import database.objects.CustomSessionObject;
import jotun.gateway.database.DataAccess;
import jotun.gateway.database.SessionDataAccess;
import jotun.gateway.database.objects.UserSessionObject;
import jotun.php.db.Token;
import jotun.php.db.objects.IDataTable;

/**
 * ...
 * @author Rafael Moreira
 */
class CustomDataAccess extends SessionDataAccess {

	public function new() {
		super(Token.localhost("rp_gateway_core"));
	}
	
	override function get_session():IDataTable {
		if (this.session == null){
			this.session = _tryAssemble("rp_user_session", CustomSessionObject);
		}
		return this.session;
	}
	
}