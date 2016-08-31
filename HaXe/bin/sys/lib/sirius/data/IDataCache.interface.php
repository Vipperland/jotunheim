<?php

interface sirius_data_IDataCache {
	function get_data();
	//;
	function json($print = null);
	function base64($print = null);
	function refresh();
	function clear($p = null);
	function set($p, $v);
	function get($id = null);
	function exists($name = null);
	function save();
	function load();
}
