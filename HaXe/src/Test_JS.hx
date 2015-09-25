package;
import haxe.Log;
import sirius.css.Automator;
import sirius.css.XCSS;
import sirius.dom.Body;
import sirius.dom.Display3D;
import sirius.dom.Div;
import sirius.dom.IDisplay3D;
import sirius.dom.Sprite3D;
import sirius.events.IEvent;
import sirius.math.ARGB;
import sirius.modules.ILoader;
import sirius.modules.IRequest;
import sirius.modules.Request;
import sirius.Sirius;
import sirius.tools.Ticker;
import sirius.tools.Utils;
import sirius.utils.Dice;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class Test_JS{

	static public function main() {
		
		//XCSS.enabled = true;
		//
		//Sirius.init(function(l:ILoader) {
			//
			//if (Sirius.agent.screen < 3) return;
			//
			//var body:Body = Sirius.document.body;
			//body.style( { 'overflow-x':'hidden' } );
			//
			//var cont:Sprite3D = new Sprite3D();
			//cont.content.fit(100, 100, true);
			//cont.overflow('hidden');
			//cont.pin();
			//
			//var head:IDisplay3D = cast new Display3D().addTo(cont.content);
			//var middle:IDisplay3D = cast new Display3D().addTo(cont.content);
			//var bottom:IDisplay3D = cast new Display3D().addTo(cont.content);
			//
			//head.background('#006699');
			//middle.background('#996600');
			//bottom.background('#009900');
			//
			//cont.width(100, true);
			//cont.content.height(100, true);
			//cont.addTo();
			//
			//var rest:Div = new Div();
			//rest.width(100, true);
			//rest.height(1600);
			//rest.background('#CCCCCC');
			//rest.addTo();
			//
			//cont.setPerspective(null, '50% 50%');
			//cont.update();
			//
			//cont.content.height(100, true);
			//cont.content.update();
			//
			//Dice.All([head, middle, bottom], function(p:Int, e:IDisplay3D) {
				//e.doubleSided(false);
				//e.detach();
				//e.style({y:0,top:0});
				//e.width(100, true);
				//e.data.set('rotation', p * -90);
				//e.setPerspective(null, '50% 50%');
				//e.update();
			//});
			//
			//Ticker.add(function() {
				//
				//var h:Int = Utils.viewportHeight();
				//var h2:Float = h / 2;
				//
				//cont.fit(Utils.viewportWidth(), h);
				//
				//var y:Float = Sirius.document.getScroll().y;
				//var sy:Float = y / (h * 2);
				//sy = sy * 180;
				//
				//if (sy > 180) {
					//sy = 180;
					//cont.style({y:0, top:-(y-Math.floor(h * 2)) + 'px'});
				//}else {
					//cont.style({y:0, top:0});
				//}
				//
				//Dice.All([head, middle, bottom], function(p:Int, e:IDisplay3D) {
					//e.height(h);
					//e.locationZ(h*.5);
					//e.rotationX(e.data.get('rotation') + sy);
					//e.update();
					//rest.style( { 'margin-top':((h*3)>>0) + 'px' } );
				//});
				//
				//cont.content.locationZ( -h * .5);
				//cont.content.update();
				//
				//
			//});
			//
			//Ticker.init();
			//
		//});
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