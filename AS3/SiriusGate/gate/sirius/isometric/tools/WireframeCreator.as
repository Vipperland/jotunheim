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
		
		public static function create(color:int, width:uint, height:uint, depth:uint, bounds:BiomeBounds, location:BiomePoint, iso:Boolean = false):Bitmap {
			
			var s:Shape = new Shape();
			
			var hw:int = width;
			var hh:int = height;
			var hd:int = depth;
			
			if (iso) {
				hw >>= 1;
				hh >>= 1;
				hd >>= 1;
			}
			
			var x:Number;
			var y:Number;
			var z:Number;
			
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
				
				if (iso) {
					if(point.x !== bounds.width - 1 && point.y !== bounds.height - 1 && point.z !== bounds.depth - 1) {
						continue;
					}
				}
				//else if (bounds.depth && point.z != bounds.depth -1) {
					//continue;
				//}
				if (iso) {
					x = point.ax * hw;
					y = point.ay * hh;
					z = point.z * hd;
				}else {
					x = point.x * width;
					//y = (point.y - point.z) * height;
					y = point.y * depth;
					z = point.z * height;
				}
				
				
				
				if(iso){
				
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
					
				}else {
					//
					s.graphics.beginFill(top, 1);
					s.graphics.lineStyle(1, right, 1);
					s.graphics.drawRect(x, y-z, hw, -hd);
					
					s.graphics.beginFill(left, 1);
					s.graphics.lineStyle(1, top, 1);
					s.graphics.drawRect(x, y-z, hw, hh);
					
				}
				
			}
			
			var bmp:Bitmap = new Bitmap(new BitmapData(s.width, s.height, true, 0));
			var bds:Rectangle = s.getBounds(s);
			bmp.bitmapData.draw(s, new Matrix(1, 0, 0, 1, -bds.x, -bds.y));
			
			if(iso){
				bmp.x = location.ax * hw - (bounds.height) * hw;
				bmp.y = location.ay * hh;
			}else {
				bmp.x = location.x * width;
				bmp.y = location.y * height;
			}
			
			s.graphics.clear();
			
			return bmp;
		
		}
		
		public static function paint(texture:BitmapData, width:uint, height:uint, depth:uint, bounds:BiomeBounds, location:BiomePoint, filter:Function = null, iso:Boolean = false):Bitmap {
			
			var s:Sprite = new Sprite();
			
			var hw:int = width;
			var hh:int = height;
			var hd:int = depth;
			
			if (iso) {
				hw >>= 1;
				hh >>= 1;
				hd >>= 1;
			}
			
			for each (var point:BiomePoint in bounds.points) {
				
				if (iso) {
					if(point.x !== bounds.width - 1 && point.y !== bounds.height - 1 && point.z !== bounds.depth - 1) {
						continue;
					}
				}else if (point.z != bounds.depth -1) {
					continue;
				}
				
				if (filter !== null) {
					if (!filter(point)) {
						continue;
					}
				}
				
				var elem:Bitmap = new Bitmap(texture, "auto", true);
				if(iso){
					elem.x = point.ax * hw;
					elem.y = point.ay * hh;
				}else {
					elem.x = point.x * width;
					elem.y = point.y * depth;
				}
				s.addChild(elem);
				
			}
			
			var bmp:Bitmap = new Bitmap(new BitmapData(s.width, s.height, false, 0));
			var bds:Rectangle = s.getBounds(s);
			bmp.bitmapData.draw(s, new Matrix(1, 0, 0, 1, -bds.x, -bds.y));
			
			if(iso){
				bmp.x = location.ax * hw - (bounds.height) * hw;
				bmp.y = location.ay * hh;
			}else {
				bmp.x = location.x * width;
				bmp.y = location.y * height;
			}
			
			return bmp;
		
		}
	
	}

}