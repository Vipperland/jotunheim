<?php

	namespace sirius;

	class SiriusError {
		
		public $line;
		public $message;
		
		public function __construct($line, $message = "") {
			$this->line = $line;
			$this->message = $message;
		}
		
	}
	
?>