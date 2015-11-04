package sirius.php.ext;
import sirius.data.DataCache;
import sirius.data.IDataCache;
import sirius.php.net.Mailer;
import sirius.Sirius;
import sirius.tools.Key;
import sirius.utils.Dice;
import sirius.utils.Filler;

/**
 * ...
 * @author Rafael Moreira
 */
class SendMail {
	
	static private function _setError(e:Array<Dynamic>, error:String, message:String):Void {
		e[e.length] = { error:error, message:message };
	}
	
	static public function main() {
		
		var e:Array<Dynamic> = [];
		var z:Array<Dynamic> = null;
		var r:Dynamic = { errors: e };
		var d:IDataCache = new DataCache("mail", "conf", 0);
		var o:IDataCache = new DataCache();
		
		if (d.load(true)) {
			
			var commonLocale:Dynamic =  { 
				authentication:"No authentication data specified",
				sender:"No sender data specified",
				target:"No target data specified",
				subject:"No default subject found",
				missing:"Param {{name}} value is null",
			};
			
			var locale:Dynamic = d.get('locale');
			
			if (locale != null) {
				Dice.All(commonLocale, function(p:String, v:String) {
					if (!Reflect.hasField(locale, p)) Reflect.setField(locale, p, v);
				});
			}else {
				locale = commonLocale;
			}
			
			var require:Array<Dynamic> = d.get('require');
			if (require != null && require.length > 0) {
				Dice.Values(require, function(v:String) {
					if (!Sirius.domain.require([v])) _setError(e, "missing.param:" + v, Filler.to(locale.missing, {name:v}));
				});
			}
			
			var x:String = Sirius.domain.params.subject;
			if (x == null || x.length == 0) x = d.get('subject');
			if (x == null || x.length == 0) _setError(e, "missing.param:subject", locale.subject);
			
			if(e.length == 0){
				
				var o:Dynamic = d.get('auth');
				var s:Dynamic = d.get('sender');
				var to:Array<Dynamic> = d.get('to');
				var cc:Array<Dynamic> = d.get('cc');
				var bbc:Array<Dynamic> = d.get('bcc');
				
				var ms:String = d.get('message');
				
				if (o == null) _setError(e, "missing.auth", locale.authentication);
				if (s == null) _setError(e, "missing.sender", locale.sender);
				if (to == null || to.length == 0) _setError(e, "missing.to", locale.target);
				
				if (e.length == 0) {
					var mail:Mailer = new Mailer(o.host, o.user, o.password, o.secure, o.port);
					mail.origin(s.name, s.email);
					mail.targets(to, cc, bbc);
					
					var n:Dynamic = d.get("origin");
					var un:String = n.name != null ? Reflect.field(Sirius.domain.params, n.name) : null;
					var ue:String = n.email != null ? Reflect.field(Sirius.domain.params, n.email) : null;
					if (ue != null) {
						if (un != null) mail.output.addReplyTo(ue, un);
						else mail.output.addReplyTo(ue);
					}
					
					if (ms == null) {
						ms = "";
						Dice.All(Sirius.domain.params, function(p:String, v:Dynamic) { ms += "<b>" + p + "</b>: " + v;});
					}else {
						ms = Filler.to(ms, Sirius.domain.params);
					}
					
					mail.message(x, ms);
					r.success = mail.send();
					if (!r.success) _setError(e, "phpmailer.error", mail.getError());
					
					var log:Bool = d.get('log');
					if (log) {
						var u:IDataCache = new DataCache("" + Date.now().getTime(), "conf/mail_log", 0);
						u.set("recipients", Dice.Mix([to, cc, bbc]) );
						u.set("mail", { subject:x, message:ms } );
						u.set("result", r);
						u.save(true);
					}
					
				}
			}
		}else {
			_setError(e, "missing.config", "Missing configuration file.");
		}
		
		Sirius.header.setJSON();
		o.set("result", r);
		o.json(true);
		
		
		
	}
	
}