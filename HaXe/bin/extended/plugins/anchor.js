/**
 * ...
 * @author Rafael Moreira
 */

(function($exports) {
	$exports.sru = $exports.sru || {};
	$exports.sru.plugins = $exports.sru.plugins || {};
	$exports.sru.plugins.Anchor = function(){
		Sirius.all('[plugin*="anchor"]').onClick(function(e){
			var target = e.target.attribute('a-target');
			if(target){
				var find = Sirius.one(target);
				var p = sru.dom.Display.getPosition(find.element);
				var ease = e.target.attribute('a-easing');
				var time = e.target.attribute('a-time');
				var offX = e.target.attribute('a-offset-x');
				var offY = e.target.attribute('a-offset-y');
				Sirius.document.scrollTo(find, time || 1, Ease.fromString(ease || 'CIRC.IO'), offX || 0, offY || 100);
			}else{
				Sirius.log('[PLUGIN] Anchor can´t find <' + target + '>', 10, 2);
			}
		});
	}
})(typeof window != "undefined" ? window : exports);