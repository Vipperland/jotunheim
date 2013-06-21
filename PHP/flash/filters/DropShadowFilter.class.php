<?php

	namespace flash\filters
	
	class DropShadowFilter {

		public $alpha;
		public $angle;
		public $blurX;
		public $blurY;
		public $color;
		public $distance;
		public $hideObject;
		public $inner;
		public $knockout;
		public $quality;
		public $strength;
	
		public function __construct($distance,$angle,$color,$alpha,$blurX,$blurY,$strength,$quality,$inner,$knockout,$hideObject){
			$this->distance = $distance;
			$this->angle = $angle;
			$this->color = $color;
			$this->alpha = $alpha;
			$this->blurX = $blurX;
			$this->blurY = $blurY;
			$this->strength = $strength;
			$this->quality = $quality;
			$this->inner = $inner;
			$this->knockout = $knockout;
			$this->hideObject = $hideObject;
		}


	}