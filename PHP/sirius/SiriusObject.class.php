<?php

	namespace sirius;

	class SiriusObject {

		private $_length = 0;

		private $_commands = array();

		private $_position = 0;

		private $_references = array();

		public function encode () {
			$data = array();
			foreach ($this as $var => $value)
				$this->encodeVariable($data, $var, $value);
			return $data;
		}

		/**
		* 
		*/
		public function encodeVariable (&$data, $var, $value) {
			if ($value)
				$data[$var] = $value;
			return $this;
		}


		public function isArray() {
			return (bool) $this->_length > 0;
		}
		
		public function toArray() {
			$ar = array();
			$i = 0;
			while ($i < $this->_length) {
				$ar[$i] = $this->{ $i };
				++$i;
			}
			return $ar;
		}

		public function getParam ($index) {
			return $this->{$index};
		}

		public function push() {
			$args = func_get_args();
			foreach($args as $value)
				$this->pushVariable ($this->getLength(), $value);
		}

		public function pushVariable ($variable, $value) {
			$this->{$variable} = $value;
			++$this->_length;
		}

		public function addReference ($reference) {
			$this->_references[$this->getLength()] = $reference;
			$this->push ($reference);
		}

		public function getReferences () {
			return $this->_references;
		}

		public function getLength() {
			return $this->_length;
		}

		public function runCommand ($name, $params = array()) {
			$this->_commands[] = array ($name, $params);
		}

		public function getCommands() {
			return $this->_commands;
		}

		public function dumpCommands ($ident = "	") {
			$result = "";
			foreach($this->_commands as $key => $value) {
				$key = $value[0];
				$value = $value[1];
				$count = count($value);
				$result .= "{$ident}~{$key}(";
				if ($count > 0) {
					$result .= "\r\n";
					foreach($value as $key => $param) {
						if (is_object($param)) {
							$result .= SiriusEncoder::getValue($param, null, $ident . "	");
						}
						else 
							$result .= "{$ident}	{$param}\r\n";
					}
					$result .= "{$ident}";
				}
				$result .= ")\r\n";
				return $result;
			}
		}
	}

?>