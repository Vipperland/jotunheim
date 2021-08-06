package gate.sirius.isometric.matter {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import gate.sirius.isometric.math.BiomeAllocation;
	import gate.sirius.isometric.math.BiomeFlexPoint;
	import gate.sirius.isometric.math.BiomePoint;
	
	
	/**
	 * ...
	 * @author Rafael Moreira <rafael@gateofsirius.com>
	 */
	public class TiledBiomeMatterSample extends BiomeMatter {
		
		public function TiledBiomeMatterSample(name:String, allocation:BiomeAllocation, location:BiomeFlexPoint, color:int = 0, width:uint = 10, height:uint = 10, depth:uint = 10) {
			super(name, allocation, location, null);
			_createWireframe(color, width, height, depth);
		}
		
		
		private function _createWireframe(color:int, width:uint, height:uint, depth:uint):void {
			
			var s:Shape = new Shape();
			var hw:int = (width) >> 1;
			var hh:int = (height) >> 1;
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
			
			for each (var point:BiomePoint in _allocation.current.points) {
				
				var x:Number = point.ax * hw;
				var y:Number = point.ay * hh;
				var z:Number = point.z * depth;
				
				s.graphics.beginFill(top, 1);
				s.graphics.moveTo(0 + x, -hh + y - z);
				s.graphics.lineStyle(1, right, 1);
				s.graphics.lineTo(hw + x, 0 + y - z);
				s.graphics.lineTo(0 + x, hh + y - z);
				s.graphics.lineStyle(0, right, 0);
				s.graphics.lineTo( -hw + x, 0 + y - z);
				s.graphics.lineTo(0 + x, -hh + y - z);
				s.graphics.beginFill(left, 1);
				s.graphics.moveTo( -hw + x, 0 + y - z);
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
			_content = bmp;
			s.graphics.clear();
			syncPos(width >> 1, height >> 1, depth, bds);
			
		}
		
		
		public function syncPos(w:int = 10, h:int = 10, d:int = 10, bds:Rectangle = null):void {
			if (_content) {
				_content.x = w * _location.ax;
				_content.y = h * _location.ay - (_location.z) * d;
				if (bds) {
					_content.x += bds.x;
					_content.y += bds.y;
				}
			}
		}
	
	}

}