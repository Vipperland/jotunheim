package;
import haxe.Log;
import haxe.Utf8;
import php.db.Command;
import php.db.Gate;
import php.db.Token;
import php.Lib;
import sirius.Sirius;
import sirius.php.utils.Header;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP{

	static public function main() {
		Sirius.header.content(Header.JSON);
		var g:Gate = Sirius.database.open(new Token('localhost', 3306, 'root', '', 'apto.vc'));
		if(g.isOpen()){
			var c:Command = g.prepare('SELECT id,name,abbreviation FROM types_states').execute();
			if (c.success) {
				c.queue('states');
				Sirius.header.setJSON();
				Sirius.cache.json(true);
			}
		}
	}
	
}