package;
import jotun.Jotun;
import jotun.php.file.Uploader;
import jotun.tools.Utils;
import jotun.utils.Dice;

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