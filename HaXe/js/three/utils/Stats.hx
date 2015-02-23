package js.three.utils;

@:native("Stats")
extern class Stats
{
	private static function __init__() : Void
	{
		#if !noEmbedJS
			haxe.macro.Compiler.includeFile("js/three/utils/Stats.js");
		#end
	}
	
	var domElement : js.html.Element;
	
	function new() : Void;
	function setMode(m:Int) : Void;
	function begin() : Void;
	function end() : Void;
	function update() : Void;
}
