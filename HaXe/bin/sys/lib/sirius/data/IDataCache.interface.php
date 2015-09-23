<?php

interface sirius_data_IDataCache {
	function json($print = null);
	function refresh();
	function clear($p = null);
	function set($p, $v);
	function get($id = null);
	function exists($name = null);
	function save();
	function load();
	function getData();
}
