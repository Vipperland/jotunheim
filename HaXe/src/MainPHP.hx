package;
import haxe.Log;
import haxe.Utf8;
import php.db.Command;
import php.db.Gate;
import php.db.Token;
import php.Lib;
import sirius.php.Sirius;
import sirius.php.utils.Header;

/**
 * ...
 * @author Rafael Moreira
 */
class MainPHP{

	static public function main() {
		Sirius.header.content(Header.JSON);
		var g:Gate = Sirius.db.open(new Token('localhost', 3306, 'root', '', 'apto.vc'));
		if(g.isOpen()){
			var c:Command = g.prepare('SELECT * FROM types_states').execute();
			if (c.success) {
				c.queue('states');
				Sirius.header.setJSON();
				Sirius.cache.json(true, Utf8.encode);
				Sirius.cache.json(true, Utf8.decode);
			}
		}
	}
	
}