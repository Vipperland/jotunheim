package iam.rim.services;
import haxe.crypto.Md5;
import haxe.Json;
import iam.rim.data.Input;
import iam.rim.data.Output;
import iam.rim.data.User;
import iam.rim.db.Collection;
import php.Lib;
import sirius.db.Clause;
import sirius.db.Limit;
import sirius.errors.Error;
import sirius.Sirius;
import sirius.tools.Utils;

/**
 * ...
 * @author Rafael Moreira
 */
class Users{
	
	static private var ME:Array<String> = ["id", "name", "email", "created_at", "active", "blocked", "activity"];
	static private var OTHER:Array<String> = ["id", "name", "created_at", "blocked", "activity"];
	
	static public function init():Void {
		
		switch(Input.services.get(1)) {
			case "login" : {			doLogin();  }
			case "logout" : {			doLogout();  }
			case "profile" : {			getProfile(); }
			default : {					renewSection(); }
		}
	}
	
	static public function getProfile() {
		var id:Int = Std.parseInt(Input.services.get(2));
		if (id != null) {
			Collection.users.restrict(OTHER);
			var clause:Clause = Clause.AND([
				Clause.EQUAL('id', id), 
				Clause.EQUAL('active', true)
			]);
			var entry:Dynamic = Collection.users.findOne(clause);
			if (entry) {
				Output.result.profile = new User(entry).data;
			}
		}else {
			Output.result.user = null;
		}
	}
	
	static public function doLogout() {
		var user:User = new User(null);
		if (user.checkSession(false)) {
			var all:Bool = Input.services.get(2) == "all";
			user.dropSession(all);
		}
	}
	
	static public function doLogin() {
		var email:String = Sirius.domain.params.email;
		var password:String = Sirius.domain.params.password;
		if (email == null || password == null) {
			if(email == null) Output.errors.push(new Error(1001, "Form.Missing:EMAIL"));
			if(password == null) Output.errors.push(new Error(1002, "Form.Missing:PASSWORD"));
		}else {
			Collection.users.restrict(ME);
			var clause:Clause = Clause.AND([
				Clause.EQUAL("email", email),
				Clause.EQUAL("password", Md5.encode(password)),
			]);
			var entry:Dynamic = Collection.users.findOne(clause);
			if (entry != null) {
				var user:User = new User(entry);
				if(!user.active || user.blocked){
					if(!user.active) Output.errors.push(new Error(1003, "User.Activation:PENDING"));
					if (user.blocked) Output.errors.push(new Error(1004, "User.Activation:BANNED"));
				}else {
					Output.result.user = user.createSession().data;
				}
			}
		}
	}
	
	static public function renewSection():Void {
		new User(null).checkSession(true);
	}
	
}