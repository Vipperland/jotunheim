/**
 * Carousel3D Plugin for Jotun API
 * ...
 * @author Rafael Moreira
 */
(function($exports) {
	$exports.jtn = $exports.jtn || {};
	$exports.jtn.plugins = $exports.jtn.plugins || {};
	$exports.jtn.plugins.Carousel3D = function(aperture, zoom, keyboard, addto){
		var Display = jtn.dom.Display;
		function CreateContainer(){
			var c = new Display();
			c.enablePerspective();
			c.content = new Display();
			c.css('Carousel3D no-backface');
			c.content.transform();
			c.addChild(c.content);
			c.style({width:'100%',height:'100%',display:'table'});
			c.content.style({verticalAlign:'middle', display:'table-cell'});
			c.transform();
			return c;
		}
		
		var Div = jtn.dom.Div;
        var body = Jotun.document.body;
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
			snapEasing : .99,
			zoomEasing : .1,
			scroll : 0,
			axys : 'y',
			index : 0,
			focus : 0,
			tilt : 0,
			enabled : true,
			focused : false,
			backface : false,
			clipping : true,
			spacing : 0,
			direction : 1,
			addBySelector : function(q){
				if(q != null && q.length > 0){
					Jotun.all(q).each(o.addPanel);
					o.update();
				}
			},
			setSpacing : function(q){
				this.spacing = q;
			},
			addPanel : function(p){
				var panel = new Display().addTo(o.carousel.content);
				p.style({
					width:'100%',
					height:'100%',
				});
				panel.addChild(p);
				panel.css('Panel3D');
				panel.material = p;
				panel.enablePerspective();
				o.panels[o.panels.length] = panel;
			},
			setBackface: function(q){
				this.carousel.css((q ? '' : '/') + 'no-backface');
				this.backface = q;
			},
			setClipping: function(q){
				this.clipping = q;
			},
			update : function(){
				if(o.aperture < 10) 
					o.aperture = 10;
				else if(o.aperture > 160) 
					o.aperture = 160;
				o.maxAperture = o.aperture * o.panels.length;
				o.maxPanels = 360/o.aperture;
				o.points.splice(0, o.points.length);
				o.snapping = (o.aperture/180) * o.maxSnapping + o.minSnapping;
				if(o.snapping > o.maxSnapping) 
					o.snapping = o.maxSnapping;
				var ap = o.aperture*1.50;
				var hp = o.aperture*.50;
				while(o.points.length < o.panels.length){
					var i = o.points.length * o.aperture;
					var cp = o.panels[o.points.length];
					cp.data = cp.data || {};
					var ctr = cp.data.control || {panel:cp,focus:false,pin:false,id:o.points.length,point:0};
					ctr.a = i-o.snapping;
					ctr.b = i+o.snapping;
					ctr.c = i;
					ctr.d = i-ap;
					ctr.e = i+ap;
					ctr.f = i-hp;
					ctr.g = i+hp;
					cp.style({
						y:0,
						top:0,
						position:'absolute',
						width:'100%'
					});
					cp.data.rotation = o.points.length * -o.aperture;
					//cp.enablePerspective();
					cp.transform();
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
			setTilt : function(z){
				if(z != null){
					o.tilt = z;
				}
				return o.tilt;
			},
			setHorizontal:function(){
				o.toggleAxys('x');
			},
			setVertical:function(){
				o.toggleAxys('y');
			},
			toggleAxys : function(x){
				if(x != null){
					o.axys = x;
				}else{
					o.axys = o.axys == 'x' ? 'y' : 'x';
				}
				return o.axys;
			},
			showPanel : function(i){
				Jotun.document.scroll(0,i*Utils.viewportHeight());
			},
			prevPanel : function(){
				if(o.index > 0) 
					o.showPanel(o.index - 1);
			},
			nextPanel : function(){
				if(o.index <= o.panels.length) 
					o.showPanel(o.index + 1);
			},
			on : function(n,h,m){
				m = m ? -1 : 1;
				Dice.Values(o.panels, function(v){
					v.on(n,h,m); 
				});
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
				if(!o.enabled)
					return;
				var disp = o.carousel.parent();
				var h = Utils.viewportHeight();
				var h2 = ((o.axys == 'x' ? disp.width() : h) / 2);
				var tz = h2 / Math.tan(Math.PI/o.maxPanels) + o.spacing;
				var y = Jotun.document.getScroll().y;
				var sy = y / (h * o.panels.length) * o.maxAperture;
				for(j in o.points){
					var k = o.points[j];
					if(sy > k.f && sy < k.g){
						if(k.focus == false){
							k.focus = true;
							if(k.pin == true) {
								k.pin = false;
								k.panel.css('focused /pinned /inactive');
								k.panel.events.on('carouselPinOut').call();
							}
							k.panel.css('focused /pinned /inactive');
							k.panel.events.on('carouselFocusIn').call();
							o.focus = j * 1;
						}
					}else{
						if(k.focus == true){
							k.focus = false;
							k.panel.css('/focused /pinned inactive');
							k.panel.events.on('carouselFocusOut').call();
						}
					}
					if(k.focus){
						if(sy > k.a && sy < k.b){
							sy = k.c;
							if(k.pin == false) {
								o.pinDelay = 4;
								k.pin = true;
								k.panel.css('focused pinned /inactive');
								k.panel.events.on('carouselPinIn').call();
								o.index = j * 1;
							}else{
								--o.pinDelay;
								if(o.pinDelay == 0){
									o.offsetZ = 0;
								}
							}
						}else{
							if(k.pin == true) {
								k.pin = false;
								k.panel.css('focused /pinned /inactive');
								k.panel.events.on('carouselPinOut').call();
								o.offsetZ = o.zoom;
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
					if(o.clipping && (o.scroll < ctr.d || o.scroll > ctr.e)){
						e.hide();
					}else{
						e.show();
					}
					e.height(h);
					
					var tA = (e.data.rotation + o.scroll);
					e.data.point = tA;
					if(o.axys == 'x'){
						e.rotate(
							o.tilt != 0 ? tA * o.tilt : 0,
							tA * o.direction,
							0
						);
						e.translate(
							0, 
							0,
							tz
						);
					}else{
						e.rotate(
							tA * o.direction,
							o.tilt != 0 ? tA * o.tilt : 0,
							0
						);
						e.translate(
							0,
							0, 
							tz
						);
					}
					e.transform();
				});
				
				var th = (h*(o.panels.length))>>0;
				
				if(disp != null){
					disp.style( { 'height':th + 'px' } );
					o.carousel.content.translate(0,0, -tz - o.offsetZFlex);
					o.carousel.content.transform();
					o.carousel.height(h);
				}
				
			},
			scrollEvent : function(e){
				if(Jotun.document.focus().is(['input','select','textarea'])) return;
				if(e.event.type == 'wheel')	{
					var delta = 0;
					if(Jotun.agent.firefox){
						delta = e.event.deltaY * -40;
					} else {
						delta = e.event.wheelDelta;
					}
					Jotun.document.addScroll(0, -delta);
				}else if(o.keyboard) {
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
		
		if(!Jotun.agent.mobile){
			Jotun.document.events.wheel(o.scrollEvent);
			Jotun.document.events.keyDown(o.scrollEvent);
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
		o.carousel.enablePerspective();
		o.carousel.transform();
		o.carousel.content.height("100%");
		o.carousel.content.transform();
		o.carousel.style({width:'100%', top:0, height:0, marginBottom:0});
		
		if(addto != null && addto.length > 0){
			var cont = Jotun.one(addto);
			if(cont != null){
				cont.addChild(o.carousel);
			}
		}
		
		XCode.css.add('.Panel3D.pinned.focused{z-index:100000;}');
		XCode.css.add('.Panel3D.focused{z-index:10000;}');
		XCode.css.add('.Panel3D.inactive{z-index:1000;}');
		XCode.css.add('.Carousel3D.no-backface .Panel3D{backface-visibility: hidden;}');
		XCode.css.build();
		
		Ticker.add(o.render);
		Ticker.start();
		return o;
		
	}
	if(Jotun != null) {
		Jotun.updatePlugins();
	}
})(typeof window != "undefined" ? window : exports);