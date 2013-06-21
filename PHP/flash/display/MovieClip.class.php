<?php

	namespace flash\display;

	require_once('Sprite.class.php');

	class MovieClip extends \flash\display\Sprite {

		public $enabled;
		public $trackAsMenu;
	
		public function addFrameScript(){
			$this->runCommand('addFrameScript', func_get_args());
		}
	
		public function gotoAndPlay($frame,$scene){
			$this->runCommand('gotoAndPlay', func_get_args());
		}
	
		public function gotoAndStop($frame,$scene){
			$this->runCommand('gotoAndStop', func_get_args());
		}

		public function nextFrame(){
			$this->runCommand('nextFrame', func_get_args());
		}
	
		public function nextScene(){
			$this->runCommand('nextScene', func_get_args());
		}
	
		public function play(){
			$this->runCommand('play', func_get_args());
		}
	
		public function prevFrame(){
			$this->runCommand('prevFrame', func_get_args());
		}
	
		public function prevScene(){
			$this->runCommand('prevScene', func_get_args());
		}
	
		public function stop(){
			$this->runCommand('stop', func_get_args());
		}

	}