<?php

namespace sirius;

class SiriusDecoder 
{
	private static $_errors = array();
	
	private static $_classAlias = array();

	public static $enableDefaultObjects = false;
	
	public static $enableDynamicProperty = true;
	
  
  /**
   * 
   */
	private static function _getClassAlias ($className) {
		$class = (isset(self::$_classAlias[$className]))?
			self::$_classAlias[$className]: 
			$className;
		
		return $class;
	}
	
  
  /**
   * 
   */
	public static function registerClass () {
		$args = func_get_args();
		foreach ($args as $key => $class) {
			if (strpos($class, "\\") === false)
				continue;
				
			$class_name = explode("\\", $class);
			self::$_classAlias[$class_name[count($class_name) -1]] = $class;
		}
	}
	
  
  /**
   * 
   */
	public static function hasErrors () {
		return count(self::$_errors) > 0;
	}
	
  
  /**
   * 
   */
	public static function getErrors () {
		return self::$_errors;
	}
	
  
  /**
   * 
   */
	private static function _setError ($line, $message, $code = 0) {
		self::$_errors[] = new \sirius\SiriusError($line, $message, $code);
	}
	
  
  /**
   * 
   */
	private static function _getLines ($value) {
		$value = explode("\r\n", $value);
		$value = implode("<<_BREAK_>>", $value);
		$value = explode("\r", $value);
		$value = implode("<<_BREAK_>>", $value);
		$value = explode("\n", $value);
		$value = implode("<<_BREAK_>>", $value);
		$value = explode("<<_BREAK_>>", $value);
		return $value;
	}
	
  
  /**
   * 
   */
	private static function _clearSpaces ($value) {
		$value = explode(" ", $value);
		$value = implode("", $value);
		$value = explode("	", $value);
		$value = implode("", $value);
		
		return $value;
	}
	
  
  /**
   * 
   */
	private static function _lastIndexOf ($value, $search) {
		$index = strpos(strrev($value), strrev($search));
    $last_index = $index ? 
      strlen($value) - strlen($search) - $index : 
      -1;
		return $last_index;
	}
	
  
  /**
   * 
   */
	private static function _removeComments ($value) {
		$index = strpos($value, "//");
		
		if ($index === false) {
		  // do nothing
		} 
		elseif ($index == 0) 
		  $value = "";
		elseif (substr($value, $index - 2, 2) !== "p:")	
		  $value = substr($value, 0, $index);
		
		return $value;
	}
	
  
  /**
   * 
   */
	private static function _getPath ($rootObject, $path, $classValue, $currentLine) {
		$currentObject = $rootObject;
		$pushObject = null;
		
		foreach ($path as $pathName) {
			if (!isset($currentObject->{$pathName})) {
				$pushObject = new $classValue;
				try {
					if (is_numeric($pathName)) {
						if (is_a($currentObject, "sirius\SiriusObject"))
							$currentObject->push($pushObject);
					} 
					else
						$currentObject->{ $pathName } = $pushObject;
				} 
				catch (Exception $error) {
					self::_setError ($currentLine, "Error: Can't create property '{$paramName}' in [" . (get_class($currentObject)) . "].", 0);
				}
			}
			else
				$pushObject = $currentObject->{$pathName};
			$currentObject = $pushObject;
		}
		return $currentObject;
	}
	
  
  /**
   * 
   */
	private static function _searchForParamValue($alias) {
		$path = explode(".", $alias);
		$size = count($path);
		
		if ($size == 1)
			$alias = self::_getClassAlias($alias);
		elseif ($size > 1) {
			$targetClass = self::_getClassAlias($path[0]);
			unset($path[0]);
			echo $targetClass;
			$alias = self::_getPath($targetClass, $path, null, null);
		}
		else
			$alias = null;
		
		return $alias;
	}
	
  
  /**
   * 
   */
	public static function getValue($value) {
	
		self::$_errors = array();

		$value = self::_getLines($value);
    
		$totalLines = count($value);
		
		$mainObject = new \sirius\SiriusObject();
		$currentObject = $mainObject;
		
		$isCommentBlock = false;
		$waitForBracerClose = 0;
		$waitForRunFunctionEnd = 0;
		
		$lb = "<br />\r\n";
		
		$path = array();
		
    $currentLineCount = 0;
		while ($currentLineCount < $totalLines) {
			$currentLine = $currentLineCount;
			++$currentLineCount;

			$index = -1;
			$normalLine = $value[$currentLine];

			if ($isCommentBlock){
				$index = strpos($clearLine, "*/");
				if ($index === false)	
					continue;
				$normalLine = substr($normalLine, $index, count($normalLine) - $index - 2);
				$isCommentBlock = false;
				if (strlen($normalLine) == 0) 
					continue;
			}
			
			$clearLine = self::_removeComments($normalLine);
			$clearLine = self::_clearSpaces($clearLine);
      
			if (strlen($clearLine) == 0) 
				continue;

			// Search for comments
			if (strpos($clearLine, "/*") !== false) {
				$index = strpos($clearLine, "*/");
				if ($index == -1) {
					$isCommentBlock = true;
					continue;
				}
				$clearLine = substr($clearLine, $index + 2, strlen($clearLine) - $index - 2);
				$clearLine = self::_clearSpaces($clearLine);
				if (strlen($clearLine) == 0) 
					continue;
			}
			
			// clar whitespaces at the end of the line
			while (substr($normalLine, strlen($normalLine) - 1) == " ") 
				$normalLine = substr($normalLine, 0, strlen($normalLine) - 1);
			
			$cmdChar1 = substr($clearLine, 0, 1);
			
			if (strpos($clearLine, "[Inject<") === 0) {
				continue; // ignore injections
			  
				$clearLine = substr($clearLine, 8, strlen($clearLine) - 9);
				$index = strpos($clearLine, "=");
				if($index > 0){
					$refValue = explode("=", $clearLine, 2);
					$paramName = $refValue[0];
					$paramValue = self::_searchForParamValue($refValue[1]);
					$currentObject->pushVariable($paramName, $paramValue);
				} else {
					$paramValue = self::_searchForParamValue($clearLine);
					$currentObject->push($paramValue);
				}
				continue;
			}
			elseif ($cmdChar1 == "~") { 
			  // Skip run function command
				if ($waitForBracerClose > 0) 
				  continue;
				$index = strpos($clearLine, "()", 1);
				$arguments = "";
				if ($index === false) {
					$index = strpos($clearLine, "(", 1);
					$functionName = substr($clearLine, 1, $index - 1);
					if ($index !== false) {
						$functionName = substr($clearLine, 1, $index - 1);

						if (method_exists($currentObject, $functionName)) {
							$openedBracers = 0;
							while ($currentLineCount < $totalLines) {
								$normalLine = $value[$currentLineCount];
								++$currentLineCount;
								$index = strpos($normalLine, "/*");
								$isCommentBlock = ($index !== false);

								if ($isCommentBlock) {
									$cend = strpos($normalLine, "*/");
									if ($cend === false) 
									  continue;
									$nline = substr($normalLine, $index, $cend - $index);
									$normalLine = explode($nline, $normalLine);
									$normalLine = implode("", $normalLine);
									$isCommentBlock = false;
								}
								$clearLine = self::_clearSpaces($normalLine);
								
								if (strpos($clearLine, "(") === strlen($clearLine) - 1) 
									++$openedBracers;
								
								if (strpos($clearLine, ")") === 0) {
									if ($openedBracers == 0) 
										break;
									--$openedBracers;
								}
								else
									$arguments .= $normalLine . "\r\n";
							}
						}
						else
							self::_setError($currentLine, "Function '$functionName' no found in [" . get_class($currentObject) . "]");
					}
				}
				else
					$functionName = substr($clearLine, 1, $index - 1);
				
				if (!isset($functionName)) 
					continue;
				
				if (!method_exists($currentObject, $functionName)) {
					self::_setError($currentLine, "Function '$functionName' no found in [" . get_class($currentObject) . "]");
					continue;
				}
				
				if (strlen($arguments) > 0) {
					$arguments = "#SiriusObject{\r\n{$arguments}}";
					$arguments = self::getValue($arguments)->{ 0 };
					call_user_func_array(array($currentObject, $functionName), get_object_vars($arguments));
				}
				else
					$currentObject->{ $functionName } ();
				continue;
			} 
			elseif ($cmdChar1 == "#") { 
			  // Push a Typed Object
				$index = strpos($clearLine, "{");
				if ($index !== false) {
					$className = substr($clearLine, 1, $index - 1);
					$className = self::_getClassAlias($className);
				} 
				else {
					$className = substr($clearLine, 1, strlen($clearLine) - 1);
					$className = self::_getClassAlias($className);
					if ($className == "Object" || $className == "Array") 
						$className = "sirius\SiriusObject";
					elseif (!class_exists($className)) {
						if (self::$enableDefaultObjects) 
							$className = "sirius\SiriusObject";
						else {
							self::_setError($currentLine, "Definition Class '{$className}' not found.");
							continue;
						}
					}
					$currentObject->push(new $className);
					continue;
				}
				$clearLine = $currentObject->getLength() . ":" . $className . "{";
			}
			
			$index = strpos($normalLine, "=", 1);
			if (false !== $index) {
				if ($waitForBracerClose > 0)
					continue;
				$paramName = substr($clearLine, 0, strpos($clearLine, "=", 1));
				$paramValue = substr($normalLine, $index + 1, strlen($normalLine) - $index - 1);

				while (" " == substr($paramValue, 0, 1))
					$paramValue = substr($paramValue, 1, strlen($paramValue) - 1);
					
				while ("  " == substr($paramValue, 0, 1))
					$paramValue = substr($paramValue, 1, strlen($paramValue) - 1);
				
				if (!property_exists($currentObject, $paramName)) {
					if (!self::$enableDynamicProperty && !is_a($currentObject, "sirius\SiriusObject")) {
						self::_setError($currentLine, "Property '{$paramName}' not exists in [" . (get_class($currentObject)) . "].");
						continue;
					}
				}
				
				if (0 == strlen($paramValue))
					$currentObject->{$paramName} = "";
				elseif (true === is_numeric($paramValue))
					$currentObject->{$paramName} = (float)$paramValue;
				elseif ("true" == $paramValue || "false" == $paramValue)
					$currentObject->{$paramName} = $paramValue == "true";
				elseif ("null" == $paramValue)
					$currentObject->{$paramName} = null;
				else
					$currentObject->{$paramName} = $paramValue;
				
				continue;
				
			} 
			elseif (strpos($clearLine, "{}") > 1) {
			  // Create empty object
				$className = substr($clearLine, 0, strlen(substr) - 2);
				$className = self::_getClassAlias($className);
				if ($className == "Object" || $className == "Array") 
					$className = "sirius\SiriusObject";
				elseif (!class_exists($className)) {
					if (self::$enableDefaultObjects)
						$className = "sirius\SiriusObject";
					else {
						self::_setError($currentLine, "Definition Class '{$className}' not found.");
						continue;
					}
				}
				$currentObject->push(new $className);
				continue;
			} 
			else if (strpos($clearLine, "{") > 0) {
			  // Open named Object
				$paramName = substr($clearLine, 0, strlen($clearLine) - 1);
				$index = strpos($paramName, ":", 0);
				if ($index > 0){
					$className = substr($paramName, $index + 1, strlen($paramName));
					$className = self::_getClassAlias($className);
					if ($className == "Object" || $className == "Array") 
						$className = "sirius\SiriusObject";
					else if (!class_exists($className)) {
						if (self::$enableDefaultObjects) 
							$className = "sirius\SiriusObject";
						else {
							self::_setError($currentLine, "Definition Class '{$className}' not found.");
							++$waitForBracerClose;
							continue;
						}
					}
					$paramName = substr($paramName, 0, $index);
				}
				$path[count($path)] = $paramName;
				$currentObject = self::_getPath($mainObject, $path, $className, $currentLine);
				$classType = null;
				continue;
			} 
			elseif (strpos($clearLine, "{") !== false) {
			  // Push a default Object
				if ($waitForBracerClose > 0)
					++$waitForBracerClose;
				
				if (is_a($currentObject, "sirius\SiriusObject")) {
					$path[count($path)] = $currentObject->getLength();
				}
				else{
					self::_setError($currentLine, "Can't push a value into [" . (get_class($currentObject)) . "].");
					++$waitForBracerClose;
					continue;
				}
				$currentObject = self::_getPath($mainObject, $path, "sirius\SiriusObject", $currentLine);
				continue;
				
			} 
			else if (strpos($clearLine, "}") !== false) {
			  // Close last Object
				if ($waitForBracerClose > 0){
					--$waitForBracerClose;
					continue;
				}
				unset($path[count($path) - 1]);
				$currentObject = self::_getPath($mainObject, $path, null, $currentLine);
				continue;
			} 
			elseif (strpos($clearLine, ".") === 0) { 
			  // Line break concat
				if (!property_exists($currentObject, $paramName)) {
					if (!self::$enableDynamicProperty) {
						self::_setError($currentLine, "Can't concat value. Property '{$paramName}' not exists in [" . (get_class($currentObject)) . "].");
						continue;
					}
				}
				$index = strpos($line, ".");
				$paramValue = substr($line, $index + 1, strlen($line) - $index - 1);
				$currentObject->{$paramValue} .= "\r\n" + $paramValue;
				continue;
			}
			else {
				$index = strpos($clearLine, ":");
				if ($index !== false) {
					$paramName = substr($clearLine, $index + 1, 1);
					if ($paramName == "#") {
						$paramName = substr($clearLine, 0, $index);
						$className = substr($clearLine, $index + 2, strlen($clearLine) - $index - 2);
						$className = self::_getClassAlias($className);
						if ($className == "Object" || $className == "Array") 
							$className = "sirius\SiriusObject";
						elseif (!class_exists($className)) {
							if (self::$enableDefaultObjects) 
								$className = "sirius\SiriusObject";
							else {
								self::_setError($currentLine, "Definition Class ['{$className}'] not found.");
								continue;
							}
						}
						continue;
					}
				}
				
				while (substr($normalLine, 0, 1) == "	")
					$normalLine = substr($normalLine, 1, strlen($normalLine) - 1);
				
				while (substr($normalLine, 0, 1) == " ")
					$normalLine = substr($normalLine, 1, strlen($normalLine) - 1);
				
				if (is_a($currentObject, "sirius\SiriusObject"))
					$currentObject->push($normalLine);
				else {
					self::_setError($currentLine, "Can't push the value '{$normalLine}' into [" . (get_class($currentObject)) . "].");
					continue;
				}
				continue;
			}
		}
		
		return $mainObject;
	}
}
?>