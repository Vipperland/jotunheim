package;
import jotun.Jotun;
import jotun.db.Token;
import jotun.php.file.Uploader;
import jotun.serial.JsonTool;
import jotun.tools.Key;
import jotun.tools.Utils;
import jotun.utils.Dice;
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
		//trace('===================================================== Headers');
		var buff:Array<Dynamic> = [];
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
		Jotun.gate.open(Token.localhost('rp_afterfall'), true);
		if (Jotun.gate.isOpen()){
			buff.push('Successful!');
			buff.push('users: ');
			
			Jotun.gate.table('rp_users').setClassObj(User);
			Jotun.gate.table('rp_users').query
			var u:User = Jotun.gate.table('rp_users').findAll().data[0];
			buff.push(u);
			
		}else{
			buff.push(Jotun.gate.errors);
		}
		
		Jotun.header.setJSON(buff);
		
	}
	
}
class User {
	var key:String;
	public function new(){
		key = Key.GEN();
	}
}