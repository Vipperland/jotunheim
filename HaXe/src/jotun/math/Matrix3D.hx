package jotun.math;

/**
 * ...
 * @author Rim Project
 */
class Matrix3D {
	
	/**
	 * 
	 * @param	r
	 * @return
	 */
	public static function rotateX(r:Float):Array<Float> {
		r = r * .017453292519943295;
		return [
			1, 0, 0, 0,
			0, Math.cos(r), -Math.sin(r), 0,
			0, Math.sin(r), Math.cos(r), 0,
			0, 0, 0, 1,
		];
	}
	
	/**
	 * 
	 * @param	r
	 * @return
	 */
	public static function rotateY(r:Float):Array<Float> {
		r = r * .017453292519943295;
		return [
			Math.cos(r), 0, Math.sin(r), 0,
			0, 1, 0, 0,
			-Math.sin(r), 0, Math.cos(r), 0,
			0, 0, 0, 1,
		];
	}
	
	/**
	 * 
	 * @param	r
	 * @return
	 */
	public static function rotateZ(r:Float):Array<Float> {
		r = r * .017453292519943295;
		return [
			Math.cos(r), -Math.sin(r), 0, 0,
			Math.sin(r), Math.cos(r), 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1,
		];
	}
	
	/**
	 * 
	 * @param	x
	 * @param	y
	 * @param	z
	 * @return
	 */
	public static function scale(x:Float, y:Float, z:Float):Array<Float> {
		return [
			x,    0,    0,   0,
			0,    y,    0,   0,
			0,    0,    z,   0,
			0,    0,    0,   1,
		];
	}
	
	/**
	 * 
	 * @param	x
	 * @param	y
	 * @param	z
	 * @return
	 */
	public static function translate(x:Float, y:Float, z:Float):Array<Float> {
		return [
			1,    0,    0,   0,
			0,    1,    0,   0,
			0,    0,    1,   0,
			x,    y,    z,   1,
		];
	}
	
	/**
	 * 
	 * @param	a
	 * @param	b
	 * @return
	 */
	private static function _multiply(a:Array<Float>, b:Array<Float>):Array<Float> {
		
		var result = [];
		
		var a00:Float = a[0];
		var a10:Float = a[1];
		var a20:Float = a[2];
		var a30:Float = a[3];
		var a01:Float = a[4];
		var a11:Float = a[5];
		var a21:Float = a[6];
		var a31:Float = a[7];
		var a02:Float = a[8];
		var a12:Float = a[9];
		var a22:Float = a[10];
		var a32:Float = a[11];
		var a03:Float = a[12];
		var a13:Float = a[13];
		var a23:Float = a[14];
		var a33:Float = a[15];
		
		var b0:Float = b[0];
		var b1:Float = b[1];
		var b2:Float = b[2];
		var b3:Float = b[3];
		
		result[0] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
		result[1] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
		result[2] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
		result[3] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
		
		b0 = b[4];
		b1 = b[5];
		b2 = b[6];
		b3 = b[7];
		
		result[4] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
		result[5] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
		result[6] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
		result[7] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
		
		b0 = b[8];
		b1 = b[9];
		b2 = b[10];
		b3 = b[11];
		
		result[8] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
		result[9] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
		result[10] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
		result[11] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
		
		b0 = b[12];
		b1 = b[13];
		b2 = b[14];
		b3 = b[15];
		
		result[12] = b0*a00 + b1*a10 + b2*a20 + b3*a30;
		result[13] = b0*a01 + b1*a11 + b2*a21 + b3*a31;
		result[14] = b0*a02 + b1*a12 + b2*a22 + b3*a32;
		result[15] = b0*a03 + b1*a13 + b2*a23 + b3*a33;
		
		return result;
	}
	
	/**
	 * 
	 * @param	data
	 * @return
	 */
	public static function transform(data:Array<Array<Float>>):Array<Float> {
		var res:Array<Float> = null;
		var idx:Int = 0;
		var len:Int = data.length;
		var mx:Array<Float>;
		while (idx < len) {
			mx = data[idx];
			if (mx != null){
				if (res == null){
					res = mx;
				}else{
					res = _multiply(res, mx);
				}
			}
			++idx;
		}
		return res;
	}
	
	/**
	 * 
	 * @param	matrix
	 * @return
	 */
	public static function toCss(matrix:Array<Float>):String {
		return "matrix3d(" + matrix.join(',') + ")";
	}
	
}