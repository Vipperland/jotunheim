package;

import jotun.gaming.dataform.DataCollection;
import jotun.gaming.dataform.DataObject;
import jotun.idb.WebDB;
import jotun.idb.WebDBTable;

/**
 * ...
 * @author Rafael Moreira <rafael@gateofsirius.com>
 */
class Test_JS{
	
	static private var _db:WebDB;
	
	static public function main() {
		// https://www.facebook.com/pegadinhasdaredetv/videos/380892232600044/?t=132
		
		DataCollection.map(DataObject, 'test', ['name', 'email']);
		DataCollection.map(DataObject, 'info', ['color']);
		
		var t:String = [
			"test 000001 0:alpha|1:user@alpha.com",
			"@info 0:yellow",
			"@info 0:blue",
			"test 000002 0:beta|1:user@beta.com",
			"@info 0:gray",
			"test 000003 0:gama|1:user@gama.com",
			"@info 0:cyan",
			"test 000004 0:omega|1:user@omega.com",
		].join('\r');
		
		var colA:DataCollection = new DataCollection();
		var colB:DataCollection = new DataCollection();
		
		var cA:Int = colA.parse(t);
		var rA:String = colA.stringify();
		trace('colA data(' + cA + ') \r\n\t' + rA.split('\r').join('\r\n\t'));
		
		var cB:Int = colB.parse(t);
		var rB:String = colB.stringify();
		trace('colB data(' + cB + ') \r\n\t' + rB.split('\r').join('\r\n\t'));
		
		trace('Data Match? \r\n\t' + (t == rA && t == rB));
		
		
		WebDB.open('test', 1, function(db:WebDB){
			_db = db;
			if (db.isOpen()){
				if (db.isUpgradeNeeded()){
					trace('DB UPGRADE');
					var t:WebDBTable = db.createTable('users', {keyPath:'_id', autoIncrement:true});
					t.addIndex('name', 'name', {unique:false});
					t.addIndex('gender', 'gender', {unique:false});
					t.add({name:'Rafael', gender:'Male'});
					t.add({name:'Daya', gender:'Female'});
					
				}else{
					trace('DB READY');
					db.getTables('users', 'rw', function(db:WebDB){ });
					db.table('users').getAll(null, null, function(tb:WebDBTable){
						trace(tb.getResult());
					});
				}
			}else{
				trace(db.getError().message);
			}
		});
		
	}
	
} 
