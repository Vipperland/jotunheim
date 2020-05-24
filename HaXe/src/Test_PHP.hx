package;
import haxe.Utf8;
import haxe.io.Bytes;
import jotun.Jotun;
import jotun.php.db.Clause;
import jotun.php.db.Token;
import jotun.php.file.Uploader;
import jotun.php.net.PHPMailer;
import jotun.serial.IOTools;
import jotun.serial.JsonTool;
import jotun.tools.Key;
import jotun.tools.Utils;
import jotun.utils.Dice;
import php.Lib;
import php.NativeArray;
import php.Session;
import php.Syntax;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {

	static public function main() {
		//var img:Image = new Image('../assets/img/image.jpg');
		//img.fit(300,300).save('../assets/img/test.jpg');
		//Session.setCookieParams(600, '/sys/', Jotun.domain.host, false, true);
		//Session.setName('JOTUNHEIM');
		//Session.start();
		//
		
		//trace('===================================================== Headers');
		var buff:Array<Dynamic> = [];
		
		//buff.push('SESSION: ' + Session.getId());
		
		Dice.All(Jotun.header.getClientHeaders(), function(p:String, v:String){
			buff.push(p + ': ' + v);
		});
		buff.push('===================================================== Parameters: (Method:' + Jotun.domain.getRequestMethod() + ')');
		Dice.All(Jotun.domain.params, function(p:String, v:String){
			buff.push(p + ': ' + v);
		});
		buff.push('===================================================== APPLICATION/JSON Content-Type');
		buff.push(Utils.sruString(Jotun.domain.input));
		
		buff.push('===================================================== Files');
		buff.push(Uploader.save('./uploads/', {
			thumb:{
				width:240,
				height:160,
				create:true,
			},
			small:{
				width:480,
				height:320,
				create:true,
			},
			medium:{
				width:960,
				height:640,
				create:true,
			},
			large:{
				width:1280,
				height:960,
				create:true,
			},
		}).list);
		
		buff.push('===================================================== Database Connect');
		Jotun.gate.open(Token.localhost('decorador'), true);
		if (Jotun.gate.isOpen()){
			buff.push('Successful!');
			buff.push('users: ');
			Jotun.gate.table('users').setClassObj(User);
			var u:User = Jotun.gate.table('users').findOne(Clause.ID(2));
			buff.push(u);
		}else{
			buff.push(Jotun.gate.errors);
		}
		
		Jotun.header.setJSON(buff);
		
	}
	
	
	static private var _mailer:PHPMailer;
	
	private static function _testMail(buff:Array<Dynamic>) {
		
		Jotun.require('includes/PHPMailer/_loader.php');
		
		_mailer = Syntax.construct('PHPMailer');
		
		_mailer.SMTPDebug = 3;
		_mailer.isSMTP();
		_mailer.Port = 25;
		_mailer.Host = 'rimproject.com';
		_mailer.SMTPSecure = '';
		_mailer.SMTPAuth = true;
		_mailer.CharSet = 'UTF-8';
		_mailer.AuthType = 'PLAIN';
		_mailer.Username  = 'hi@rimproject.com';
		_mailer.Password = '@HornyGirl69';
		
		_mailer.setFrom('hi@rimproject.com', 'Rim Project');
		_mailer.addReplyTo('hi@rimproject.com', 'Rim Project');
		
		_mailer.addCustomHeader('Return-Path',"global-bouncer-x@rimproject.com");
		_mailer.addCustomHeader('Organization', "RimProject");
		_mailer.addAddress('vipperland@live.com', 'Rafael Moreira');
		_mailer.addAddress('coldzone@gmail.com', 'Rafael Moreira');
		_mailer.Subject = "[TEST] Alliance Security PIN Request";
		var key:String = Key.GEN(4, '0123456789');
		_mailer.isHTML(true);
		_mailer.Body = "Hello Citizen of the Alliance<br/><font style='font-size:24px;'><b>Rafael Moreira</b></font><br/><br/>Your security <b>PIN</b>:<br/><font style='font-size:36px;'><b># " + key + "</b><font>";
		_mailer.AltBody = "Hello Citizen of the Alliance\r\nYour security PIN: " + key;
		//buff.push('SEND MAIL? ' + _mailer.send());
		trace(_mailer.send());
		trace(_mailer.ErrorInfo);
	}
}

class User {
	public var name:String;
	var key:String;
	public function new(){
		key = Key.GEN();
	}
}