<?php

	class Rectangle extends SiriusObject {

		public $height;
		public $width;
		public $x;
		public $y;
		public $bottom;
		public $bottomRight;
		public $left;
		public $right;
		public $size;
		public $top;
		public $topLeft;
	
		public function contains($x,$y){
			$this->runCommand('contains', func_get_args());
		}
	
		public function containsPoint($point){
			$this->runCommand('containsPoint', func_get_args());
		}
	
		public function containsRect($rect){
			$this->runCommand('containsRect', func_get_args());
		}
	
		public function copyFrom($sourceRect){
			$this->runCommand('copyFrom', func_get_args());
		}
	
		public function equals($toCompare){
			$this->runCommand('equals', func_get_args());
		}
	
		public function inflate($dx,$dy){
			$this->runCommand('inflate', func_get_args());
		}
	
		public function inflatePoint($point){
			$this->runCommand('inflatePoint', func_get_args());
		}
	
		public function intersection($toIntersect){
			$this->runCommand('intersection', func_get_args());
		}
	
		public function intersects($toIntersect){
			$this->runCommand('intersects', func_get_args());
		}
	
		public function isEmpty(){
			$this->runCommand('isEmpty', func_get_args());
		}
	
		public function offset($dx,$dy){
			$this->runCommand('offset', func_get_args());
		}
	
		public function offsetPoint($point){
			$this->runCommand('offsetPoint', func_get_args());
		}
	
		public function __construct($x,$y,$width,$height){
			$this->x = $x;
			$this->y = $y;
			$this->width = $width;
			$this->height = $height;
		}
	
		public function setEmpty(){
			$this->runCommand('setEmpty', func_get_args());
		}
	
		public function setTo($xa,$ya,$widtha,$heighta){
			$this->runCommand('setTo', func_get_args());
		}
	
		public function union($toUnion){
			$this->runCommand('union', func_get_args());
		}


	}