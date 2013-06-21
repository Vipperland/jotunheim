<?php

	namespace flash\net;

	class URLVariables extends \sirius\SiriusObject {
	
		public function decode($source){
			$this->runCommand('decode', func_get_args());
		}
	
		public function __construct($source){
			$this->source = $source;
		}

	}