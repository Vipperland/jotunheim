<?php

	namespace flash\display;

	require_once('Sprite.class.php');
	
	class Loader extends \flash\display\Sprite {

		public function close(){
			$this->runCommand('close', func_get_args());
		}
	
		public function load($request,$context = null){
			$this->runCommand('load', func_get_args());
		}
	
		public function loadBytes($bytes,$context){
			$this->runCommand('loadBytes', func_get_args());
		}
	
		public function __construct($request = null) {
			if (isset($request)) $this->load($request);
		}
	
		public function unload(){
			$this->runCommand('unload', func_get_args());
		}
	
		public function unloadAndStop($gc){
			$this->runCommand('unloadAndStop', func_get_args());
		}

	}