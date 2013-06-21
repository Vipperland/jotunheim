<?php

	namespace flash\filters
	
	class ConvolutionFilter {

		public $alpha;
		public $bias;
		public $clamp;
		public $color;
		public $divisor;
		public $matrix;
		public $matrixX;
		public $matrixY;
		public $preserveAlpha;
	
		public function __construct($matrixX,$matrixY,$matrix,$divisor,$bias,$preserveAlpha,$clamp,$color,$alpha){
			$this->matrixX = $matrixX;
			$this->matrixY = $matrixY;
			$this->matrix = $matrix;
			$this->divisor = $divisor;
			$this->bias = $bias;
			$this->preserveAlpha = $preserveAlpha;
			$this->clamp = $clamp;
			$this->color = $color;
			$this->alpha = $alpha;
		}


	}