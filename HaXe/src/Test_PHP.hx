package;
import haxe.Log;
import php.Lib;
import sirius.php.db.ICommand;
import sirius.php.db.IGate;
import sirius.php.db.Token;
import sirius.php.utils.Header;
import sirius.Sirius;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP{

	static public function main() {
		Sirius.header.content(Header.JSON);
		var g:IGate = Sirius.gate.open(new Token('localhost', 3306, 'root', '', 'apto.vc'));
		if (g.isOpen()) {
			//var c:ICommand = g.prepare('SELECT id,name,abbreviation FROM types_states').execute();
			//if (c.success) {
				//c.queue('states');
				//Sirius.header.setJSON();
				//Sirius.cache.json(true);
			//}
			Lib.dump(g.fields('types_states'));
		}
	}
	
}