<?php

	namespace flash\display

	require_once('DisplayObject.class.php');

	class Bitmap extends \flash\display\DisplayObject {

		public $bitmapData
		public $pixelSnapping
		public $smoothing
	
		public function __construct($bitmapData,$pixelSnapping,$smoothing){
			$this->bitmapData = $bitmapData;
			$this->pixelSnapping = $pixelSnapping;
			$this->smoothing = $smoothing;
		}

	}