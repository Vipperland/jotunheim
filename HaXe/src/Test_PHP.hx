package;
import jotun.Jotun;
import jotun.php.db.Clause;
import jotun.php.db.Token;
import jotun.php.file.Uploader;
import jotun.serial.JsonTool;
import jotun.tools.Key;
import jotun.tools.Utils;
import jotun.utils.Dice;
import php.Session;
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
	
}
class User {
	public var name:String;
	var key:String;
	public function new(){
		key = Key.GEN();
	}
}