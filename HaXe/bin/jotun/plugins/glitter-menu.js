/**
 * ...
 * @author Rafael Moreira
	
	Attribute options:
		glitter-mode				Set dial type, can be "horizontal", "vertical" or "radial". Default is "radial"
		glitter-multiple			Allow multiple selection
		glitter-autoclose			Close after interaction (if not multiple)
		glitter-size				Size of dial options (width*height). Default is "auto"
		glitter-target				Write the menu selected values array in the target.
		glitter-time				Animation delay between options. Default is "30"
		glitter-transition			CSS transition to be applied. Default is "all .3s ease-in-out"
		
		If radial mode:
			glitter-fov				Set max angular distribution. Default if "360"
			glitter-angle			Change the starting angle by an ammount. Default is "0"
			glitter-grow			Add empty points in the dial menu. Default id "0"
	
 */
(function($exports) {
	$exports.GlitterMenu = new (function(){
		var _glitterTimer = null;
		var _layer = new J_dom_Div();
		var _activity = false;
		function _toggleLayer(){
			clearTimeout(_glitterTimer);
			if(!_activity){
				_layer.style({
					pointerEvents:'none',
					opacity:0
				});
				_glitterTimer = setTimeout(function(){
					_layer.hide();
				},500);
			}else{
				_layer.show();
				_layer.style({
					pointerEvents:'all',
					opacity:1
				});
			}
		}
		this.active = false;
		this.scanning = false;
		this.control = false;
		this.onClick = null;
		this.getMenu = function(obj){
			if(typeof obj == "string")
				obj = Jotun.one(obj);
			return obj || Jotun.one('.glittermenu');
		}
		this.openMenu = function(menu, handler){
			clearTimeout(_glitterTimer);
			this.scanning = false;
			var item = this.getMenu(menu);
			item.glitterOptions = {
				mode:item.attribute('glitter-mode') || "radial", 
				dimension:(item.attribute('glitter-size') || "auto").split('*'), 
				startAngle: (parseInt(item.attribute('glitter-angle')) || 0), 
				maxAngle:(parseInt(item.attribute('glitter-fov')) || 360), 
				grow:(parseInt(item.attribute('glitter-grow')) || 0), 
				autoSize:!item.hasAttribute('glitter-size') || item.attribute('glitter-size') == 'auto', 
				multiple:item.attribute('glitter-multiple') == 'true', 
				target:item.attribute('glitter-target'),
				transition:item.attribute('glitter-transition') || 'all .3s ease-in-out',
				time:parseInt(item.attribute('glitter-time')) || 30,
				root:item,
				autoClose:item.attribute('glitter-autoclose')=='true',
			}
			if(item.data._glitterTime){
				clearInterval(item.data._glitterTime);
				delete item.data._glitterTime;
			}
			item.style({
				width: '100vw',
				height: '100vh',
				position: 'fixed',
				top:0,
				left:0,
				visibility:'none',
				overflow:'hidden',
				zIndex:0xFFFFFF,
				pointerEvents:'none',
			});
			var bts = item.all('.item');
			var count = bts.length() + item.glitterOptions.grow;
			var i = 0;
			var maxAngle = item.glitterOptions.maxAngle;
			if(maxAngle > 360){
				maxAngle = 360;
			}else if(maxAngle < 1){
				maxAngle = 1;
			}
			var radius = maxAngle/count;
			bts.each(function(o){
				o.glitterOptions = item.glitterOptions;
				o.disable();
				o.style({
					overflow:'hidden',
					position:'absolute',
					opacity:0,
					zIndex:1,
					transition:'none',
				});
				setTimeout(function(k){
					if(!o.glitterData){
						var bdx = o.getBounds();
						var offset = {
							x:((bdx.width*.5)>>0),
							y:((bdx.height*.5)>>0)
						};
						o.events.click(function(e){
							var target = e.target;
							var menu = target.glitterOptions.root;
							if(target.hasAttribute('value') || target.hasAttribute('glitter-select')){
								var values = [];
								var cval = o.attribute('glitter-select');
								if(cval == 'all'){
									GlitterMenu.selectAll(menu);
								}else if(cval == 'none'){
									GlitterMenu.deselectAll(menu);
								}else if(cval){
									GlitterMenu.selectBy(cval, menu);
								}else{
									if(!target.glitterOptions.multiple){
										GlitterMenu.deselectAll(menu);
									}
									var cur = target.attribute('selected') == "true";
									target.attribute('selected', !cur);
									target.css((cur ? '/' : '') + 'active');
								}
								var values = GlitterMenu.getData(menu);
								if(target.glitterOptions.target != null){
									values = values.join(', ');
									var tg = Jotun.one(target.glitterOptions.target);
									if(tg != null){
										if(tg.is('input')){
											tg.value(values);
										}else{
											tg.writeHtml(values);
										}
									}
								}
								if(target.glitterOptions.autoClose && !target.glitterOptions.multiple){
									GlitterMenu.closeMenu(menu);
								}
								if(GlitterMenu.onClick != null){
									setTimeout(function(){
										GlitterMenu.onClick(e.target, values);
									}, 50);
								}
							}
							if(o.hasAttribute('glitter-open')){
								GlitterMenu.closeMenu(menu);
								GlitterMenu.openMenu(o.attribute('glitter-open'));
							}else if(o.hasAttribute('glitter-close')){
								GlitterMenu.closeMenu(menu);
							}
							
						});
						o.glitterData = {
							offset:offset,
							index:k,
							from:{
								opacity:0,
								transition:o.glitterOptions.transition,
							}
						};
					}
					var pos = o.glitterData.from;
					var offset = o.glitterData.offset;
					pos.top = (Jotun.document.cursorY() - offset.y) + 'px';
					pos.left = (Jotun.document.cursorX() - offset.x) + 'px';
					o.style(o.glitterData.from);
					setTimeout(function(j){
						if(!o.glitterData.to){
							var rd = Math.PI/180*(radius*j-o.glitterOptions.startAngle);
							var tx = Math.cos(rd);
							var ty = Math.sin(rd);
							var offset = o.glitterData.offset;
							var aRad = o.glitterOptions.autoSize;
							var decay = 360/item.glitterOptions.maxAngle;
							var dx = 0;
							var dy = 0;
							if(aRad){
								dx = Math.round((offset.x)/Math.tan(Math.PI/count));
								dy = Math.round((offset.y)/Math.tan(Math.PI/count));
							}else{
								dx = parseInt(o.glitterOptions.dimension[0]);
								dy = parseInt(o.glitterOptions.dimension[1]);
							}
							var mx = J_Utils.viewportWidth() >> 1;
							var my = J_Utils.viewportHeight() >> 1;
							
							tx = (tx * (offset.x + dx) * decay) >> 0;
							ty = (ty * (offset.y + dy) * decay) >> 0;
							
							o.glitterData.to = {
								top:'calc(50% + ' + ty + 'px - ' + offset.y + 'px)',
								left:'calc(50% + ' + tx + 'px - ' + offset.x + 'px)',
								opacity:1,
							};
						}
						o.enable();
						o.style(o.glitterData.to);
					}, o.glitterOptions.time * k, k);
				},20, i++);
			});
			if(handler != null){
				this.onClick = handler;
			}
			item.show();
			item.style({
				pointerEvents:'all',
				zIndex:0xFFFFFF,
			});
			_activity = true;
			_toggleLayer();
		}
		this.getData = function(menu){
			var values = [];
			if(typeof(menu) == "string"){
				menu = this.getMenu(menu);
			}
			menu.all('.item[selected="true"]').each(function(o){
				values.push(o.attribute('value'));
			});
			return values;
		}
		this.deselectAll = function(menu){
			this.toggleSelection(false, menu);
		}
		this.selectAll = function(menu){
			this.toggleSelection(true, menu);
		}
		this.toggleSelection = function(value, menu, selector){
			this.getMenu(menu).all(selector || '.item[value]').each(function(o){
				o.attribute('selected', value);
				o.css((value ? '' : '/') + 'active');
			});
		}
		this.selectBy = function(value, menu){
			this.deselectAll();
			this.toggleSelection(true, menu, value);
		}
		this.closeMenu = function(menu){
			var item = this.getMenu(menu);
			var bts = item.all('.item');
			clearTimeout(item.glitterHx);
			_activity = false;
			bts.each(function(o){
				var pos = o.glitterData.from;
				var offset = o.glitterData.offset;
				//if(target.glitterOptions.target){
				//}else{
					pos.top = (Jotun.document.cursorY() - offset.y) + 'px';
					pos.left = (Jotun.document.cursorX() - offset.x) + 'px';
				//}
				setTimeout(function(){
					o.style(o.glitterData.from);
				},o.glitterOptions.time*o.glitterData.index);
			});
			item.style({
				pointerEvents:'none',
			});
			item.glitterHx = setTimeout(function(){
				item.hide();
				item.style({zIndex:0xFFFFF0});
				_layer.style({
					opacity: 0,
				});
				_toggleLayer();
			}, bts.length() * item.glitterOptions.time + 100);
		}
		_layer.hide();
		_layer.style({
			opacity:0,
			backgroundColor:'rgba(0,0,0,.7)',
			position:'fixed',
			width:'100%',
			height:'100%',
			zIndex: 0xFFFFF4,
			top:0,
			bottom:0,
			transition:'opacity .3s ease-in-out',
		});
		Jotun.run(function(){
			Jotun.document.body.addChild(_layer);
		});
		Jotun.document.trackCursor();
		window.GlitterMenu = this;
	})();
})(typeof window != "undefined" ? window : exports);