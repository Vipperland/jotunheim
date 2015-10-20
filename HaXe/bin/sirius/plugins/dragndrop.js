/**
 * ...
 * @author Rafael Moreira
 */

(function($exports) {
	$exports.sru = $exports.sru || {};
	$exports.sru.plugins = $exports.sru.plugins || {};
	$exports.sru.plugins.DragAndDrop = function(target){
		var table = target.children();
		var current = null;
		table.each(function(e){	e.attribute('draggable','true'); });
		table.onDragStart(function(e){ current = e.target; });
		table.onDragOver(function(e){ e.event.preventDefault();	});
		table.onDrop(function(e){
			e.event.preventDefault();
			if(!current) return;
			var tA = current.index();
			var tB = e.target.index();
			if(tA != tB) e.target.parent().addChild(current, tA < tB ? tB + 1 : tB);
		});
	}
	if(Sirius != null) Sirius.updatePlugins();
})(typeof window != "undefined" ? window : exports);