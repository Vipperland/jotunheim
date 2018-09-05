package sirius.php.data;
import php.Lib;
import sirius.php.net.Mailer;
import sirius.utils.Dice;
import sirius.utils.Filler;

/**
 * ...
 * @author Rim Project
 */
class Mail {
	
	private var _from_name:String;
	
	private var _from_email:String;
	
	private var _headers:String;

	public function new() {
		
	}
	
	public function init(from:String, email:String, organizaion:String, html:Bool = true, charset:String = "utf-8"):Mail {
		_from_name = from;
		_from_email = email;
		_headers = [
			"Reply-To: " + from  + " <" + email + ">",
			"Return-Path:" + from + " <" + email + ">",
			"From:" + from  + " <" + email + ">",
			"Organization:" + organizaion,
			"MIME: 1.0",
			"Content-type: text/" + (html ? "html" : "plain") + "; charset=" + charset,
			"X-Priority: 3",
			"X-Mailer: PHP " + untyped __call__("phpversion"),
			
		].join("\r\n");
		return this;
	}
	
	public function send(target:Dynamic, message:String):Array<Dynamic> {
		var errors:Array<Dynamic> = [];
		if (Std.is(target, Array)){
			Dice.Values(target, function(v:Dynamic){
				_sendRaw(v, message, errors);
			});
		}else{
			_sendRaw(target, message, errors);
		}
		return errors;
	}
	
	public function _sendRaw(target:Dynamic, message:String, errors:Array<Dynamic>):Void {
		if (!Lib.mail(target.name, target.email, Filler.to(message, target), _headers)){
			errors[errors.length] = target;
		}
	}
	
}