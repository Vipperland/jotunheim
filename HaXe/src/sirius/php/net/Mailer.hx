package sirius.php.net;
import haxe.Json;
import haxe.Utf8;
import php.Boot;
import php.Lib;
import php.Web;
import sirius.utils.Criptog;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */

class Mailer {
	
	public static function target(name:String, mail:String):String {
		return mail + '|' + name;
	}
	
	private var _cLib:PHPMailer;

	public function new(url:String, user:String, password:String, ?secure:String = null, ?port:UInt = 587) {
		Sirius.require('PHPMailer/PHPMailerAutoload.php');
		_cLib = new PHPMailer();
		_cLib.CharSet = 'UTF-8';
		_cLib.isSMTP();
		_cLib.isHTML(true);
		_cLib.From = user;
		setAuth(url, user, password, secure, port);
	}
	
	public function origin(name:String, email:String):Void {
		if(email != null) _cLib.From = email;
		if(name != null) _cLib.FromName = name;
	}
	
	public function debug(level:UInt):Void {
		_cLib.SMTPDebug = level;
	}
	
	public function setAuth():Void {
		_cLib.Host = url;
		_cLib.Username = user;
		_cLib.Password = password;
		_cLib.Port = port;
		if (secure != null) _cLib.SMTPSecure = secure;
	}
	
	public function targets(to:Array<Dynamic>, ?cc:Array<Dynamic>, ?bbc:Array<Dynamic>):Void {
		Dice.Values(to, function(v:Dynamic) {
			if (Std.is(v, Array)) 	_cLib.addAddress(v[0], v[1]);
			else					_cLib.addAddress(v);
		});
		Dice.Values(cc, function(v:Dynamic) {
			if (Std.is(v, Array)) 	_cLib.addCC(v[0], v[1]);
			else					_cLib.addCC(v);
		});
		Dice.Values(bbc, function(v:Dynamic) {
			if (Std.is(v, Array)) 	_cLib.addBBC(v[0], v[1]);
			else					_cLib.addBBC(v);
		});
	}
	
	public function message(subject:String, text:String):Void {
		_cLib.Subject = subject;
		_cLib.Body = text;
		_cLib.AltBody = text.split('<br>').join('').split('<br/>').join('');
	}
	
	
	public function getError():Dynamic {
		return _cLib.ErrorInfo;
	}
	
	public function send():Bool {
		return _cLib.send();
	}
	
}