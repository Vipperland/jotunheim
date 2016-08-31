<?php

class sirius_php_file_Image {
	public function __construct($file = null) {
		if(!php_Boot::$skip_constructor) {
		if($file !== null) {
			$this->open($file);
		}
	}}
	public $_res;
	public $name;
	public $width;
	public $height;
	public $type;
	public function _update($resource) {
		$this->dispose();
		$this->_res = $resource;
		$this->width = imagesx($this->_res);
		$this->height = imagesy($this->_res);
	}
	public function open($file) {
		$this->dispose();
		if($file !== null) {
			$isFile = is_file($file);
			$img = null;
			if($isFile) {
				$this->name = $file;
				$info = getimagesize($file);
				$this->width = $info[0];
				$this->height = $info[1];
				$this->type = $info[2];
				{
					$_g = $this->type;
					switch($_g) {
					case 1:{
						$img = imagecreatefromgif($file);
					}break;
					case 2:{
						$img = imagecreatefromjpeg($file);
					}break;
					case 3:{
						$img = imagecreatefrompng($file);
					}break;
					case 6:{
						$img = imagecreatefromwbmp($file);
					}break;
					}
				}
			} else {
				$img = imagecreatefromstring($file);
				$this->width = imagesx($this->_res);
				$this->height = imagesy($this->_res);
			}
			$this->_res = $img;
		}
		return $this;
	}
	public function resample($width, $height, $ratio = null) {
		if($ratio === null) {
			$ratio = true;
		}
		if($this->isValid()) {
			if($ratio) {
				if(sirius_php_file_Image_0($this, $height, $ratio, $width)) {
					$width = Math::round(sirius_php_file_Image_1($this, $height, $ratio, $width) * (sirius_php_file_Image_2($this, $height, $ratio, $width) / sirius_php_file_Image_3($this, $height, $ratio, $width)));
				} else {
					$height = Math::round(sirius_php_file_Image_4($this, $height, $ratio, $width) * (sirius_php_file_Image_5($this, $height, $ratio, $width) / sirius_php_file_Image_6($this, $height, $ratio, $width)));
				}
			}
			$newimg = imagecreatetruecolor($width, $height);
			if($newimg !== null) {
				imagealphablending($newimg, false);
				imagesavealpha($newimg, true);
				$alpha = imagecolorallocatealpha($newimg, 255, 255, 255, 127);
				imagefilledrectangle($newimg, 0, 0, $width, $height, $alpha);
				imagecopyresampled($newimg, $this->_res, 0, 0, 0, 0, $width, $height, $this->width, $this->height);
				$this->_update($newimg);
			}
		}
		return $this;
	}
	public function crop($x, $y, $width, $height) {
		if($this->isValid()) {
			if(sirius_php_file_Image_7($this, $height, $width, $x, $y)) {
				$x = 0;
			}
			if(sirius_php_file_Image_8($this, $height, $width, $x, $y)) {
				$y = 0;
			}
			if(sirius_php_file_Image_9($this, $height, $width, $x, $y)) {
				$width = $this->width - $x;
			}
			if(sirius_php_file_Image_10($this, $height, $width, $x, $y)) {
				$height = $this->height - $y;
			}
			$newimg = imagecreatetruecolor($width, $height);
			if($newimg !== null) {
				imagecopy($newimg, $this->_res, 0, 0, $x, $y, $width, $height);
				$this->_update($newimg);
			}
		}
		return $this;
	}
	public function fit($width, $height, $slice = null) {
		if($slice === null) {
			$slice = false;
		}
		if($this->isValid()) {
			if(sirius_php_file_Image_11($this, $height, $slice, $width)) {
				$this->resample(Math::round(sirius_php_file_Image_12($this, $height, $slice, $width) * (sirius_php_file_Image_13($this, $height, $slice, $width) / sirius_php_file_Image_14($this, $height, $slice, $width))), $height, true);
			} else {
				$this->resample($width, Math::round(sirius_php_file_Image_15($this, $height, $slice, $width) * (sirius_php_file_Image_16($this, $height, $slice, $width) / sirius_php_file_Image_17($this, $height, $slice, $width))), true);
			}
			if($slice) {
				$this->crop(Math::round(sirius_php_file_Image_18($this, $height, $slice, $width) / sirius_php_file_Image_19($this, $height, $slice, $width)), Math::round(sirius_php_file_Image_20($this, $height, $slice, $width) / sirius_php_file_Image_21($this, $height, $slice, $width)), $width, $height);
			}
		}
		return $this;
	}
	public function save($name = null, $type = null) {
		if($this->isValid()) {
			$dir = dirname($name);
			if(!is_dir($dir)) {
				$path = haxe_io_Path::addTrailingSlash($dir);
				$_p = null;
				$parts = (new _hx_array(array()));
				while($path !== ($_p = haxe_io_Path::directory($path))) {
					$parts->unshift($path);
					$path = $_p;
				}
				{
					$_g = 0;
					while($_g < $parts->length) {
						$part = $parts[$_g];
						++$_g;
						if(_hx_char_code_at($part, strlen($part) - 1) !== 58 && !file_exists($part)) {
							@mkdir($part, 493);
						}
						unset($part);
					}
				}
			}
			if($type === null) {
				$type = $this->type;
			}
			if($name === null) {
				$name = $this->name;
			}
			try {
				if($type !== null) {
					switch($type) {
					case 1:{
						imagegif($this->_res, $name);
					}break;
					case 3:{
						imagepng($this->_res, $name);
					}break;
					case 6:{
						imagewbmp($this->_res, $name);
					}break;
					default:{
						imagejpeg($this->_res, $name, 95);
					}break;
					}
				} else {
					imagejpeg($this->_res, $name, 95);
				}
				return true;
			}catch(Exception $__hx__e) {
				$_ex_ = ($__hx__e instanceof HException) ? $__hx__e->e : $__hx__e;
				$e = $_ex_;
				{}
			}
		}
		return false;
	}
	public function dispose() {
		if(_hx_field($this, "_res") !== null) {
			imagedestroy($this->_res);
		}
		$this->_res = null;
	}
	public function isValid() {
		return _hx_field($this, "_res") !== null;
	}
	public function __call($m, $a) {
		if(isset($this->$m) && is_callable($this->$m))
			return call_user_func_array($this->$m, $a);
		else if(isset($this->__dynamics[$m]) && is_callable($this->__dynamics[$m]))
			return call_user_func_array($this->__dynamics[$m], $a);
		else if('toString' == $m)
			return $this->__toString();
		else
			throw new HException('Unable to call <'.$m.'>');
	}
	function __toString() { return 'sirius.php.file.Image'; }
}
function sirius_php_file_Image_0(&$__hx__this, &$height, &$ratio, &$width) {
	{
		$aNeg = $height < 0;
		$bNeg = $width < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return $height >= $width;
		}
		unset($bNeg,$aNeg);
	}
}
function sirius_php_file_Image_1(&$__hx__this, &$height, &$ratio, &$width) {
	{
		$int = $__hx__this->width;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_php_file_Image_2(&$__hx__this, &$height, &$ratio, &$width) {
	{
		$int1 = $height;
		if($int1 < 0) {
			return 4294967296.0 + $int1;
		} else {
			return $int1 + 0.0;
		}
		unset($int1);
	}
}
function sirius_php_file_Image_3(&$__hx__this, &$height, &$ratio, &$width) {
	{
		$int2 = $__hx__this->height;
		if($int2 < 0) {
			return 4294967296.0 + $int2;
		} else {
			return $int2 + 0.0;
		}
		unset($int2);
	}
}
function sirius_php_file_Image_4(&$__hx__this, &$height, &$ratio, &$width) {
	{
		$int3 = $__hx__this->height;
		if($int3 < 0) {
			return 4294967296.0 + $int3;
		} else {
			return $int3 + 0.0;
		}
		unset($int3);
	}
}
function sirius_php_file_Image_5(&$__hx__this, &$height, &$ratio, &$width) {
	{
		$int4 = $width;
		if($int4 < 0) {
			return 4294967296.0 + $int4;
		} else {
			return $int4 + 0.0;
		}
		unset($int4);
	}
}
function sirius_php_file_Image_6(&$__hx__this, &$height, &$ratio, &$width) {
	{
		$int5 = $__hx__this->width;
		if($int5 < 0) {
			return 4294967296.0 + $int5;
		} else {
			return $int5 + 0.0;
		}
		unset($int5);
	}
}
function sirius_php_file_Image_7(&$__hx__this, &$height, &$width, &$x, &$y) {
	{
		$aNeg = 0 < 0;
		$bNeg = $x < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return 0 > $x;
		}
		unset($bNeg,$aNeg);
	}
}
function sirius_php_file_Image_8(&$__hx__this, &$height, &$width, &$x, &$y) {
	{
		$aNeg1 = 0 < 0;
		$bNeg1 = $y < 0;
		if($aNeg1 !== $bNeg1) {
			return $aNeg1;
		} else {
			return 0 > $y;
		}
		unset($bNeg1,$aNeg1);
	}
}
function sirius_php_file_Image_9(&$__hx__this, &$height, &$width, &$x, &$y) {
	{
		$a = $x + $width;
		$b = $__hx__this->width;
		$aNeg2 = $a < 0;
		$bNeg2 = $b < 0;
		if($aNeg2 !== $bNeg2) {
			return $aNeg2;
		} else {
			return $a > $b;
		}
		unset($bNeg2,$b,$aNeg2,$a);
	}
}
function sirius_php_file_Image_10(&$__hx__this, &$height, &$width, &$x, &$y) {
	{
		$a1 = $y + $height;
		$b1 = $__hx__this->height;
		$aNeg3 = $a1 < 0;
		$bNeg3 = $b1 < 0;
		if($aNeg3 !== $bNeg3) {
			return $aNeg3;
		} else {
			return $a1 > $b1;
		}
		unset($bNeg3,$b1,$aNeg3,$a1);
	}
}
function sirius_php_file_Image_11(&$__hx__this, &$height, &$slice, &$width) {
	{
		$a = $__hx__this->width;
		$b = $__hx__this->height;
		$aNeg = $a < 0;
		$bNeg = $b < 0;
		if($aNeg !== $bNeg) {
			return $aNeg;
		} else {
			return $a >= $b;
		}
		unset($bNeg,$b,$aNeg,$a);
	}
}
function sirius_php_file_Image_12(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int = $height;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_php_file_Image_13(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int1 = $width;
		if($int1 < 0) {
			return 4294967296.0 + $int1;
		} else {
			return $int1 + 0.0;
		}
		unset($int1);
	}
}
function sirius_php_file_Image_14(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int2 = $__hx__this->width;
		if($int2 < 0) {
			return 4294967296.0 + $int2;
		} else {
			return $int2 + 0.0;
		}
		unset($int2);
	}
}
function sirius_php_file_Image_15(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int3 = $width;
		if($int3 < 0) {
			return 4294967296.0 + $int3;
		} else {
			return $int3 + 0.0;
		}
		unset($int3);
	}
}
function sirius_php_file_Image_16(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int4 = $height;
		if($int4 < 0) {
			return 4294967296.0 + $int4;
		} else {
			return $int4 + 0.0;
		}
		unset($int4);
	}
}
function sirius_php_file_Image_17(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int5 = $__hx__this->height;
		if($int5 < 0) {
			return 4294967296.0 + $int5;
		} else {
			return $int5 + 0.0;
		}
		unset($int5);
	}
}
function sirius_php_file_Image_18(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int6 = $__hx__this->width - $width;
		if($int6 < 0) {
			return 4294967296.0 + $int6;
		} else {
			return $int6 + 0.0;
		}
		unset($int6);
	}
}
function sirius_php_file_Image_19(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int7 = 2;
		if($int7 < 0) {
			return 4294967296.0 + $int7;
		} else {
			return $int7 + 0.0;
		}
		unset($int7);
	}
}
function sirius_php_file_Image_20(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int8 = $__hx__this->height - $height;
		if($int8 < 0) {
			return 4294967296.0 + $int8;
		} else {
			return $int8 + 0.0;
		}
		unset($int8);
	}
}
function sirius_php_file_Image_21(&$__hx__this, &$height, &$slice, &$width) {
	{
		$int9 = 2;
		if($int9 < 0) {
			return 4294967296.0 + $int9;
		} else {
			return $int9 + 0.0;
		}
		unset($int9);
	}
}
