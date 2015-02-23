package js.three;

import js.html.*;

@:native("THREE.FontUtils")
extern class FontUtils
{
	static var faces : Dynamic<Face3>;
	static var face : String;
	static var weight : String;
	static var style : String;
	static var size : Float;
	static var divisions : Float;

	static function getFace() : Face3;
	static function loadFace(data:TypefaceData) : TypefaceData;
	static function drawText(text:String) : { paths: Array<Path>, offset:Float };
	static function extractGlyphPoints(c:String, face:Face3, scale:Float, offset:Float, path:Path) : { offset: Float, path:Path };

	static function generateShapes(text:String, ?parameters:{ ?size:Float, ?curveSegments:Float, ?font:String, ?weight:String, ?style:String }) : Array<Shape>;
	static function Triangulate(contour:Array<Vector2>, indices:Bool) : Array<Vector2>;
}