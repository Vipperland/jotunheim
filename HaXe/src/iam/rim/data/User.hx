package iam.rim.data;
import haxe.crypto.Md5;
import iam.rim.db.Collection;
import sirius.db.Clause;
import sirius.db.Limit;
import sirius.db.objects.IQueryResult;
import sirius.errors.Error;
import sirius.Sirius;
import sirius.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class User {
	
	public var data:Dynamic;
	
	public var id(get, null):UInt;
	private function get_id():UInt { return data.id; }
	
	public var name(get, null):String;
	private function get_name():String { return data.name; }
	
	public var email(get,null):String;
	private function get_email():String { return data.email; }
	
	public var active(get,null):Bool;
	private function get_active():Bool { return data.active; }
	
	public var blocked(get,null):Bool;
	private function get_blocked():Bool { return data.blocked; }
	
	public var createdAt(get,null):Float;
	private function get_createdAt():Float { return data.created_at; }
	
	public var activity(get,null):UInt;
	private function get_activity():UInt { return data.activity; }
	
	public var token:String;
	
	public function new(data:Dynamic) {
		this.data = data;
		token = Sirius.domain.params.token;
	}
	
	public function createSession():User {
		// if new login and no token
		if (token == null && email != null) {
			var ip:String = Sirius.domain.data.REMOTE_ADDR;
			token = Md5.encode(email + ":" + ip);
			var delClause:Dynamic = Clause.AND([
				Clause.EQUAL('ip', ip),
				Clause.EQUAL('user_id', id),
			]);
			Collection.sessions.delete(delClause);
			Collection.sessions.create( { user_id:id, token:token, ip:ip } );
			return this;
		}else {
			return null;
		}
	}
	
	public function checkSession(update:Bool):Bool {
		var current:Dynamic = null;
		if (hasToken()) {
			var time:Date = Date.now();
			var now:String = time.toString();
			var upClause:Dynamic = Clause.AND([
				Clause.EQUAL('ip', Sirius.domain.data.REMOTE_ADDR),
				Clause.EQUAL('token', token),
			]);
			current = Collection.sessions.findOne(upClause);
			if (current != null) {
				var lastUp:Float = Date.fromString(current.updated_at).getTime();
				var age:Float = lastUp - time.getTime();
				// If session expired, delete
				if (age > 1296000) {
					Collection.sessions.delete(upClause);
					Output.result.session = { updated: now, expired: true, valid:false };
				}
				// If session has a valid age
				else {
					id = current.user_id;
					// Update session if requested
					if(update) Collection.sessions.update( { updated_at:now }, upClause, null, Limit.MAX(1) );
					Output.result.session = { updated: now, expired: false, valid:true };
				}
			}else {
				Output.result.session = null;
			}
		}
		return current != null;
	}
	
	public function hasToken():Bool {
		return token != null;
	}
	
	public function dropSession(all:Bool) {
		Collection.sessions.delete(all ? Clause.EQUAL("user_id", id) : Clause.EQUAL("token", token), null, all ? null : Limit.MAX(1));
		Output.result.session = null;
	}
	
}