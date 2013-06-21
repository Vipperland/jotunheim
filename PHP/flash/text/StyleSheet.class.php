<?php

	class StyleSheet extends SiriusObject {

		public function clear(){
			$this->runCommand('clear', funct_get_args());
		}
	
		public function getStyle($styleName){
			$this->runCommand('getStyle', funct_get_args());
		}
	
		public function parseCSS($CSSText){
			$this->runCommand('parseCSS', funct_get_args());
		}
	
		public function setStyle($styleName,$styleObject){
			$this->runCommand('setStyle', funct_get_args());
		}

		public function transform($formatObject){
			$this->runCommand('transform', funct_get_args());
		}


	}