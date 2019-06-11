package jotun.php.data;
import php.Lib;
import jotun.utils.Dice;
import jotun.utils.Filler;

/**
 * ...
 * @author Rim Project
 */
class Mail {
	
	private var _from_name:String;
	
	private var _from_email:String;
	
	private var _headers:String;
	
	private var _total:UInt;
	
	private var _errors:UInt;

	private function _sendRaw(subject:String, target:Dynamic, message:String):Void {
		if (!Lib.mail(target.name + ' <' + target.email + '>', subject, Filler.to(message, target), _headers)){
			++_errors;
		}else{
			++_total;
		}
	}
	
	public function new() { }
	
	public function init(from:String, email:String, organizaion:String, html:Bool = true, charset:String = "utf-8"):Mail {
		_from_name = from;
		_from_email = email;
		_headers = [
			"Reply-To: " + from  + " <" + email + ">",
			"Return-Path: " + from + " <" + email + ">",
			"From: " + from  + " <" + email + ">",
			"Organization: " + organizaion,
			"MIME-Version: 1.0",
			"Date: " + untyped __php__("date('r')"),
			"Message-ID: <" + untyped __php__("sha1(microtime(true))") + "@rimproject.com>",
			"Content-type: text/" + (html ? "html" : "plain") + "; charset=" + charset,
			"X-Priority: 3",
			"X-Mailer: PHP " + untyped __php__("phpversion()"),
		].join("\r\n") + "\r\n";
		resetCounters();
		return this;
	}
	
	public function getHeaders():String {
		return _headers;
	}
	public function setHeaders(value:String):Mail {
		_headers = value;
		return this;
	}
	
	public function hasErrors():Bool {
		return _errors > 0;
	}
	
	public function getTotalSent():UInt {
		return _total;
	}
	
	public function getErrorCount():UInt {
		return _errors;
	}
	
	public function resetCounters():Mail {
		_total = 0;
		_errors = 0;
		return this;
	}
	
	public function send(subject:String, target:Dynamic, message:String):Bool {
		if (Std.is(target, Array)){
			Dice.Values(target, function(v:Dynamic){
				_sendRaw(subject, v, message);
			});
		}else{
			_sendRaw(subject, target, message);
		}
		return hasErrors();
	}
	
	
}