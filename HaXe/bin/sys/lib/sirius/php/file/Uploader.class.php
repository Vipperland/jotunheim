<?php

class sirius_php_file_Uploader {
	public function __construct(){}
	static $files;
	static $savePathImg = "upload/images/";
	static $savePathDoc = "upload/documents/";
	static function sizes() { $args = func_get_args(); return call_user_func_array(self::$sizes, $args); }
	static $sizes;
	static function set($imgPath, $docPath = null) {
		sirius_php_file_Uploader::$savePathImg = $imgPath;
		if($docPath !== null) {
			sirius_php_file_Uploader::$savePathDoc = $docPath;
		}
	}
	static function save($optSizes = null) {
		if($optSizes !== null) {
			sirius_utils_Dice::Values($optSizes, array(new _hx_lambda(array(&$optSizes), "sirius_php_file_Uploader_0"), 'execute'), null);
		}
		sirius_php_file_Uploader::_verify();
		return sirius_php_file_Uploader::$files;
	}
	static function _getType($file) {
		$ext = strtolower(_hx_explode(".", $file)->pop());
		switch($ext) {
		case "jpg":case "jpeg":case "png":case "gif":{
			return "image";
		}break;
		default:{
			return "document";
		}break;
		}
	}
	static function _getSavePath($type, $sufix = null) {
		if($sufix === null) {
			$sufix = "";
		}
		switch($type) {
		case "image":{
			return _hx_string_or_null(sirius_php_file_Uploader::$savePathImg) . _hx_string_or_null($sufix);
		}break;
		default:{
			return _hx_string_or_null(sirius_php_file_Uploader::$savePathDoc) . _hx_string_or_null($sufix);
		}break;
		}
	}
	static function _verify() {
		$partName = null;
		$lastFile = null;
		$fileStream = null;
		php_Web::parseMultipart(array(new _hx_lambda(array(&$fileStream, &$lastFile, &$partName), "sirius_php_file_Uploader_1"), 'execute'), array(new _hx_lambda(array(&$fileStream, &$lastFile, &$partName), "sirius_php_file_Uploader_2"), 'execute'));
		if($fileStream !== null) {
			$fileStream->close();
		}
		if(_hx_len(sirius_php_file_Uploader::$sizes) > 0) {
			$image = new sirius_php_file_Image(null);
			sirius_utils_Dice::Values(sirius_php_file_Uploader::$files->{"list"}, array(new _hx_lambda(array(&$fileStream, &$image, &$lastFile, &$partName), "sirius_php_file_Uploader_3"), 'execute'), null);
		}
	}
	function __toString() { return 'sirius.php.file.Uploader'; }
}
sirius_php_file_Uploader::$files = new sirius_php_file_FileCollection();
sirius_php_file_Uploader::$sizes = (new _hx_array(array()));
function sirius_php_file_Uploader_0(&$optSizes, $v) {
	{
		if(Std::is($v, _hx_qtype("Array"))) {
			sirius_php_file_Uploader::$sizes[_hx_len(sirius_php_file_Uploader::$sizes)] = _hx_anonymous(array("w" => $v[0], "h" => sirius_php_file_Uploader_4($optSizes, $v)));
		} else {
			sirius_php_file_Uploader::$sizes[_hx_len(sirius_php_file_Uploader::$sizes)] = _hx_anonymous(array("w" => $v, "h" => $v));
		}
	}
}
function sirius_php_file_Uploader_1(&$fileStream, &$lastFile, &$partName, $part, $name) {
	{
		if(sirius_tools_Utils::isValid($name)) {
			if($name !== null && $lastFile !== $name) {
				$partName = $part;
				$lastFile = $name;
				if($fileStream !== null) {
					$fileStream->close();
				}
				$type = sirius_php_file_Uploader::_getType($name);
				if($type !== null) {
					$nName = "UID-" . Std::string(sirius_php_file_Uploader_5($fileStream, $lastFile, $name, $part, $partName, $type)) . "-" . _hx_string_or_null(sirius_tools_Key::GEN(8, null, null)) . "." . _hx_string_or_null(_hx_explode(".", $name)->pop());
					$fileStream = sys_io_File::write(sirius_php_file_Uploader::_getSavePath($type, $nName), true);
					sirius_php_file_Uploader::$files->add($part, new sirius_php_file_FileInfo($type, $name, $nName));
				}
			}
		} else {
			$fileStream = null;
		}
	}
}
function sirius_php_file_Uploader_2(&$fileStream, &$lastFile, &$partName, $bytes, $pos, $len) {
	{
		if($fileStream !== null) {
			$fileStream->writeBytes($bytes, 0, $bytes->length);
		}
	}
}
function sirius_php_file_Uploader_3(&$fileStream, &$image, &$lastFile, &$partName, $v) {
	{
		if($v->type === "image") {
			sirius_utils_Dice::Values(sirius_php_file_Uploader::$sizes, array(new _hx_lambda(array(&$fileStream, &$image, &$lastFile, &$partName, &$v), "sirius_php_file_Uploader_6"), 'execute'), null);
		}
	}
}
function sirius_php_file_Uploader_4(&$optSizes, &$v) {
	if(_hx_equal(_hx_len($v), 1)) {
		return $v[0];
	} else {
		return $v[1];
	}
}
function sirius_php_file_Uploader_5(&$fileStream, &$lastFile, &$name, &$part, &$partName, &$type) {
	{
		$int = sirius_Sirius::$tick;
		if($int < 0) {
			return 4294967296.0 + $int;
		} else {
			return $int + 0.0;
		}
		unset($int);
	}
}
function sirius_php_file_Uploader_6(&$fileStream, &$image, &$lastFile, &$partName, &$v, $s) {
	{
		$p = _hx_string_or_null(sirius_php_file_Uploader::$savePathImg) . _hx_string_or_null($v->output);
		$image->open($p);
		$image->save(null, null);
		$image->fit($s->w, $s->h, true);
		$nname = _hx_explode(".", $v->output);
		$ext = $nname->pop();
		$ext = _hx_string_or_null($nname->join(".")) . "_" . Std::string($s->w) . "x" . Std::string($s->h) . "." . _hx_string_or_null($ext);
		$image->save(_hx_string_or_null(sirius_php_file_Uploader::$savePathImg) . _hx_string_or_null($ext), null);
	}
}
