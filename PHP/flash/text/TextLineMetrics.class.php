<?php


	class TextLineMetrics extends SiriusObject {

		public $ascent;
		public $descent;
		public $height;
		public $leading;
		public $width;
		public $x;
	
		public function __construct($x=null,$width=null,$height=null,$ascent=null,$descent=null,$leading=null){
			$this->x = $x;
			$this->width = $width;
			$this->height = $height;
			$this->ascent = $ascent;
			$this->descent = $descent;
			$this->leading = $leading;
		}


	}