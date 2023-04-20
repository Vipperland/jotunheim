package jotun.php.data;
import php.Lib;
import jotun.utils.Dice;
import jotun.utils.Filler;
import sys.io.File;

/**
 * ...
 * @author Rim Project
 */
class Mail {
	
	private var _from_name:String;
	
	private var _from_email:String;
	
	private var _bounce_to:String;
	
	private var _organization:String;
	
	private var _total:UInt;
	
	private var _errors:UInt;
	
	private var _host:String;

	private function _sendRaw(subject:String, target:Dynamic, html:String, plain:String):Void {
		var boundary:String = "_Part_" + untyped __php__("md5(uniqid(rand()))");
		var header:String = _genHeader(boundary);
		var message:String = _genMessage(boundary, html, plain);
		if (!Lib.mail(target.name + ' <' + target.email + '>', subject, Filler.to(message, target), header, '-f ' + _from_email)){
			++_errors;
		}else{
			++_total;
		}
	}
	
	function _genMessage(boundary:String, html:String, plain:String):String {
		return [
			"--" + boundary,
			"Content-Type: text/plain; charset=utf-8",
			"Content-Transfer-Encoding: 7bit",
			"",
			plain,
			"",
			"--" + boundary,
			"Content-Type: text/html; charset=utf-8",
			"Content-Transfer-Encoding: 7bit",
			"",
			"<html>" + html + "</html>",
			"",
			"--" + boundary + "--",
		].join("\r\n");
	}
	
	private function _genHeader(boundary:String):String {
		return [
			"Message-ID: <" + untyped __php__("sha1(microtime(true))") + "@" + _host + ">",
			"From: " + _from_name  + " <" + _from_email + ">",
			"X-Sender: " + _from_name  + " <" + _from_email + ">",
			"Reply-To: " + _from_name  + " <" + _from_email+ ">",
			"Return-Path: " + _from_name + " <" + _bounce_to + ">",
			"Organization: " + _organization,
			"MIME-Version: 1.0",
			"Date: " + untyped __php__("date('r')"),
			"X-Priority: 3",
			"X-Mailer: PHP " + untyped __php__("phpversion()"),
			"Content-Type: multipart/alternative; boundary=\"" + boundary + "\"",
		].join("\r\n");
	}
	
	public function new() { }
	
	public function init(host:String, from:String, email:String, organizaion:String, ?bounce:String):Mail {
		_host = host;
		_from_name = from;
		_from_email = email;
		_organization = organizaion;
		if (_bounce_to == null){
			_bounce_to = email;
		}
		resetCounters();
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
	
	/**
	 * 
	 * @param	subject
	 * @param	target    [{name, email}, ...]
	 * @param	html
	 * @param	plain
	 * @return
	 */
	public function send(subject:String, target:Dynamic, html:String, plain:String):Bool {
		if (Std.isOfType(target, Array)){
			Dice.Values(target, function(v:Dynamic){
				_sendRaw(subject, v, html, plain);
			});
		}else{
			_sendRaw(subject, target, html, plain);
		}
		return hasErrors();
	}
	
	
}