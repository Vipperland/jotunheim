<?php

interface sirius_modules_ILoader {
	//;
	//;
	//;
	function progress();
	function get($module, $data = null);
	function async($file, $data = null, $handler = null);
	function add($files, $complete = null, $error = null);
	function start($complete = null, $error = null);
	function listen($complete = null, $error = null);
	function unlisten($handler = null);
	function onChange($handler);
	function request($url, $data = null, $handler = null, $method = null);
}
