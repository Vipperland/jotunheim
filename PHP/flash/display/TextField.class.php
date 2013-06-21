<?php

	namespace flash\display;

	require_once('Sprite.class.php');
	
	class TextField extends \flash\display\Sprite {

		public $alwaysShowSelection;
		public $antiAliasType;
		public $autoSize;
		public $background;
		public $backgroundColor;
		public $border;
		public $borderColor;
		public $condenseWhite;
		public $defaultTextFormat;
		public $displayAsPassword;
		public $embedFonts;
		public $gridFitType;
		public $htmlText;
		public $maxChars;
		public $mouseWheelEnabled;
		public $multiline;
		public $restrict;
		public $scrollH;
		public $scrollV;
		public $selectable;
		public $sharpness;
		public $styleSheet;
		public $text;
		public $textColor;
		public $thickness;
		public $type;
		public $useRichTextClipboard;
		public $wordWrap;
	
		public function appendText($newText){
			$this->runCommand('appendText', funct_get_args());
		}
	
		public function copyRichText(){
			$this->runCommand('copyRichText', funct_get_args());
		}
	
		public function getCharBoundaries($charIndex){
			$this->runCommand('getCharBoundaries', funct_get_args());
		}
	
		public function getCharIndexAtPoint($x,$y){
			$this->runCommand('getCharIndexAtPoint', funct_get_args());
		}
	
		public function getFirstCharInParagraph($charIndex){
			$this->runCommand('getFirstCharInParagraph', funct_get_args());
		}
	
		public function getImageReference($id){
			$this->runCommand('getImageReference', funct_get_args());
		}
	
		public function getLineIndexAtPoint($x,$y){
			$this->runCommand('getLineIndexAtPoint', funct_get_args());
		}
	
		public function getLineIndexOfChar($charIndex){
			$this->runCommand('getLineIndexOfChar', funct_get_args());
		}
	
		public function getLineLength($lineIndex){
			$this->runCommand('getLineLength', funct_get_args());
		}
	
		public function getLineMetrics($lineIndex){
			$this->runCommand('getLineMetrics', funct_get_args());
		}
	
		public function getLineOffset($lineIndex){
			$this->runCommand('getLineOffset', funct_get_args());
		}
	
		public function getLineText($lineIndex){
			$this->runCommand('getLineText', funct_get_args());
		}
	
		public function getParagraphLength($charIndex){
			$this->runCommand('getParagraphLength', funct_get_args());
		}
	
		public function getRawText(){
			$this->runCommand('getRawText', funct_get_args());
		}
	
		public function getTextFormat($beginIndex,$endIndex){
			$this->runCommand('getTextFormat', funct_get_args());
		}
	
		public function getTextRuns($beginIndex,$endIndex){
			$this->runCommand('getTextRuns', funct_get_args());
		}
	
		public function getXMLText($beginIndex,$endIndex){
			$this->runCommand('getXMLText', funct_get_args());
		}
	
		public function insertXMLText($beginIndex,$endIndex,$richText,$pasting){
			$this->runCommand('insertXMLText', funct_get_args());
		}
	
		public static function isFontCompatible($fontName,$fontStyle){
			$this->runCommand('isFontCompatible', funct_get_args());
		}
	
		public function pasteRichText($richText){
			$this->runCommand('pasteRichText', funct_get_args());
		}
	
		public function replaceSelectedText($value){
			$this->runCommand('replaceSelectedText', funct_get_args());
		}
	
		public function replaceText($beginIndex,$endIndex,$newText){
			$this->runCommand('replaceText', funct_get_args());
		}
	
		public function setSelection($beginIndex,$endIndex){
			$this->runCommand('setSelection', funct_get_args());
		}
	
		public function setTextFormat($format,$beginIndex,$endIndex){
			$this->runCommand('setTextFormat', funct_get_args());
		}

	}