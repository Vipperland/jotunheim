<?php

	namespace flash\filters
	
	class BevelFilter {

		public $angle;
		public $blurX;
		public $blurY;
		public $distance;
		public $highlightAlpha;
		public $highlightColor;
		public $knockout;
		public $quality;
		public $shadowAlpha;
		public $shadowColor;
		public $strength;
		public $type;
	
		public function __construct($distance,$angle,$highlightColor,$highlightAlpha,$shadowColor,$shadowAlpha,$blurX,$blurY,$strength,$quality,$type,$knockout){
			$this->distance = $distance;
			$this->angle = $angle;
			$this->highlightColor = $highlightColor;
			$this->highlightAlpha = $highlightAlpha;
			$this->shadowColor = $shadowColor;
			$this->shadowAlpha = $shadowAlpha;
			$this->blurX = $blurX;
			$this->blurY = $blurY;
			$this->strength = $strength;
			$this->quality = $quality;
			$this->type = $type;
			$this->knockout = $knockout;
		}

	}