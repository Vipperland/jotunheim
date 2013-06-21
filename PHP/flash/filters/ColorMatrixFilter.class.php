<?php

	namespace flash\filters
	
	class ColorMatrixFilter {

		public $matrix;
	
		public function __construct($matrix){
			$this->matrix = $matrix;
		}

	}