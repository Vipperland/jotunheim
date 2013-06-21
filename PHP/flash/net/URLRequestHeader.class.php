<?php

	namespace flash\net;

	class URLRequestHeader {

		public $name;
		public $value;
	
		public function __construct($name,$value){
			$this->name = $name;
			$this->value = $value;
		}

	}