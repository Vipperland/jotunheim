<?php

interface sirius_modules_ILoader {
	//;
	//;
	//;
	function progress();
	function get($module, $data = null);
	function add($files, $complete = null, $error = null);
	function start($complete = null, $error = null);
	function listen($complete = null, $error = null);
}
