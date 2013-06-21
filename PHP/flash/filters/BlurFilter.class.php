<?php

	namespace flash\filters
	
	class BlurFilter {

		public $blurX;
		public $blurY;
		public $quality;
	
		public function __construct($blurX,$blurY,$quality){
			$this->blurX = $blurX;
			$this->blurY = $blurY;
			$this->quality = $quality;
		}

	}