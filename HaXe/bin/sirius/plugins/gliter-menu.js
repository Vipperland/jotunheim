/**
 * ...
 * @author Rafael Moreira
 */
(function($exports) {
	$exports.sru = $exports.sru || {};
	$exports.sru.plugins = $exports.sru.plugins || {};
	$exports.sru.plugins.GliterMenu = new (function(){
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
			var item = Sirius.one('.glitermenu');
			var origin = null;
			window.onmousedown = function(e){
				GliterMenu.clearControl();
				GliterMenu.scanning = true;
				origin = {
					x:e.clientX,
					y:e.clientY,
				};
				GliterMenu.control = setTimeout(function(){
					if(GliterMenu.open)
						GliterMenu.closeMenu();
					else
						GliterMenu.openMenu();
				}, GliterMenu.options.openDelay);
			}
			window.onmousemove = function(e){
				if(GliterMenu.scanning){
					var x = origin.x - e.clientX;
					var y = origin.y - e.clientY;
					if(Math.sqrt(x*x + y*y)>50){
						GliterMenu.clearControl();
					}
				}
			}
			window.onmouseup = function(){
				if(GliterMenu.scanning)
					GliterMenu.clearControl();
			}
		}
		this.preventClosing = function(){
			if(int_close != null) {
				clearTimeout(int_close);
				int_close = null;
			}
		}
		this.clearControl = function(){
			if(this.control != null) {
				clearTimeout(this.control);
				this.control = null;
			}
		}
		this.openMenu = function(){
			this.preventClosing();
			this.scanning = false;
			this.clearControl();
			this.open = true;
			var item = Sirius.one('.glitermenu');
			item.style({
				width: '100%',
				height: '100%',
				position: 'fixed',
				top:0,
				left:0,
				opacity:0,
				visibility:'none',
				overflow:'hidden',
				pointerEvents:'all',
				zIndex:0xFFFFFF,
				pointerEvents:'all',
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
							GliterMenu.closeMenu();
							if(GliterMenu.onClick != null){
								setTimeout(function(){
									GliterMenu.onClick(e.target);
								}, 100);
							}
						});
						if(GliterMenu.options.transform){
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
								transition:GliterMenu.options.transition,
							}
						});
					}
					o.style(o.data.get('info').from);
					setTimeout(function(j){
						if(!o.data.exists('info').to){
							var rd = Math.PI/180*(radius*-j-180);
							var tx = (Math.cos(rd) * GliterMenu.options.radius) >> 0;
							var ty = (Math.sin(rd) * GliterMenu.options.radius) >> 0;
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
			setTimeout(function(){
				item.style({
					opacity:1,
				});
			},10);
		}
		this.closeMenu = function(){
			if(this.open){
				this.open = false;
				var item = Sirius.one('.glitermenu');
				var bts = item.all('.item');
				bts.each(function(o){
					setTimeout(function(){
						o.style(o.data.get('info').from);
					},50*o.data.get('info').index);
				});
				setTimeout(function(){
					item.style({
						opacity:0,
						pointerEvents:'none',
					});
					setTimeout(function(){
						item.hide();
						item.style({zIndex:0xFFFFFE});
					}, GliterMenu.options.closeDelay);
				},bts.length() * 50);
			}
		}
		window.GliterMenu = this;
	})();
	
	if(Sirius != null) Sirius.updatePlugins();
})(typeof window != "undefined" ? window : exports);