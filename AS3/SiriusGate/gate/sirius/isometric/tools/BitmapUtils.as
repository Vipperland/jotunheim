package gate.sirius.isometric.tools {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomeMath;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.matter.BiomeMatter;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class BitmapUtils {
		
		public static function apply(to:BiomeMatter, funct:Function, width:uint, height:uint, color:uint, border:uint = 0x0):void {
			var bitmap:Bitmap = BitmapUtils.check(to);
			bitmap.bitmapData = funct(to, width, height, color, border);
			to.content = bitmap;
			bitmap.name = to.name;
			var location:BiomePoint = BiomeMath.expandLocation(to.location.x, to.location.y, 0, width, height, 0);
			to.content.x = location.x;
			to.content.y = location.y;
		}
		
		
		public static function tiled(to:BiomeMatter, width:uint, height:uint, color:uint, border:uint = 0x0):BitmapData {
			
			var currentBounds:BiomeBounds = to.allocation.current;
			var texture:BitmapData = new BitmapData(currentBounds.maxX * width + width, currentBounds.maxY * height + height, true, 0x0);
			var out:Rectangle = new Rectangle(0, 0, width, height);
			var inner:Rectangle = new Rectangle(1, 1, width - 2, height - 2);
			
			to.allocation.current.iterate(function(point:BiomePoint):void {
					out.x = point.x * width;
					out.y = point.y * height;
					inner.x = out.x + 1;
					inner.y = out.y + 1;
					texture.fillRect(out, border | 0xFF000000);
					texture.fillRect(inner, color);
				});
			
			return texture;
		
		}
		
		
		public static function frame(to:BiomeMatter, width:uint, height:uint, color:uint, border:uint = 0x0):BitmapData {
			
			var currentBounds:BiomeBounds = to.allocation.current;
			var texture:BitmapData = new BitmapData(currentBounds.width * width, currentBounds.height * height, true, 0x0);
			var shape:Shape = new Shape();
			shape.graphics.lineStyle(2, color, 1);
			shape.graphics.lineTo(texture.width, 0);
			shape.graphics.lineTo(texture.width, texture.height);
			shape.graphics.lineTo(0, texture.height);
			shape.graphics.lineTo(0, 0);
			shape.graphics.lineTo(texture.width, texture.height);
			shape.graphics.moveTo(texture.width, 0);
			shape.graphics.lineTo(0, texture.height);
			shape.graphics.endFill();
			texture.draw(shape);
			shape.graphics.clear();
			shape = null;
			
			return texture;
		
		}
		
		
		static public function check(matter:BiomeMatter):Bitmap {
			var bitmap:Bitmap = (matter.content as Bitmap);
			if (bitmap) {
				if (bitmap.bitmapData) {
					bitmap.bitmapData.dispose();
				}
			} else {
				bitmap = new Bitmap();
			}
			return bitmap;
		}
		
		static public function spriteFrom(bitmap:BitmapData, w:int, h:int, x1:int = 0, y1:int = 0, x2:int = 0, y2:int = 0):Vector.<BitmapData> {
			if (x2 == 0){
				x2 = bitmap.width;
			}
			if (y2 == 0){
				y2 = bitmap.height;
			}
			var xT:int = x1;
			var res:Vector.<BitmapData> = new Vector.<BitmapData>();
			var loct:Point = new Point(0, 0);
			var rect:Rectangle = new Rectangle(0, 0, 100, 100);
			while (y1 < y2){
				while (x1 < x2){
					rect.x = x1;
					rect.y = y1;
					var bmp:BitmapData = new BitmapData(w, h, true, 0x00000000);
					bmp.copyPixels(bitmap, rect, loct);
					res[res.length] = bmp;
					x1 += w;
				}
				x1 = xT;
				y1 += h;
			}
			return res;
		}
		
	}

}