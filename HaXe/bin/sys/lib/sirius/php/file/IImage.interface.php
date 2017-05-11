<?php

interface sirius_php_file_IImage {
	function open($file);
	function resample($width, $height, $ratio = null);
	function crop($x, $y, $width, $height);
	function fit($width, $height, $slice = null);
	function save($name = null, $type = null);
	function dispose();
	function isValid();
}
