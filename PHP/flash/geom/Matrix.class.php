<?php

	class Matrix extends SiriusObject {

		public $a;
		public $b;
		public $c;
		public $d;
		public $tx;
		public $ty;
	
		public function clone(){
			$this->runCommand('clone', func_get_args());
		}
	
		public function concat($m){
			$this->runCommand('concat', func_get_args());
		}
	
		public function copyColumnFrom($column,$vector3D){
			$this->runCommand('copyColumnFrom', func_get_args());
		}
	
		public function copyColumnTo($column,$vector3D){
			$this->runCommand('copyColumnTo', func_get_args());
		}
	
		public function copyFrom($sourceMatrix){
			$this->runCommand('copyFrom', func_get_args());
		}
	
		public function copyRowFrom($row,$vector3D){
			$this->runCommand('copyRowFrom', func_get_args());
		}
	
		public function copyRowTo($row,$vector3D){
			$this->runCommand('copyRowTo', func_get_args());
		}
	
		public function createBox($scaleX,$scaleY,$rotation,$tx,$ty){
			$this->runCommand('createBox', func_get_args());
		}
	
		public function createGradientBox($width,$height,$rotation,$tx,$ty){
			$this->runCommand('createGradientBox', func_get_args());
		}
	
		public function deltaTransformPoint($point){
			$this->runCommand('deltaTransformPoint', func_get_args());
		}
	
		public function identity(){
			$this->runCommand('identity', func_get_args());
		}
	
		public function invert(){
			$this->runCommand('invert', func_get_args());
		}
	
		public function __construct($a,$b,$c,$d,$tx,$ty){
			$this->a = $a;
			$this->b = $b;
			$this->c = $c;
			$this->d = $d;
			$this->tx = $tx;
			$this->ty = $ty;
		}
	
		public function rotate($angle){
			$this->runCommand('rotate', func_get_args());
		}
	
		public function scale($sx,$sy){
			$this->runCommand('scale', func_get_args());
		}
	
		public function setTo($aa,$ba,$ca,$da,$txa,$tya){
			$this->runCommand('setTo', func_get_args());
		}
	
		public function transformPoint($point){
			$this->runCommand('transformPoint', func_get_args());
		}
	
		public function translate($dx,$dy){
			$this->runCommand('translate', func_get_args());
		}
		
	}