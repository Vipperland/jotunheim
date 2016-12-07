package;

import sirius.css.Automator;
import sirius.net.ILoader;
import sirius.Sirius;
import sirius.tools.Ticker;
import sirius.ui.Alert;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Test_JS{
	
	static public function main() {
		
	}
	
} 

/*

	Sirius.gate.command.find(table|String, fields:Array, parameters|Dynamic, limit|Dynamic, order|Dynamic)
														|				|			|
														|				|			|----> {prop:mode}
														|				|
														|				|----> {lenght:10, page:2}
														|
														|----> AND {propA:Prop.equal(value|values), propB:Prop.like(value|values), propC:Prop.any(values)'}
														|		|				|				|						|
														|		|				|				|						|----> "prop|in|value" IN
														|		|				|				|
														|		|				|				|----> "prop,lk,value" LIKE
														|		|				|
														|		|				|----> "prop,eq,value" EQUAL
														|		|
														|		|----> SELECT ...fields FROM table WHERE (propA=value AND propB LIKE %value% AND propC IN (...values) LIMIT 20,30 ORDER BY mode);
														|
														|----> OR [{propA:Prop.equal(value)'}, {propB:Prop.equal(value)}]
																|
																|----> SELECT ...fields FROM table WHERE (propA=value) OR (propB=value) LIMIT 20,30 ORDER BY mode);
	
	Sirius.gate.command.push(table|String, data:Dynamic)
										|
										|----> INSERT INTO table (...data.fields,,,) VALUES (...data.values,,,);
	
	Sirius.gate.command.update(table|String, data:Dynamic, parameters|Dynamic, limit|Uint)
										|
										|----> UPDATE table SET (...data.prop..N=data.value..N) WHERE ...parameters LIMIT limit;
	
	Sirius.gate.command.remove(table|String, parameters|Dynamic, limit|Uint)
										|
										|----> DELETE FROM table WHERE ...parameters LIMIT limit;
	
*/