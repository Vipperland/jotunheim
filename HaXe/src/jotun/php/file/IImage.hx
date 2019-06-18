package jotun.php.file;

/**
 * @author Rafael Moreira <vipperland[at]live.com>
 */
interface IImage {
  
	function open(file:Dynamic):IImage;
	
	function resample(width:UInt, height:UInt, ?ratio:Bool = true):IImage;
	
	function crop(x:UInt, y:UInt, width:UInt, height:UInt):IImage;
	
	function fit(width:UInt, height:UInt):IImage;
	
	function isOutBounds(width:Int, height:Int):Bool;
	
	function save(?name:String, ?type:UInt, ?qty:Int):Bool;
	
	function dispose():Void;
	
	function delete():Void;
	
	function isValid():Bool;
}