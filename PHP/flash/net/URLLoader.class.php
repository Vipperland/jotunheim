<?php

	namespace flash\net;

	class URLLoader extends \sirius\SiriusObject {

		public $bytesLoaded;
		public $bytesTotal;
		public $dataFormat;
	
		public function close(){
			$this->runCommand('close', func_get_args());
		}
	
		public function load($request){
			$this->runCommand('load', func_get_args());
		}
	
		public function __construct($request){
			$this->request = $request;
		}

	}