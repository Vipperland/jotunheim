package jotun.gateway.domain.zones.session.services;
import jotun.gateway.database.SessionDataAccess;
import jotun.gateway.database.objects.UserPwdObject;
import jotun.gateway.database.objects.defs.SessionParams;
import jotun.php.db.Clause;
import jotun.php.db.objects.IQuery;
import server.crimson.society.database.objects.CrimsonUserObject;
import server.crimson.society.database.objects.CrinsomUserFlags;

/**
 * ...
 * @author Rafael Moreira
 */
class SessionCreateZone extends DomainZoneCore {

	public function new() {
		super();
		setEndZone();
		setDatabaseRequired();
		restrictToPut();
	}
	
	override function _execute(data:Array<String>):Void {
		
		var params:SessionParams = input.construct(SessionParams);
		
		if (!params.validate()){
			if (output.isLogEnabled()){
				_logService("Missing session parameters " + params.toString());
			}
			return;
		}
		
		var user:CrimsonUserObject = RunSQL(cast (database, SessionDataAccess).user.restrict(['id', 'username','_flags', '_ctd', '_upd']).findOne(Clause.AND([
			Clause.EQUAL('email', params.email),
			Clause.FLAG('flags', CrinsomUserFlags.ACTIVE),
		])));
		
		if(user == null){
			if (output.isLogEnabled()){
				_logService("User not found");
			}
			return;
		}
		
		user._email = params.email;
		var pwd_match:UserPwdObject = RunSQL(cast (database, SessionDataAccess).user_pwd.findOne(Clause.AND([
			Clause.EQUAL('_uid', user.id),
		])));
		
		if(pwd_match == null){
			if (output.isLogEnabled()){
				_logService("User password configuration is missing");
			}
			return;
		}
		
		if (!pwd_match.match(params.pwd)){
			if (output.isLogEnabled()){
				_logService("Invalid password");
			}
			return;
		}
		
		if (!user.createNewSession()){
			if (output.isLogEnabled()){
				_logService("Can't create user session");
			}
			return;
		}
		
		// SUCCESS!
		// Create Session!
		
	}
	
}