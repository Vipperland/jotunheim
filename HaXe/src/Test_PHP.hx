package;
import jotun.Jotun;
import jotun.db.Token;
import jotun.php.file.Uploader;
import jotun.tools.Utils;
import jotun.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {

	static public function main() {
		//var img:Image = new Image('../assets/img/image.jpg');
		//img.fit(300,300).save('../assets/img/test.jpg');
		//trace('===================================================== Headers');
		Dice.All(Jotun.header.getClientHeaders(), function(p:String, v:String){
			trace(p + ': ' + v);
		});
		trace('===================================================== Parameters: (Method:' + Jotun.domain.getRequestMethod() + ')');
		Dice.All(Jotun.domain.params, function(p:String, v:String){
			trace(p + ': ' + v);
		});
		trace('===================================================== APPLICATION/JSON Content-Type');
		trace(Utils.sruString(Jotun.domain.input));
		
		trace('===================================================== Files');
		trace(Uploader.save([[1280, 720], [720, 480], [480, 360]]).list);
		
		trace('===================================================== Database Handshake');
		Jotun.gate.open(Token.localhost('decorador'), true);
		if (Jotun.gate.isOpen()){
			Jotun.gate.setPdoAttributes(true);
			trace('Successful Handshake!');
		}else{
			trace(Jotun.gate.errors);
		}
		
	}
	
}