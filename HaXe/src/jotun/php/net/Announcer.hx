package jotun.php.net;
import jotun.php.net.PHPMailer;
import jotun.tools.Utils;
import jotun.utils.Dice;
import php.Syntax;

/**
 * ...
 * @author 
 */
class Announcer {

	
	private static var _initialized:Bool;
	
	private var _mailer:PHPMailer;
	
	private var _success:Bool;
	
	public var mailer(get, default):PHPMailer;
	private function get_mailer():PHPMailer {
		return _mailer;
	}
	
	/**
	 * Config:
	 *	host (default = from domain)
	 *	port (default = 25)
	 *	username (default = from)
	 *	password (default = '')
	 * 	secure (default = true)
	 * 	html (default = true)
	 * 	auth (SMTPAuth, default = true)
	 *	debug (default = 0)
	 * 	replyTo (default = from)
	 * 	replyName (default = name)
	 * 	returnPath (default = from)
	 * 	organization (default = name)
	 *}
	 * @param	from
	 * @param	name
	 * @param	config
	 */
	public function new(from:String, name:String, ?returnPath:String, ?organization:String) {
		if (!_initialized){
			Jotun.require('includes/PHPMailer/_loader.php');
			_initialized = true;
		}
		_mailer = Syntax.codeDeref('new \\PHPMailer()');
		_mailer.setFrom(from, name);
		if (returnPath != null){
			_mailer.addCustomHeader('Return-Path', returnPath);
		}
		if (organization != null){
			_mailer.addCustomHeader('Organization', organization);
		}
	}
	
	public function setDebugMode(mode:Int = 0):Announcer {
		_mailer.SMTPDebug = mode;
	}
	
	public function setHost(domain:String, port:Int = 25, secure:Bool = true):Announcer {
		_mailer.isSMTP();
		_mailer.Host = domain;
		_mailer.Port = port;
		_mailer.SMTPSecure = secure;
	}
	
	public function setAuthentication(name:String, password:String):Announcer {
		_mailer.SMTPAuth = true;
		_mailer.Username = username;
		_mailer.Password = password;
		return this;
	}
	
	public function replyTo(email:String, name:String):Announcer {
		_mailer.addReplyTo(email, name);
		return this;
	}
	
	public function addTo(to:Dynamic):Announcer {
		if (!Std.isOfType(to, Array)){
			to = [to];
		}
		Dice.Values(to, function(v:Dynamic){
			_mailer.addAddress(v.email, v.name);
		});
		return this;
	}
	
	public function addCC(to:Dynamic):Announcer {
		if (!Std.isOfType(to, Array)){
			to = [to];
		}
		Dice.Values(to, function(v:Dynamic){
			_mailer.addCC(v.email, v.name);
		});
		return this;
	}
	
	public function addBCC(to:Dynamic):Announcer {
		if (!Std.isOfType(to, Array)){
			to = [to];
		}
		Dice.Values(to, function(v:Dynamic){
			_mailer.addBCC(v.email, v.name);
		});
		return this;
	}
	
	public function addAttachments(files:Dynamic):Announcer {
		if (!Std.isOfType(files, Array)){
			files = [files];
		}
		Dice.Values(files, function(v:Dynamic){
			_mailer.addAttachment(v.name, v.file);
		});
		return this;
	}
	
	public function sendPlainText(subject:String, content:String):Announcer {
		_mailer.Subject = subject;
		_mailer.Body = content;
		_success = _mailer.send();
		return this;
	}
	
	public function sendHtml(subject:String, content:String):Announcer {
		_mailer.isHTML(true);
		_mailer.Subject = subject;
		_mailer.Body = content;
		_success = _mailer.send();
		return this;
	}
	
	public function sendFull(subject:String, html:String, text:String):Announcer {
		_mailer.isHTML(true);
		_mailer.Subject = subject;
		_mailer.Body = html;
		_mailer.AltBody = text;
		_success = _mailer.send();
		return this;
	}
	
	public function isSuccess():Bool {
		return _success;
	}
	
	public function getError():String {
		return _mailer.ErrorInfo;
	}
	
}