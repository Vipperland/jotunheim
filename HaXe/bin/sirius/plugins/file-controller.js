/**
 * ...
 * @author Rafael Moreira <vipperland[at]live.com>
 */
(function($exports) {
	$exports.sru = $exports.sru || {};
	$exports.sru.plugins = $exports.sru.plugins || {};
	$exports.sru.plugins.LabelController = {
		onload:function(){
			var fix = {backgroundPosition:'center center', backgroundSize:'cover'};
			Sirius.all('input[type=file]').each(function(o){
				var label = Sirius.one('label[for="' + o.attribute('id') + '"]');
				if(label != null){
					label.style(fix);
					label.css('empty');
					label.overflow('hidden');
					console.log(label.attribute('file-target'));
					if(label.hasAttribute('file-target'))
						o.fileController(label.one(label.attribute('file-target')), function(){ label.css('selected /empty'); });
					else
						o.fileController(label, function(){ label.css('selected /empty'); });
				}
			});
		}
	}
	if(Sirius != null) Sirius.updatePlugins();
})(typeof window != "undefined" ? window : exports);