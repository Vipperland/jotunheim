/**
 * ...
 * @author Rafael Moreira
 */
(function($exports) {
	$exports.sru = $exports.sru || {};
	$exports.sru.plugins = $exports.sru.plugins || {};
	$exports.sru.plugins.glittermenu = new (function(){
		var int_close = null;
		this.active = false;
		this.scanning = false;
		this.control = false;
		this.open = false;
		this.onClick = null;
		this.options = {
			openDelay:2000,
			closeDelay:2000,
			transition:'all .3s ease-in-out',
			radius: 150,
			transform:true,
		};
		this.onload = function(){
			var origin = null;
			window.onmousedown = function(e){
				GlitterMenu.clearControl();
				GlitterMenu.scanning = true;
				origin = {
					x:e.clientX,
					y:e.clientY,
				};
				GlitterMenu.control = setTimeout(function(){
					if(GlitterMenu.open)
						GlitterMenu.closeMenu();
					else
						GlitterMenu.openMenu();
				}, GlitterMenu.options.openDelay);
			}
			window.onmousemove = function(e){
				if(GlitterMenu.scanning && !GlitterMenu.open){
					var x = origin.x - e.clientX;
					var y = origin.y - e.clientY;
					if(Math.sqrt(x*x + y*y)>50){
						GlitterMenu.clearControl();
					}
				}
			}
			window.onmouseup = function(){
				if(GlitterMenu.scanning && !GlitterMenu.open)
					GlitterMenu.clearControl();
			}
		}
		this.clearControl = function(){
			if(this.control != null) {
				clearTimeout(this.control);
				this.control = null;
			}
		}
		this.openMenu = function(o){
			this.scanning = false;
			this.open = true;
			this.clearControl();
			var item = o || Sirius.one('.glittermenu');
			item.initData();
			if(item.data.exists('gliter')){
				clearInterval(item.data.get('gliter'));
			}
			item.style({
				width: '100%',
				height: '100%',
				position: 'fixed',
				top:0,
				left:0,
				opacity:0,
				visibility:'none',
				overflow:'hidden',
				zIndex:0xFFFFFF,
				pointerEvents:'none',
			});
			var bts = item.all('.item');
			var count = bts.length();
			var i = 0;
			var radius = 360/count;
			bts.each(function(o){
				o.style({
					overflow:'hidden',
					position:'absolute',
					opacity:0,
					zIndex:1,
					transition:'none',
				});
				setTimeout(function(k){
					if(!o.data || !o.data.exists('info')){
						o.initData();
						var bdx = o.getBounds();
						var offset = {x:((bdx.width*.5)>>0),y:((bdx.height*.5)>>0)};
						o.events.click(function(e){
							GlitterMenu.closeMenu(item);
							if(GlitterMenu.onClick != null){
								setTimeout(function(){
									GlitterMenu.onClick(e.target);
								}, 50);
							}
						});
						if(GlitterMenu.options.transform){
							o.style({
								transform:'matrix(1,0,0,1,0,0)',
								zIndex: 1,
							});
							o.events.mouseOver(function(e){
								e.target.style({
									transform:'matrix(1.1,0,0,1.1,0,0)',
									zIndex: 10,
								});
							});
							o.events.mouseOut(function(e){
								e.target.style({
									transform:'matrix(1,0,0,1,0,0)',
									zIndex: 1,
								});
							});
						}
						o.data.set('info', {
							offset:offset,
							index:k,
							from:{
								top:'calc(50% - ' + offset.y + 'px)',
								left:'calc(50% - ' + offset.x + 'px)',
								opacity:0,
								transition:GlitterMenu.options.transition,
							}
						});
					}
					o.style(o.data.get('info').from);
					setTimeout(function(j){
						if(!o.data.exists('info').to){
							var rd = Math.PI/180*(radius*-j-180);
							var tx = (Math.cos(rd) * GlitterMenu.options.radius) >> 0;
							var ty = (Math.sin(rd) * GlitterMenu.options.radius) >> 0;
							var offset = o.data.get('info').offset;
							o.data.get('info').to = {
								top:'calc(50% + ' + tx + 'px - ' + offset.y + 'px)',
								left:'calc(50% + ' + ty + 'px - ' + offset.x + 'px)',
								opacity:1,
							};
						}
						o.style(o.data.get('info').to);
					}, 50 * k, k);
				},20, i++);
			});
			item.show();
			item.data.set('gliter', setTimeout(function(){
				item.style({
					opacity:1,
				});
				item.data.set('gliter', setTimeout(function(){
					item.style({
						pointerEvents:'all',
					});
				},50 * count + 100));
			},10));
		}
		this.closeMenu = function(o){
			if(this.open){
				this.open = false;
				var item = o || Sirius.one('.glittermenu');
				var bts = item.all('.item');
				bts.each(function(o){
					setTimeout(function(){
						o.style(o.data.get('info').from);
					},50*o.data.get('info').index);
				});
				item.style({
					pointerEvents:'none',
				});
				item.data.set('gliter', setTimeout(function(){
					item.style({
						opacity:0,
					});
					item.data.set('gliter', setTimeout(function(){
						item.hide();
						item.style({zIndex:0xFFFFF0});
					}, GlitterMenu.options.closeDelay));
				},bts.length() * 50));
			}
		}
		window.GlitterMenu = this;
	})();
	
	if(Sirius != null) Sirius.updatePlugins();
})(typeof window != "undefined" ? window : exports);