package;
import php.Lib;
import sirius.data.IDataSet;
import sirius.php.db.ICommand;
import sirius.php.db.IGate;
import sirius.php.db.Token;
import sirius.Sirius;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {

	static public function main() {
		//Sirius.header.content(Header.JSON);
		var g:IGate = Sirius.gate.open(new Token('localhost', 3306, 'root', '', 'apto.vc'));
		if (g.isOpen()) {
			var c:ICommand = g.prepare('SELECT id,name,abbreviation FROM types_states').execute();
			if (c.success) {
				c.queue('states');
				Sirius.header.setJSON();
				Sirius.cache.json(true);
			}
			//Dice.Values(g.schemaOf('types_states').structure(), function(v:IDataSet) {
				//Sirius.log(v.filter('COLUMN_NAME'));
			//});
		}else {
			Sirius.log(g.errors);
		}
	}
	
}