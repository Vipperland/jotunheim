package jotun.gateway;
import jotun.Jotun;
import jotun.gaming.dataform.Pulsar;
import jotun.gaming.dataform.PulsarLink;
import jotun.gaming.dataform.Spark;
import jotun.net.Domain;
import jotun.php.db.Clause;
import jotun.php.db.Token;
import jotun.php.db.objects.DataTable;
import jotun.php.db.objects.ExtQuery;
import jotun.php.db.tools.QueryBuilder;
import jotun.php.file.Uploader;
import jotun.tools.Utils;
import jotun.utils.Dice;
import php.Global;
import php.Lib;

/**
 * ...
 * @author Rafael Moreira
 */
class Test_PHP {

	static public function main() {
		
		var buff:Array<Dynamic> = [];
		
		Jotun.gate.listen(function(v:String):Void {
			buff.push(v);
		});
		
		Jotun.gate.open(Token.localhost('decorsim'));
		//var q:Dynamic = Jotun.gate.table('campaign_env_name').findJoin(['users.id as UID','users.name as NAME','location_state.alt as STATE','location_city.name as CITY'], [
			//Jotun.gate.builder.leftJoin('user_address', Clause.EQUAL('address.user_id', 1)),
			//Jotun.gate.builder.leftJoin('location_state', Clause.CUSTOM('state.id=address.state_id')),
			//Jotun.gate.builder.leftJoin('location_city', 'city.id=address.city_id'),
		//], Clause.CUSTOM('users.id<30'));
		
		if (Jotun.gate.isOpen()){
			var r:ExtQuery = Jotun.gate.table('campaign_env_name').find("*", Clause.AND([
				Clause.LIKE('name', '%a%')
			]));
			buff.push(r.data);
		}
		
		
		buff.push(Jotun.gate.errors);
		
		Jotun.header.setJSON(buff);
		
	}
	
	
}
