/*-- ASSET FOLDER --*/
$(document).ready(function(){		


/*--RWD inspector--*/
function mostrarLargura(ele, w){$("#navegador").text("Browser Window: " + w + "px");}
mostrarLargura("window", $(window).width());
$(window).resize(function(){mostrarLargura("window", $(window).width());});
/*--RWD inspector--*/
















});