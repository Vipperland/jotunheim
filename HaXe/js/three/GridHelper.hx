package js.three;

import js.html.*;

@:native("THREE.GridHelper")
extern class GridHelper extends Line
{
	function new(size:Int, step:Int) : Void;

	var color1 : Color;
	var color2 : Color;

	function setColors(colorCenterLine:Int, colorGrid:Int) : Void;
}