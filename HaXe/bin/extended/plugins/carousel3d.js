/**
 * ...
 * @author Rafael Moreira
 */

(function($exports) {
	
	$exports.sru = $exports.sru || {};
	$exports.sru.plugins = $exports.sru.plugins || {};
	
	$exports.sru.plugins.Carousel3D = function(selector, aperture, zoom){
		
		var Display3D = sru.dom.Display3D;
		var Sprite3D = sru.dom.Sprite3D;
		var Div = sru.dom.Div;
		
		if (Sirius.agent.screen < 3 || (Sirius.agent.ie > 0 && Sirius.agent.ie < 12)) return;
		
        var body = Sirius.document.body;
		body.style( { 'overflow-x':'hidden' } );
		
		var o = {
			panels : [],
			points : [],
			extra : new Div(),
			carousel : new Sprite3D(),
			maxAperture : 0,
			maxPanels : 0,
			offsetZ : 0,
			offsetZFlex : 0,
			aperture : aperture || 45,
			zoom : zoom || 0,
			easing : .3,
			snapping : 5,
			snapEasing : .9,
			zoomEasing : .1,
			scroll : 0,
			axys : 'y',
			index : 0,
			enabled : true,
			addPanel : function(p){
				var panel = new Display3D().addTo(o.carousel.content);
				panel.addChild(p);
				o.panels[o.panels.length] = panel;
			},
			update : function(){
				if(o.aperture < 20) o.aperture = 20;
				else if(o.aperture > 160) o.aperture = 160;
				o.maxAperture = o.aperture * o.panels.length;
				o.maxPanels = 360/o.aperture;
				o.points.splice(0, o.points.length);
				var ap = o.aperture*1.5;
				var hp = o.aperture*.5;
				while(o.points.length < o.panels.length){
					var i = o.points.length * o.aperture;
					var cp = o.panels[o.points.length];
					var ctr = {
						a:i-o.snapping,
						b:i+o.snapping,
						c:i,
						d:i-ap,
						e:i+ap,
						panel:cp,
						focus:false
					};
					cp.doubleSided(false);
					cp.detach();
					cp.style({y:0,top:0});
					cp.width(100, true);
					cp.data.set('rotation', o.points.length * -o.aperture);
					cp.setPerspective(null, '50% 50%');
					cp.update();
					cp.data.control = ctr;
					o.points[o.points.length] = ctr;
				}
			},
			toggleAxys : function(x){
				if(x != null) 	o.axys = x;
				else 			o.axys = o.axys == 'x' ? 'y' : 'x';
			},
			showPanel : function(i){
				Sirius.document.scroll(0,i*Utils.viewportHeight());
			},
			prevPanel : function(){
				if(o.index > 0) o.showPanel(o.index - 1);
			},
			nextPanel : function(){
				if(o.index < o.panels.length) o.showPanel(o.index + 1);
			},
			render : function() {
				if(!o.enabled) return;
				var h = Utils.viewportHeight();
				var h2 = (o.axys == 'x' ? Utils.viewportWidth() : h) / 2;
				var tz = h2/Math.tan(Math.PI/o.maxPanels);
				var y = Sirius.document.getScroll().y;
				var sy = y / (h * o.panels.length);
				sy = sy * o.maxAperture;
				o.offsetZ = o.zoom;
				for(j in o.points){
					var k = o.points[j];
					if(sy > k.a && sy < k.b){
						sy = k.c;
						o.offsetZ = 0;
						if(k.focus == false) {
							k.focus = true;
							k.panel.events.auto('carouselFocusIn').call();
						}
					}else{
						if(k.focus == true){
							k.focus = false;
							k.panel.events.auto('carouselFocusOut').call();
						}
					}
				}
				o.offsetZFlex += (o.offsetZ - o.offsetZFlex) * .1;
				if (sy > o.maxAperture) {
					sy = o.maxAperture;
					o.carousel.style({y:0, top:-(y-Math.floor(h * 2)) + 'px'});
					o.scroll += (sy - o.scroll) * o.snapEasing;
				}else {
					o.carousel.style({y:0, top:0});
					o.scroll += (sy - o.scroll) * o.easing;
				}
				o.index = Math.round((o.scroll/o.maxAperture)*o.panels.length);
				Dice.All(o.panels, function(p, e) {
					ctr = e.data.control;
					if(o.scroll < ctr.d || o.scroll > ctr.e){
						e.hide();
						return;
					}else{
						e.show();
					}
					e.height(h);
					e.locationZ(tz);
					if(o.axys == 'x'){
						e.rotationY(-(e.data.get('rotation') + o.scroll));
						e.rotationX(0);
					}else{
						e.rotationX(e.data.get('rotation') + o.scroll);
						e.rotationY(0);
					}
					e.update();
				});
				o.extra.style( { 'margin-top':((h*o.panels.length)>>0) + 'px' } );
				o.carousel.content.locationZ( -tz - o.offsetZFlex);
				o.carousel.content.update();
			},
			scrollEvent : function(e){
				if(Sirius.document.focus().is(['input','select','textarea'])) return;
				if(e.event.type == 'wheel')	{
					Sirius.document.addScroll(0, -e.event.wheelDelta);
				}else{
					switch(e.event.keyCode){
						case 38 : {}
						case 33 : {
							o.prevPanel();
							break;
						}
						case 40 : {}
						case 34 : {
							o.nextPanel();
							break;
						}
					}
				}
			}
		}
		
		if(!Sirius.agent.mobile){
			body.style( { 'overflow-y':'hidden' } );
			Sirius.document.events.wheel(o.scrollEvent);
			Sirius.document.events.keyDown(o.scrollEvent);
		}
		
		o.carousel.content.fit(100, 100, true);
        o.carousel.overflow('hidden');
        o.carousel.pin();
        o.carousel.width(100, true);
        o.carousel.content.height(100, true);
        o.carousel.addToBody();
		o.carousel.setPerspective(null, '50% 50%');
        o.carousel.update();
        o.extra.width(100, true);
        o.extra.style({top:0});
        o.extra.addToBody();
        o.carousel.content.height(100, true);
        o.carousel.content.update();
		
		Sirius.all(selector).each(o.addPanel);
		
		o.update();
		
		Ticker.add(o.render);
		Ticker.init();
		
		return o;
	}
})(typeof window != "undefined" ? window : exports);