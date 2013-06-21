<?php

	namespace flash\display;

	require_once('DisplayObject.class.php');
	
	class Sprite extends \flash\display\DisplayObject {
		
		public $contextMenu;
		public $doubleClickEnabled;
		public $focusRect;
		public $mouseEnabled;
		public $tabEnabled;
		public $tabIndex;
		public $alpha;
		public $blendMode;
		public $blendShader;
		public $cacheAsBitmap;
		public $filters;
		public $height;
		public $name;
		public $opaqueBackground;
		public $rotation;
		public $rotationX;
		public $rotationY;
		public $rotationZ;
		public $scale9Grid;
		public $scaleX;
		public $scaleY;
		public $scaleZ;
		public $scrollRect;
		public $up_transform;
		public $visible;
		public $width;
		public $x;
		public $y;
		public $z;
		
		public $mouseChildren;
		public $tabChildren;
	
		public function addChild($child){
			$this->runCommand('addChild', func_get_args());
		}
	
		public function addChildAt($child,$index){
			$this->runCommand('addChildAt', func_get_args());
		}

		public function removeChild($child){
			$this->runCommand('removeChild', func_get_args());
		}
	
		public function removeChildAt($index){
			$this->runCommand('removeChildAt', func_get_args());
		}
	
		public function removeChildren($beginIndex,$endIndex){
			$this->runCommand('removeChildren', func_get_args());
		}

	}