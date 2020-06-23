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
		
		var buff:Array<Dynamic> = [];
		
		Dice.All(Jotun.header.getClientHeaders(), function(p:String, v:String){
			buff.push(p + ': ' + v);
		});
		buff.push('===================================================== Parameters: (Method:' + Jotun.domain.getRequestMethod() + ')');
		Dice.All(Jotun.domain.params, function(p:String, v:String){
			buff.push(p + ': ' + v);
		});
		buff.push('===================================================== APPLICATION/JSON Content-Type');
		//buff.push(Utils.sruString(Jotun.domain.input));
		buff.push(Utils.sruString(Jotun.domain));
		
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
		
		Jotun.header.setJSON(buff);
		
	}
	
	
}