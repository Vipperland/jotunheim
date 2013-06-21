<?php

	class ColorTransform extends SiriusObject {

		public $alphaMultiplier;
		public $alphaOffset;
		public $blueMultiplier;
		public $blueOffset;
		public $greenMultiplier;
		public $greenOffset;
		public $redMultiplier;
		public $redOffset;
		public $color;
	
		public function __construct($redMultiplier,$greenMultiplier,$blueMultiplier,$alphaMultiplier,$redOffset,$greenOffset,$blueOffset,$alphaOffset){
			$this->redMultiplier = $redMultiplier;
			$this->greenMultiplier = $greenMultiplier;
			$this->blueMultiplier = $blueMultiplier;
			$this->alphaMultiplier = $alphaMultiplier;
			$this->redOffset = $redOffset;
			$this->greenOffset = $greenOffset;
			$this->blueOffset = $blueOffset;
			$this->alphaOffset = $alphaOffset;
		}
	
		public function concat($second){
			$this->runCommand('concat', func_get_args());
		}

	}