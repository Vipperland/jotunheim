<?php

interface sirius_net_ILoader {
	//;
	//;
	//;
	//;
	function progress();
	function get($module, $data = null);
	function async($file, $data = null, $handler = null);
	function add($files);
	function start();
	function request($url, $data = null, $handler = null, $method = null, $headers = null);
}
