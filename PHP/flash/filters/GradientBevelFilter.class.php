<?php

	namespace flash\filters
	
	class GradientBevelFilter {

		public $alphas;
		public $angle;
		public $blurX;
		public $blurY;
		public $colors;
		public $distance;
		public $knockout;
		public $quality;
		public $ratios;
		public $strength;
		public $type;
	
		public function __construct($distance,$angle,$colors,$alphas,$ratios,$blurX,$blurY,$strength,$quality,$type,$knockout){
			$this->distance = $distance;
			$this->angle = $angle;
			$this->colors = $colors;
			$this->alphas = $alphas;
			$this->ratios = $ratios;
			$this->blurX = $blurX;
			$this->blurY = $blurY;
			$this->strength = $strength;
			$this->quality = $quality;
			$this->type = $type;
			$this->knockout = $knockout;
		}


	}