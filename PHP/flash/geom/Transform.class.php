<?php

	class Transform extends SiriusObject {

		public $colorTransform;
		public $matrix;
		public $matrix3D;
		public $perspectiveProjection;
	
		public function getRelativeMatrix3D($relativeTo){
			$this->runCommand('getRelativeMatrix3D', func_get_args());
		}
	
		public function __construct($displayObject){
			$this->displayObject = $displayObject;
		}

	}