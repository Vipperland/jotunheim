<?php

interface sirius_modules_ILoader {
	function get($module, $data = null);
	function add($files, $complete = null, $error = null);
	function start();
}
