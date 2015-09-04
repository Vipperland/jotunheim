<?php

interface sirius_data_IDataSet {
	function get($p);
	function set($p, $v);
	function exists($p);
	function clear();
	function find($v);
	function index();
	function values();
	function filter($p, $handler = null);
	function each($handler);
	function structure();
}
