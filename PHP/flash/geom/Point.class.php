<?php

	class Point extends SiriusObject {

		public $x;
		public $y;
	
		public function add($v){
			$this->runCommand('add', func_get_args());
		}
	
		public function clone(){
			$this->runCommand('clone', func_get_args());
		}
	
		public function copyFrom($sourcePoint){
			$this->runCommand('copyFrom', func_get_args());
		}
	
		public static function distance($pt1,$pt2){
			$this->runCommand('distance', func_get_args());
		}
	
		public function equals($toCompare){
			$this->runCommand('equals', func_get_args());
		}
	
		public static function interpolate($pt1,$pt2,$f){
			$this->runCommand('interpolate', func_get_args());
		}
	
		public function normalize($thickness){
			$this->runCommand('normalize', func_get_args());
		}
	
		public function offset($dx,$dy){
			$this->runCommand('offset', func_get_args());
		}
	
		public function __construct($x,$y){
			$this->x = $x;
			$this->y = $y;
		}
	
		public static function polar($len,$angle){
			$this->runCommand('polar', func_get_args());
		}
	
		public function setTo($xa,$ya){
			$this->runCommand('setTo', func_get_args());
		}
	
		public function subtract($v){
			$this->runCommand('subtract', func_get_args());
		}
	
		public function toString(){
			$this->runCommand('toString', func_get_args());
		}


	}