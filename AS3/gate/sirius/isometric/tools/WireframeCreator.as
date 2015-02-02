package gate.sirius.isometric.tools {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import gate.sirius.isometric.math.BiomeBounds;
	import gate.sirius.isometric.math.BiomePoint;
	import gate.sirius.isometric.matter.BiomeMatter;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class WireframeCreator {
		
		public static function create(color:int, width:uint, height:uint, depth:uint, bounds:BiomeBounds, location:BiomePoint):DisplayObject {
			
			var s:Shape = new Shape();
			var hw:int = width >> 1;
			var hh:int = height >> 1;
			var hd:int = depth >> 1;
			
			var r:int = color >> 16 & 0xFF;
			var g:int = color >> 8 & 0xFF;
			var b:int = color & 0xFF;
			
			var left:int = color;
			r *= .95;
			g *= .95;
			b *= .95;
			var top:int = r << 16 | g << 8 | b;
			r *= .95;
			g *= .95;
			b *= .95;
			var right:int = r << 16 | g << 8 | b;
			r *= .95;
			g *= .95;
			b *= .95;
			color = r << 16 | g << 8 | b;
			
			for each (var point:BiomePoint in bounds.points) {
				
				if (point.x !== bounds.width - 1 && point.y !== bounds.height - 1 && point.z !== bounds.depth - 1) {
					continue;
				}
				
				var x:Number = point.ax * hw;
				var y:Number = point.ay * hh;
				var z:Number = point.z * hd;
				
				s.graphics.beginFill(top, 1);
				s.graphics.moveTo(0 + x, -hh + y - z);
				s.graphics.lineStyle(1, right, 1);
				s.graphics.lineTo(hw + x, 0 + y - z);
				s.graphics.lineTo(0 + x, hh + y - z);
				s.graphics.lineStyle(0, right, 0);
				s.graphics.lineTo(-hw + x, 0 + y - z);
				s.graphics.lineTo(0 + x, -hh + y - z);
				s.graphics.beginFill(left, 1);
				s.graphics.moveTo(-hw + x, 0 + y - z);
				s.graphics.lineStyle(1, top, 1);
				s.graphics.lineTo(-hw + x, hh + hd + y - z);
				s.graphics.lineTo(0 + x, hh + depth + y - z);
				s.graphics.lineStyle(0, top, 0);
				s.graphics.lineTo(0 + x, hh + y - z);
				s.graphics.beginFill(right, 1);
				s.graphics.moveTo(hw + x, 0 + y - z);
				s.graphics.lineStyle(1, top, 1);
				s.graphics.lineTo(hw + x, hh + hd + y - z);
				s.graphics.lineTo(0 + x, hh + depth + y - z);
				s.graphics.lineStyle(0, left, 0);
				s.graphics.lineTo(0 + x, hh + y - z);
				
			}
			
			var bmp:Bitmap = new Bitmap(new BitmapData(s.width, s.height, true, 0));
			var bds:Rectangle = s.getBounds(s);
			bmp.bitmapData.draw(s, new Matrix(1, 0, 0, 1, -bds.x, -bds.y));
			bmp.x = location.ax * hw - (bounds.height) * hw;
			bmp.y = location.ay * hh;
			
			s.graphics.clear();
			
			return bmp;
		
		}
		
		public static function paint(texture:BitmapData, width:uint, height:uint, depth:uint, bounds:BiomeBounds, location:BiomePoint, filter:Function = null):Bitmap {
			
			var s:Sprite = new Sprite();
			
			var hw:int = width >> 1;
			var hh:int = height >> 1;
			var hd:int = depth >> 1;
			
			for each (var point:BiomePoint in bounds.points) {
				
				if (point.x !== bounds.width - 1 && point.y !== bounds.height - 1 && point.z !== bounds.depth - 1) {
					continue;
				}
				
				if (filter !== null) {
					if (!filter(point)) {
						continue;
					}
				}
				
				var elem:Bitmap = new Bitmap(texture, "auto", true);
				elem.x = point.ax * hw;
				elem.y = point.ay * hh;
				s.addChild(elem);
				
			}
			
			var bmp:Bitmap = new Bitmap(new BitmapData(s.width, s.height, true, 0));
			var bds:Rectangle = s.getBounds(s);
			bmp.bitmapData.draw(s, new Matrix(1, 0, 0, 1, -bds.x, -bds.y));
			bmp.x = location.ax * hw - (bounds.height) * hw;
			bmp.y = location.ay * hh;
			
			return bmp;
		
		}
	
	}

}