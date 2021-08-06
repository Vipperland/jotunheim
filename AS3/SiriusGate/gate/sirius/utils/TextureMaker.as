package gate.sirius.utils {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Rim Project
	 */
	public class TextureMaker {
		
		private static var _base_matrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
		
		private static var _cached_textures:Dictionary = new Dictionary(false);
		
		public static function getBitmap(target:DisplayObject):Bitmap {
			var bm:Bitmap = new Bitmap();
			bm.x = target.x;
			bm.y = target.y;
			bm.bitmapData = getTexture(target);
			bm.smoothing = true;
			bm.width = target.width;
			bm.height = target.height;
			return bm;
		}
		
		public static function getTexture(target:DisplayObject, scale:Number):BitmapData {
			var o_scale:Number = target.scaleX;
			target.scaleX = scale;
			target.scaleY = scale;
			var bmd:BitmapData = new BitmapData(target.width>>0, target.height>>0, true, 0x22000000);
			var clip:Rectangle = target.getBounds(target);
			_base_matrix.tx = -clip.x;
			_base_matrix.ty = -clip.y;
			_base_matrix.a = scale;
			_base_matrix.d = scale;
			bmd.drawWithQuality(target, _base_matrix);
			target.scaleX = o_scale;
			target.scaleY = o_scale;
			return bmd;
		}
		
		public static function cacheTexture(name:String, target:DisplayObject, scale:Number):void {
			_cached_textures[name] = getTexture(target, scale);
		}
		
		public static function getCachedTexture(name:String, clone:Boolean = false):BitmapData {
			if (clone){
				return _cached_textures[name].clone();
			}else {
				return _cached_textures[name];
			}
		}
		
	}

}