package;
import php.Lib;
import sirius.data.DataCache;
import sirius.db.Clause;
import sirius.db.Gate;
import sirius.db.IGate;
import sirius.db.objects.IDataTable;
import sirius.db.Token;
import sirius.Sirius;
import sirius.php.file.Image;
import sirius.php.file.ImageLib;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {

	static public function main() {
		var img:Image = new Image('../assets/img/image.jpg');
		img.fit(300,300).save('../assets/img/test.jpg');
	}
	
}