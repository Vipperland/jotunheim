<?php

	class TextFormat {
		
		public $align;
		public $blockIndent;
		public $bold;
		public $bullet;
		public $color;
		public $display;
		public $font;
		public $indent;
		public $italic;
		public $kerning;
		public $leading;
		public $leftMargin;
		public $letterSpacing;
		public $rightMargin;
		public $size;
		public $tabStops;
		public $target;
		public $underline;
		public $url;
	
		public function __construct($font=null,$size=null,$color=null,$bold=null,$italic=null,$underline=null,$url=null,$target=null,$align=null,$leftMargin=null,$rightMargin=null,$indent=null,$leading=null){
			$this->font = $font;
			$this->size = $size;
			$this->color = $color;
			$this->bold = $bold;
			$this->italic = $italic;
			$this->underline = $underline;
			$this->url = $url;
			$this->target = $target;
			$this->align = $align;
			$this->leftMargin = $leftMargin;
			$this->rightMargin = $rightMargin;
			$this->indent = $indent;
			$this->leading = $leading;
		}


	}