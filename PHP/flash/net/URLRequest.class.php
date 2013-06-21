<?php

	namespace flash\net;

	class URLRequest {

		public $contentType;
		public $data;
		public $digest;
		public $method;
		public $requestHeaders;
		public $url;
	
		public function __construct($url){
			$this->url = $url;
		}

	}