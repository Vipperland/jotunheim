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
				//Sirius.header.setJSON();
				//Sirius.cache.json(true);
			}
			//Dice.Values(g.schemaOf('types_states').structure(), function(v:IDataSet) {
				//Sirius.log(v.filter('COLUMN_NAME'));
			//});
			
			//var c:IDataCache = new DataCache("test", "domain", 60);
			//c.set('name', "Rafael");
			//c.save();
			//Lib.dump(c.load().getData());
			Lib.dump(untyped __php__("$_SERVER"));
			Lib.dump(Sirius.domain);
			
		}else {
			Sirius.log(g.errors);
		}
	}
	
}