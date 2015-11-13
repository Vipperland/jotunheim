package sirius.php.ext;
import haxe.Json;
import php.Lib;
import sirius.data.DataCache;
import sirius.db.Clause;
import sirius.db.IGate;
import sirius.db.objects.IDataTable;
import sirius.db.objects.IQueryResult;
import sirius.db.Token;

/**
 * ...
 * @author Rafael Moreira
 */
class Location{

	static public function main() {
		
		// Open connection
		var gate:IGate = Sirius.gate.open(new Token('localhost', 3306, 'root', '', 'apto.vc'));
		
		// Select table for easy handling
		var table:IDataTable = gate.table('types_states');
		
		// Restrict Find() fields
		table.restrict(['id', 'name', 'abbreviation']);
		
		// Select all rows
		var data:IQueryResult = table.findAll();
		
		// Print the result
		Sirius.header.setJSON( data );
		
	}
	
}