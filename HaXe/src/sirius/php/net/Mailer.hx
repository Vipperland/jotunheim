package sirius.php.net;
import haxe.Json;
import haxe.Utf8;
import php.Boot;
import php.Lib;
import php.Web;
import sirius.tools.Utils;
import sirius.utils.IOTools;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */

class Mailer {
	
	public static function target(name:String, mail:String):String {
		return mail + '|' + name;
	}
	
	public var output(get, null):PHPMailer;
	
	public function new(url:String, user:String, password:String, ?secure:String = null, ?port:UInt = 587) {
		Sirius.require('PHPMailer/PHPMailerAutoload.php');
		output = new PHPMailer();
		output.CharSet = 'UTF-8';
		output.isSMTP();
		output.isHTML(true);
		output.SMTPAuth = password != null && password != '';
		setAuth(url, user, password, secure, port);
	}
	
	public function origin(name:String, email:String):Void {
		if(email != null) output.From = email;
		if(name != null) output.FromName = name;
	}
	
	public function debug(level:UInt):Void {
		output.SMTPDebug = level;
	}
	
	public function setAuth(url:String, user:String, password:String, ?secure:String = null, ?port:UInt = 587):Void {
		output.Host = url;
		output.Username = user;
		output.Password = password;
		output.Port = port;
		if (secure != null) output.SMTPSecure = secure;
	}
	
	public function targets(to:Array<Dynamic>, ?cc:Array<Dynamic>, ?bbc:Array<Dynamic>):Void {
		Dice.Values(to, function(v:Dynamic) {
			if (Std.is(v, Array) && Utils.isValid(v[0])) 	output.addAddress(v[0], v[1]);
			else if(Utils.isValid(v))						output.addAddress(v);
		});
		Dice.Values(cc, function(v:Dynamic) {
			if (Std.is(v, Array) && Utils.isValid(v[0]))	output.addCC(v[0], v[1]);
			else if(Utils.isValid(v))						output.addCC(v);
		});
		Dice.Values(bbc, function(v:Dynamic) {
			if (Std.is(v, Array) && Utils.isValid(v[0]))	output.addBCC(v[0], v[1]);
			else if(Utils.isValid(v))						output.addBCC(v);
		});
	}
	
	public function message(subject:String, text:String):Void {
		output.Subject = subject;
		output.Body = text;
		output.AltBody = text.split('<br>').join('\r\n').split('<br/>').join('\r\n');
	}
	
	
	public function getError():Dynamic {
		return output.ErrorInfo;
	}
	
	public function send():Bool {
		return output.send();
	}
	
	private function get_output():PHPMailer {
		return output;
	}
	
}