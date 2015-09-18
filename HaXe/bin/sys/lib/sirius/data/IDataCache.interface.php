<?php

interface sirius_data_IDataCache {
	function json($print = null);
	function refresh();
	function clear($p = null);
	function set($p, $v);
	function get($id = null);
	function exists($name);
	function save();
	function load();
	function getData();
	function base64();
	function isExpired();
}
