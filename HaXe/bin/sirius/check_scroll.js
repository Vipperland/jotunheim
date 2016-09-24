(function(){
	var lastmode = 0;
	window.addEventListener('scroll', function(e){
		var elem = Sirius.one("seletor do elemento");
		var mode = elem.checkVisibility();
		if(mode != lastmode){
			switch(mode){
				case 0 : 
				case 1 :
					// Quando o elemento não está visivel ou parcialmente visivel
					elem.css('/classe-pra-remover');
					break;
				case 2 :
					// Quando o elemento está completamente visivel
					elem.css('classe-pra-adicionar');
					break;
			}
			mode = lastmode;
		}
	});
)();