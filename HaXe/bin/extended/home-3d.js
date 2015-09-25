/**
 * ...
 * @author Rafael Moreira
 */

(function() {
	
	XCSS.enabled = true;
	
	var Sprite3D = sru.dom.Sprite3D;
	var Display3D = sru.dom.Display3D;
	var Div = sru.dom.Div;
	
	Sirius.init(function(l) {
		
		if (Sirius.agent.screen < 3) return;
		
		var body = Sirius.document.body;
		body.style( { 'overflow-x':'hidden' } );
		
		var cont = new Sprite3D();
		cont.content.fit(100, 100, true);
		cont.overflow('hidden');
		cont.pin();
		
		var head = new Display3D().addTo(cont.content);
		var middle = new Display3D().addTo(cont.content);
		var bottom = new Display3D().addTo(cont.content);
		
		head.background('#006699');
		middle.background('#996600');
		bottom.background('#009900');
		
		cont.width(100, true);
		cont.content.height(100, true);
		cont.addTo();
		
		var rest = new Div();
		rest.width(100, true);
		rest.height(1600);
		rest.background('#CCCCCC');
		rest.addTo();
		
		cont.setPerspective(null, '50% 50%');
		cont.update();
		
		cont.content.height(100, true);
		cont.content.update();
		
		var apperture = 45;
		var maxApperture = apperture * 2;
		
		//var tz = Math.round( ( panelSize / 2 ) / 
		//  Math.tan( ( ( Math.PI * 2 ) / numberOfPanels ) / 2 ) );
		// or simplified to
		//var tz = Math.round( ( panelSize / 2 ) / 
		//  Math.tan( Math.PI / numberOfPanels ) );
		
		Dice.All([head, middle, bottom], function(p, e) {
			e.doubleSided(false);
			e.detach();
			e.style({y:0,top:0});
			e.width(100, true);
			e.data.set('rotation', p * -apperture);
			e.setPerspective(null, '50% 50%');
			e.update();
		});
		
		Ticker.add(function() {
			
			var h = Utils.viewportHeight();
			var h2 = h / 2;
			
			cont.fit(Utils.viewportWidth(), h);
			
			var y = Sirius.document.getScroll().y;
			var sy = y / (h * 2);
			sy = sy * maxApperture;
			
			if (sy > maxApperture) {
				sy = maxApperture;
				cont.style({y:0, top:-(y-Math.floor(h * 2)) + 'px'});
			}else {
				cont.style({y:0, top:0});
			}
			
			Dice.All([head, middle, bottom], function(p, e) {
				e.height(h);
				e.locationZ(h*.5);
				e.rotationX(e.data.get('rotation') + sy);
				e.update();
				rest.style( { 'margin-top':((h*3)>>0) + 'px' } );
			});
			
			cont.content.locationZ( -h * .5);
			cont.content.update();
			
			
		});
		
		Ticker.init();
		
	});
	
})();