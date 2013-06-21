<?php

	namespace flash\filters

	class DisplacementMapFilter {

		public $alpha;
		public $color;
		public $componentX;
		public $componentY;
		public $mapBitmap;
		public $mapPoint;
		public $mode;
		public $scaleX;
		public $scaleY;
	
		public function __construct($mapBitmap,$mapPoint,$componentX,$componentY,$scaleX,$scaleY,$mode,$color,$alpha){
			$this->mapBitmap = $mapBitmap;
			$this->mapPoint = $mapPoint;
			$this->componentX = $componentX;
			$this->componentY = $componentY;
			$this->scaleX = $scaleX;
			$this->scaleY = $scaleY;
			$this->mode = $mode;
			$this->color = $color;
			$this->alpha = $alpha;
		}


	}