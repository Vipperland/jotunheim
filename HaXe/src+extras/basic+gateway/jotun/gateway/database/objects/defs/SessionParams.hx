package jotun.gateway.database.objects.defs;
import jotun.gateway.domain.InputCore;
import jotun.tools.Utils;
import jotun.utils.Omnitools;
import jotun.utils.Validator;

/**
 * ...
 * @author Rafael Moreira
 */
class SessionParams {

	public var email:String;
	
	public var pwd:String;
	
	public function new(data:InputCore) {
		email = data.object.string("email");
		pwd = data.object.exists("pwd") ? Omnitools.generatePwdHash(data.object.string("pwd")) : null;
	}
	
	public function validate():Bool {
		return Validator.email(email) && Utils.isValid(pwd);
	}
	
	public function toString():String {
		var pwderr:String = 
		return 'SessionParams[{email=$email,pwd=' + (pwd != null ? "<valid>" : "<invalid>") + '}]';
	}
	
}