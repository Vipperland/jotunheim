package sirius.net;
import haxe.Json;
import php.Boot;
import php.Lib;
import sirius.utils.Criptog;

/**
 * ...
 * @author Rafael Moreira
 */
class Mailer {
	
	public static function target(name:String, mail:String):String {
		return name + ' <' + mail + '>';
	}
	
	public var subject:String;
	
	public var bbc:Array<String>;
	
	public var from:String;
	
	public var text:String;
	
	public var cc:Array<String>;
	
	public var to:Array<String>;

	public function new() {
	}
	
	public function targets(from:String, to:Array<String>, ?cc:Array<String>, ?bbc:Array<String>):Void {
		this.bbc = bbc;
		this.from = from;
		this.to = to;
		this.cc = cc;
	}
	
	public function message(subject:String, text:String):Void {
		this.subject = subject;
		this.text = text;
	}
	
	public function send():Bool {
		var head:Array<String> = [];
		head.push('MIME-Version: 1.0');
		head.push('Content-type: text/html; charset=utf8');
		head.push('To: ' + to.join(', '));
		head.push('From: ' + from);
		head.push('Reply-To: ' + from);
		head.push('Subject: ' + subject);
		head.push('X-Mailer: PHP/' + untyped __php__('phpversion()'));
		if(cc != null && cc.length > 0) head.push('Cc: ' + cc.join(', '));
		if (bbc != null && bbc.length > 0) head.push('Bcc: ' + bbc.join(', '));
		return Lib.mail(to.join(','), subject, text, head.join("\r\n"));
	}
	
	public function json():String {
		return Json.stringify(this);
	}
	
	public function base64():String {
		return Criptog.encodeBase64(this);
	}
	
}