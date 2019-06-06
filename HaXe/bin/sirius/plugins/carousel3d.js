/**
 * Carousel3D Plugin for Sirius API
 * ...
 * @author Rafael Moreira
 */
(function($exports) {
	$exports.sru = $exports.sru || {};
	$exports.sru.plugins = $exports.sru.plugins || {};
	$exports.sru.plugins.Carousel3D = function(aperture, zoom, keyboard, addto){
		var Display3D = sru.dom.Display3D;
		
		function CreateContainer(){
			var c = new Display3D();
			c.setPerspective("1000px");
			c.content = new Display3D()
			c.css('Carousel3D');
			c.content.preserve3d().update();
			c.addChild(c.content);
			c.style({width:'100%',height:'100%',display:'table'});
			c.content.style({verticalAlign:'middle', display:'table-cell'});
			c.update();
			return c;
		}
		
		var Div = sru.dom.Div;
        var body = Sirius.document.body;
		var o = {
			panels : [],
			points : [],
			carousel : CreateContainer(),
			keyboard : keyboard == null ? true : keyboard,
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
			addBySelector : function(q){
				if(q != null && q.length > 0){
					Sirius.all(q).each(o.addPanel);
					o.update();
				}
			},
			addPanel : function(p){
				var panel = new Display3D().addTo(o.carousel.content);
				p.style({
					width:'100%',
					height:'100%',
				});
				panel.addChild(p);
				panel.preserve3d();
				panel.mainFace = p;
				o.panels[o.panels.length] = panel;
			},
			update : function(){
				if(o.aperture < 10) o.aperture = 10;
				else if(o.aperture > 160) o.aperture = 160;
				o.maxAperture = o.aperture * o.panels.length;
				o.maxPanels = 360/o.aperture;
				o.points.splice(0, o.points.length);
				o.snapping = (o.aperture/180) * o.maxSnapping + o.minSnapping;
				if(o.snapping > o.maxSnapping) o.snapping = o.maxSnapping;
				var ap = o.aperture*1.50;
				var hp = o.aperture*.50;
				while(o.points.length < o.panels.length){
					var i = o.points.length * o.aperture;
					var cp = o.panels[o.points.length];
					cp.data = cp.data || {};
					var ctr = cp.data.control || {panel:cp,focus:false,pin:false,id:o.points.length};
					ctr.a = i-o.snapping;
					ctr.b = i+o.snapping;
					ctr.c = i;
					ctr.d = i-ap;
					ctr.e = i+ap;
					ctr.f = i-hp;
					ctr.g = i+hp;
					cp.doubleSided(false);
					cp.style({y:0,top:0,position:'absolute',width:'100%'});
					cp.data.rotation = o.points.length * -o.aperture;
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
			setZoom : function(x){
				o.zoom = x;
			},
			setHorizontal:function(){
				o.toggleAxys('x');
			},
			setVertical:function(){
				o.toggleAxys('y');
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
				if(o.index <= o.panels.length) o.showPanel(o.index + 1);
			},
			on : function(n,h,m){
				m = m ? -1 : 1;
				Dice.Values(o.panels, function(v){ v.on(n,h,m); });
			},
			onPinIn : function(h,m){
				o.on('carouselPinIn',h,m);
			},
			onPinOut : function(h,m){
				o.on('carouselPinOut',h,m);
			},
			onFocusIn : function(h,m){
				o.on('carouselFocusIn',h,m);
			},
			onFocusOut : function(h,m){
				o.on('carouselFocusOut',h,m);
			},
			onZoomIn : function(h,m){
				o.carousel.events.on('carouselZoomIn',h,m ? -1 : 1);
			},
			onZoomOut : function(h,m){
				o.carousel.events.on('carouselZoomOut',h,m ? -1 : 1);
			},
			render : function() {
				if(!o.enabled) {
					return;
				}
				var disp = o.carousel.parent();
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
								k.panel.css('focused /pinned /active');
								k.panel.events.on('carouselPinOut').call();
							}
							k.panel.css('focused /pinned /active');
							k.panel.events.on('carouselFocusIn').call();
							o.focus = j * 1;
						}
					}else{
						if(k.focus == true){
							k.focus = false;
							k.panel.css('/focused /pinned /active');
							k.panel.events.on('carouselFocusOut').call();
						}
					}
					if(k.focus){
						if(sy > k.a && sy < k.b){
							sy = k.c;
							o.offsetZ = 0;
							if(k.pin == false) {
								k.pin = true;
								k.panel.css('focused pinned active');
								k.panel.events.on('carouselPinIn').call();
								o.index = j * 1;
							}
						}else{
							if(k.pin == true) {
								k.pin = false;
								k.panel.css('focused /pinned /active');
								k.panel.events.on('carouselPinOut').call();
							}
						}
					}
				}
				if(!o.focused && o.offsetZ == 0){
					o.focused = true;
					o.carousel.events.on('carouselZoomIn').call();
				}else if(o.focused && o.offsetZ != 0){
					o.focused = false;
					o.carousel.events.on('carouselZoomOut').call();
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
						e.rotationY(-(e.data.rotation + o.scroll) * o.direction);
						e.rotationX(0);
					}else{
						e.rotationX(e.data.rotation + o.scroll * o.direction);
						e.rotationY(0);
					}
					e.update();
				});
				var th = (h*(o.panels.length))>>0;
				
				if(disp != null){
					disp.style( { 'height':th + 'px' } );
					o.carousel.content.locationZ( -tz - o.offsetZFlex);
					o.carousel.content.update();
					o.carousel.height(h);
				}
				
			},
			scrollEvent : function(e){
				if(Sirius.document.focus().is(['input','select','textarea'])) return;
				if(e.event.type == 'wheel')	{
					var delta = 0;
					if(Sirius.agent.firefox) 	delta = e.event.deltaY * -40;
					else						delta = e.event.wheelDelta;
					Sirius.document.addScroll(0, -delta);
				}else if(o.keyboard) {
					console.log(e.event.keyCode);
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
			},
			
		}
		
		if(!Sirius.agent.mobile){
			Sirius.document.events.wheel(o.scrollEvent);
			Sirius.document.events.keyDown(o.scrollEvent);
		}
		o.carousel.content.fit(100, 100, true);
		o.carousel.style({
			position:'fixed',
			width:'100%',
			overflow:'hidden',
		});
		o.carousel.content.style({
			width:'100%',
			height:'100%',
		});
		o.carousel.addToBody();
		o.carousel.setPerspective(null, '50% 50%');
		o.carousel.update();
		o.carousel.content.height("100%");
		o.carousel.content.update();
		o.carousel.style({width:'100%', top:0, height:0, marginBottom:0});
		
		if(addto != null && addto.length > 0){
			var cont = Sirius.one(addto);
			if(cont != null){
				cont.addChild(o.carousel);
			}
		}
		
		Ticker.add(o.render);
		Ticker.start();
		return o;
		
	}
	if(Sirius != null) {
		Sirius.updatePlugins();
	}
})(typeof window != "undefined" ? window : exports);