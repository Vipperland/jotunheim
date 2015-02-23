package js.three.controls;

@:native("THREE.TrackballControls")
extern class TrackballControls
{
	private static function __init__() : Void
	{
		#if !noEmbedJS
			haxe.macro.Compiler.includeFile("js/three/controls/TrackballControls.js");
		#end
	}
	
	function new(camera:Camera) : Void;
	
	var enabled : Bool;
	
	var screen : { left:Int, top:Int, width:Int, height:Int };
	
	var rotateSpeed : Float;
	var zoomSpeed : Float;
	var panSpeed : Float;
	
	var noRotate : Bool;
	var noZoom : Bool;
	var noPan : Bool;
	var noRoll : Bool;
	
	var staticMoving : Bool;
	var dynamicDampingFactor : Float;
	
	var minDistance : Float;
	var maxDistance : Float;
	
	var keys : Array<Int>;
	
	/**
	 * change, start, end
	 */
	function addEventListener(event:String, callb:Void->Void) : Void;
}
