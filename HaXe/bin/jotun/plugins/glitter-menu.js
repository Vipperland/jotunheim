/**
 * ...
 * @author Rafael Moreira
 */
(function($exports) {
	$exports.jtn = $exports.jtn || {};
	$exports.jtn.plugins = $exports.jtn.plugins || {};
	$exports.jtn.plugins.GlitterMenu = new (function(){
		var _glitterTimer = null;
		var _layer = new jtn.dom.Div();
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
			item.data=new jtn.data.DataSet();
			item.glitterOptions = {
				dimension:(item.attribute('glitter-size') || "150*150").split('*'), 
				startAngle:180 + (parseInt(item.attribute('glitter-angle')) || 0), 
				maxAngle:(parseInt(item.attribute('glitter-fov')) || 360), 
				grow:(parseInt(item.attribute('glitter-grow')) || 0), 
				autoSize:item.attribute('glitter-size') == 'auto', 
				multiple:item.attribute('glitter-multiple') == 'true', 
				target:item.attribute('glitter-target'),
				transition:item.attribute('glitter-transition') || 'all .3s ease-in-out',
				time:parseInt(item.attribute('glitter-time')) || 30,
				root:item,
				autoClose:item.attribute('glitter-autoclose')=='true',
			}
			if(item.data.exists('gliter')){
				clearInterval(item.data.get('gliter'));
			}
			item.style({
				width: '100%',
				height: '100%',
				position: 'fixed',
				top:0,
				left:0,
				visibility:'none',
				overflow:'hidden',
				zIndex:0xFFFFFF,
				pointerEvents:'none',
			});
			var bts = item.all('.item');
			var count = item.glitterOptions.grow || bts.length();
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
						var offset = {x:((bdx.width*.5)>>0),y:((bdx.height*.5)>>0)};
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
										menu.all('.item[value]').attribute('selected',false);
									}
									var cur = target.attribute('selected') == "true";
									target.attribute('selected', !cur);
								}
								var values = GlitterMenu.getData();
								if(target.glitterOptions.target != null){
									values = values.join(', ');
									var tg = Jotun.one(target.glitterOptions.target);
									if(tg != null){
										if(tg.is('input')){
											tg.value(values);
										}else{
											tg.clear(true).write(values);
										}
									}
								}
								if(target.glitterOptions.autoClose){
									GlitterMenu.closeMenu(menu);
								}
								if(GlitterMenu.onClick != null){
									setTimeout(function(){
										GlitterMenu.onClick(e.target, values);
									}, 50);
								}
							}else{
								GlitterMenu.closeMenu(menu);
								if(o.hasAttribute('glitter-open')){
									GlitterMenu.openMenu(o.attribute('glitter-open'));
								}
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
							var dx = Math.round((offset.x*-1.5)/Math.tan(Math.PI/count));
							var dy = Math.round((offset.y*-1.5)/Math.tan(Math.PI/count));
							if(aRad){
								tx = (tx * (offset.x + dx) * decay) >> 0;
								ty = (ty * (offset.y + dy) * decay) >> 0;
							}else{
								tx = (tx * parseInt(o.glitterOptions.dimension[0]) * decay) >> 0;
								ty = (ty * parseInt(o.glitterOptions.dimension[1]) * decay) >> 0;
							}
							o.glitterData.to = {
								top:'calc(50% + ' + ty + 'px - ' + offset.y + 'px)',
								left:'calc(50% + ' + tx + 'px - ' + offset.x + 'px)',
								opacity:1,
							};
						}
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
			this.getMenu(menu).all('.item[selected="true"]').each(function(o){
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
			this.getMenu(menu).all(selector || '.item[value]').attribute('selected', value);
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