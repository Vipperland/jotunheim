package;
import haxe.Log;
import php.Lib;
import php.Web;
import sirius.data.DataCache;
import sirius.data.IDataCache;
import sirius.data.IDataSet;
import sirius.db.ICommand;
import sirius.db.IGate;
import sirius.db.Token;
import sirius.Sirius;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {

	static public function main() {
		
		Sirius.header.access("*");
		Sirius.header.setJSON();
		
		var data:DataCache = new DataCache('test', 'domain', 1000);
		if (data.load().exists()) {
			data.json(true);
			return;
		}
		
		var g:IGate = Sirius.gate.open(new Token('localhost', 3306, 'root', '', 'apto.vc'));
		if (g.isOpen()) {
			var c:ICommand = g.prepare('SELECT id,name,abbreviation FROM types_states').execute();
			if (c.success) {
				data.set('states', c.result);
				data.json(true);
				data.save();
			}
			//Dice.Values(g.schemaOf('types_states').structure(), function(v:IDataSet) {
				//Sirius.log(v.filter('COLUMN_NAME'));
			//});
			
		}else {
			Sirius.log(g.errors);
		}
	}
	
}