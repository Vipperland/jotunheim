package;
import php.Lib;
import sirius.Sirius;
import sirius.db.Token;
import sirius.db.objects.IDataTable;
import sirius.db.objects.ITableObject;
import sirius.php.file.ImageLib;
import sirius.php.file.Uploader;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {

	static public function main() {
		//var img:Image = new Image('../assets/img/image.jpg');
		//img.fit(300,300).save('../assets/img/test.jpg');
		trace('===================================================== Headers');
		Dice.All(Sirius.domain.data, function(p:String, v:String){
			trace(p + ': ' + v);
		});
		trace('===================================================== Parameters: GET/POST');
		Dice.All(Sirius.domain.params, function(p:String, v:String){
			trace(p + ': ' + v);
		});
		trace('===================================================== APPLICATION/JSON Content-Type');
		trace(Utils.sruString(Sirius.domain.input));
		
		trace('===================================================== Files');
		trace(Uploader.save([[1280, 720], [720, 480], [480, 360]]).list);
		
		var dbo:
		
	}
	
}