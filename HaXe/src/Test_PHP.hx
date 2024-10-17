package;
import jotun.Jotun;
import jotun.gaming.dataform.Pulsar;
import jotun.gaming.dataform.PulsarLink;
import jotun.gaming.dataform.Spark;
import jotun.net.Domain;
import jotun.php.db.Clause;
import jotun.php.db.Token;
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
		
		//Pulsar.map('color', [], Spark);
		Pulsar.map('r', ['ammount'], Spark);
		Pulsar.map('g', ['ammount'], Spark);
		Pulsar.map('b', ['ammount'], Spark);
		Pulsar.map('a', ['ammount'], Spark);
		
		
		var p:Pulsar = new Pulsar();
		
		var c:Spark = new Spark('color');
		p.insert(c);
		//r.insert(new Spark('ink'));
		p.link('color').get(0).insert(new Spark('r').set('ammount', 10));
		p.link('color').get(0).insert(new Spark('g').set('ammount', 20));
		p.link('color').get(0).insert(new Spark('b').set('ammount', 30));
		p.link('color').get(0).insert(new Spark('a').set('ammount', 0.3));
		
		
		//Jotun.header.setTEXT(p.link('colors').stringify());
		Jotun.header.setTEXT(p.toString(false));
		
		//var rA:String = colA.toString(true);
		//trace('colA data(' + cA + ') \r\n\t' + rA.split('\n').join('\r\n\t'));
		//
		//var cB:Int = colB.parse(rA);
		//var rB:String = colB.toString(true);
		//trace('colB data(' + cB + ') \r\n\t' + rB.split('\n').join('\r\n\t'));
		//
		//trace('Data Match? \r\n\t' + (t == rA && t == rB));
		
		//return;
		//
		//var buff:Array<Dynamic> = [];
		//
		//Dice.All(Jotun.header.getClientHeaders(), function(p:String, v:String){
			//buff.push(p + ': ' + v);
		//});
		//buff.push('===================================================== Parameters: (Method:' + Jotun.domain.getRequestMethod() + ')');
		//Dice.All(Jotun.domain.params, function(p:String, v:String){
			//buff.push(p + ': ' + v);
		//});
		//buff.push('===================================================== APPLICATION/JSON Content-Type');
		//buff.push(Utils.sruString(Jotun.domain.input));
		//buff.push(Utils.sruString(Jotun.domain));
		
		//buff.push('===================================================== Files');
		//buff.push(Uploader.save('./uploads/', {
			//thumb:{
				//width:240,
				//height:160,
				//create:true,
			//},
			//small:{
				//width:480,
				//height:320,
				//create:true,
			//},
			//medium:{
				//width:960,
				//height:640,
				//create:true,
			//},
			//large:{
				//width:1280,
				//height:960,
				//create:true,
			//},
		//}).list);
		//
		
		
		//Jotun.gate.open(Token.localhost('decorador'), true);
		var q:Dynamic = Jotun.gate.table('users').findJoin(['users.id as UID','users.name as NAME','location_state.alt as STATE','location_city.name as CITY'], [
			Jotun.gate.builder.leftJoin('user_address', Clause.EQUAL('address.user_id', 1)),
			Jotun.gate.builder.leftJoin('location_state', Clause.CUSTOM('state.id=address.state_id')),
			Jotun.gate.builder.leftJoin('location_city', 'city.id=address.city_id'),
		], Clause.CUSTOM('users.id<30'));
		
		//
		//buff.push(Jotun.gate.log);
		//buff.push(q);
		//
		//Jotun.header.setJSON(buff);
		
	}
	
	
}