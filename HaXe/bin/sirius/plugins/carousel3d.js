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
			aperture : 180 - ((aperture) || 90),
			zoom : zoom || 0,
			easing : .3,
			snapping : 0,
			minSnapping : 2,
			maxSnapping : 16,
			snapEasing : .9,
			zoomEasing : .1,
			scroll : 0,
			axys : 'y',
			index : 0,
			focus : 0,
			enabled : true,
			focused : false,
			spacing : 0,
			direction : 1,
			addPanel : function(p){
				var panel = new Display3D().addTo(o.carousel.content);
				panel.addChild(p);
				panel.mainFace = p;
				o.panels[o.panels.length] = panel;
			},
			update : function(){
				if(o.aperture < 20) o.aperture = 20;
				else if(o.aperture > 160) o.aperture = 160;
				o.maxAperture = o.aperture * o.panels.length;
				o.maxPanels = 360/o.aperture;
				o.points.splice(0, o.points.length);
				o.snapping = (o.aperture/180) * o.maxSnapping + o.minSnapping;
				if(o.snapping > o.maxSnapping) o.snapping = o.maxSnapping;
				var ap = o.aperture*1.25;
				var hp = o.aperture*.5;
				while(o.points.length < o.panels.length){
					var i = o.points.length * o.aperture;
					var cp = o.panels[o.points.length];
					var ctr = cp.data.control || {panel:cp,focus:false,pin:false,id:o.points.length};
					ctr.a = i-o.snapping;
					ctr.b = i+o.snapping;
					ctr.c = i;
					ctr.d = i-ap;
					ctr.e = i+ap;
					ctr.f = i-hp;
					ctr.g = i+hp;
					cp.doubleSided(false);
					cp.css('pos-abs');
					cp.style({y:0,top:0});
					cp.width("100%");
					cp.data.set('rotation', o.points.length * -o.aperture);
					cp.setPerspective(null, '50% 50%');
					cp.update();
					cp.data.control = ctr;
					o.points[o.points.length] = ctr;
				}
			},
			setAperture : function(x){
				o.aperture = 180-x;
				o.update();
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
				var tz = h2/Math.tan(Math.PI/o.maxPanels) + o.spacing;
				var y = Sirius.document.getScroll().y;
				var sy = y / (h * o.panels.length);
				sy = sy * o.maxAperture;
				o.offsetZ = o.zoom;
				for(j in o.points){
					var k = o.points[j];
					if(sy > k.f && sy < k.g){
						if(k.focus == false){
							k.focus = true;
							if(k.pin == true) {
								k.pin = false;
								k.panel.events.auto('carouselPinOut').call();
							}
							k.panel.events.auto('carouselFocusIn').call();
							o.focus = j * 1;
						}
					}else{
						if(k.focus == true){
							k.focus = false;
							k.panel.events.auto('carouselFocusOut').call();
						}
					}
					if(k.focus){
						if(sy > k.a && sy < k.b){
							sy = k.c;
							o.offsetZ = 0;
							if(k.pin == false) {
								k.pin = true;
								k.panel.events.auto('carouselPinIn').call();
								o.index = j * 1;
							}
						}else{
							if(k.pin == true) {
								k.pin = false;
								k.panel.events.auto('carouselPinOut').call();
							}
						}
					}
				}
				if(o.zoom != 0){
					if(!o.focused && o.offsetZ == 0){
						o.focused = true;
						o.carousel.events.auto('carouselZoomIn').call();
					}else if(o.focused && o.offsetZ == o.zoom){
						o.focused = false;
						o.carousel.events.auto('carouselZoomOut').call();
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
						e.rotationY(-(e.data.get('rotation') + o.scroll) * o.direction);
						e.rotationX(0);
					}else{
						e.rotationX(e.data.get('rotation') + o.scroll * o.direction);
						e.rotationY(0);
					}
					e.update();
				});
				var th = (h*o.panels.length)>>0;
				o.extra.style( { 'margin-top':th + 'px' } );
				o.carousel.content.locationZ( -tz - o.offsetZFlex);
				o.carousel.content.update();
				o.carousel.height(h);
			},
			scrollEvent : function(e){
				if(Sirius.document.focus().is(['input','select','textarea'])) return;
				if(e.event.type == 'wheel')	{
					var delta = 0;
					if(Sirius.agent.firefox) 	delta = e.event.deltaY * -40;
					else						delta = e.event.wheelDelta
					Sirius.document.addScroll(0, -delta);
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
        o.carousel.css('pos-fix');
        o.carousel.width("100%");
        o.carousel.content.height("100%");
        o.carousel.addToBody();
		o.carousel.setPerspective(null, '50% 50%');
        o.carousel.update();
        o.extra.width("100%");
        o.extra.style({top:0});
        o.extra.addToBody();
        o.carousel.content.height("100%");
        o.carousel.content.update();
		Sirius.all(selector).each(o.addPanel);
		o.update();
		Ticker.add(o.render);
		Ticker.init();
		return o;
		
	}
	if(Sirius != null) Sirius.updatePlugins();
})(typeof window != "undefined" ? window : exports);