<?php

	namespace sirius;
	
	class SiriusEncoder {

		public static function getValue ($object, $propertyFilter = null, $ident = "") {
			return self::_toString($object, $ident, null, null, "", $propertyFilter);
		}

		static private function _toString($object, $ident, $paramName = null, $signature = false, $result = "", $propertyFilter = null) {
			
			if (strpos($paramName, 'up_') === 0) {
				if (isset($object[$paramName])) {
					$paramName = '*' . substr($paramName, 3, strlen($paramName) - 3);
				} else {
					return "";
				}
			}
			elseif (!isset($object)) {
				return "";
			}
			
			$nextident = $ident . "	";
			
			if (is_object($object)) {
			
				$className = self::_parseName($object);
				
				if (!isset($paramName) || is_numeric($paramName)) {
					$result .=  $ident . "#" . $className . "{\r\n";
				} elseif ($signature) {
					$result .=  $ident . $paramName . ":" . $className . "{\r\n";
				}
				
				foreach($object as $param => $value) {
					if (isset($propertyFilter[$className])) { 
						if (isset($propertyFilter[$className][$param])) { 
							if ($propertyFilter[$className][$param] == false) {
								continue;
							}
						}
					}
					$result .= self::_toString($value, $nextident, $param, is_object($value), "", $propertyFilter); 
				}
				
				if (is_a($object, 'sirius\SiriusObject')) {
					$result .=  $object->dumpCommands($nextident);
				}
				
				if ($signature || !isset($paramName)) {
					$result .=  $ident . "}\r\n";
				}
				
			} else if (is_array($object) && !($object instanceof self)) {
				
				if (isset($paramName) || is_numeric($paramName)) {
					$result .=  $ident . $paramName . ":Array{" . "\r\n";
				} else if ($signature) {
					$result .=  $ident . $paramName . "#Array {\r\n";
				}
				
				$vars = get_object_vars ($object);	
				
				foreach($vars as $param => $value) {
					$result .= self::_toString($value, $nextident, null, false, "", $propertyFilter); 
				}
				
				if (isset($paramName)) {
					$result .=  $ident . "}" . "\r\n";
				} else if ($signature) {
					$result .=  $ident . $paramName . "}\r\n";
				}
				
			} else {
				$result .= $ident . (isset($paramName) ? $paramName . "=" : "") . $object . "\r\n";
			}
			
			return $result;
			
		}
		
		private static function _parseName($object) {
			$name = get_class($object);
			if (strpos($name, "\\")) {
				$name = explode("\\", $name);
				$name = $name[count($name) - 1];
			}
			return $name;
		}
	}
	
?>