package;
import sirius.data.DataCache;
import sirius.db.Clause;
import sirius.db.Gate;
import sirius.db.IGate;
import sirius.db.objects.IDataTable;
import sirius.db.Token;
import sirius.Sirius;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {

	static public function main() {
		
		Sirius.header.access("*");
		Sirius.header.setJSON();
		
		var gate:IGate = new Gate();
		
		//var selectCond:Dynamic = Clausule.EQUAL("id", 1);
		
		//trace(gate.builder.create("users", null, {email:"admin@domain.co", pass:"testPass"}).log());
		//
		//trace(gate.builder.find(["id","email","name"],"users", selectCond, null, "1").log());
		//
		//trace(gate.builder.update("users", selectCond, { email:"super@domain.co" } ).log());
		//
		//trace(gate.builder.delete("users", selectCond).log());
		//
		//var data:DataCache = new DataCache('test', 'domain', 1000);
		//if (data.load().exists()) {
			//data.json(true);
			//return;
		//}
		//
		

		
		
		var gate:IGate = Sirius.gate.open(new Token('localhost', 3306, 'root', '', 'apto.vc'));
		var table:IDataTable = gate.getTable('types_states');
		
		var states:Array<Dynamic> = table.find(["id", "name", "abbreviation"]);
		
		var data:DataCache = new DataCache();
		data.set('states', states);
		data.set('errors', gate.errors);
		data.json(true);
		
		//if (g.isOpen()) {
			//var c:ICommand = g.prepare('SELECT id,name,abbreviation FROM types_states').execute();
			//if (c.success) {
				//data.set('states', c.result);
				//data.json(true);
				//data.save();
			//}
			////Dice.Values(g.schemaOf('types_states').structure(), function(v:IDataSet) {
				////Sirius.log(v.filter('COLUMN_NAME'));
			////});
			//
		//}else {
			//Sirius.log(g.errors);
		//}
	}
	
}