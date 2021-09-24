<?php

	require_once 'URLRequest.class.php';
	
	namespace flash\net;

	class URLLoader extends \sirius\SiriusObject {

		public $bytesLoaded;
		public $bytesTotal;
		public $dataFormat;
		public $request;
	
		public function close(){
			$this->runCommand('close', func_get_args());
		}
	
		public function load($request){
			if (is_string($request))
				$request = new flash\net\URLRequest($request);
			$this->runCommand('load', func_get_args());
		}
	
		public function __construct($request){
			if (is_string($request))
				$request = new flash\net\URLRequest($request);
			$this->request = $request;
		}

	}