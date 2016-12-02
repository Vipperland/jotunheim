/**
 * ...
 * @author Rafael Moreira <vipperland[at]live.com>
 */
(function($exports) {
	$exports.sru = $exports.sru || {};
	$exports.sru.plugins = $exports.sru.plugins || {};
	$exports.sru.plugins.LabelController = {
		onload:function(){
			sru.dom.Input.fixer = {backgroundPosition:'center center', backgroundSize:'cover'};
			Sirius.all('input[type=file]').each(function(o){
				var label = Sirius.one('label[for="' + o.attribute('id') + '"]');
				var status = null;
				if(label != null){
					label.css('no-file');
					label.overflow('hidden');
					if(label.hasAttribute('file-target'))
						o.fileController(label.one(label.attribute('file-target')), function(i){ 
							label.css('has-file /no-file'); 
						});
					else
						o.fileController(label, function(i){ 
							label.css('/has-file no-file'); 
						});
				}
			});
		}
	}
	if(Sirius != null) Sirius.updatePlugins();
})(typeof window != "undefined" ? window : exports);