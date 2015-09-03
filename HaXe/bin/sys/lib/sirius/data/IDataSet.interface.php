<?php

interface sirius_data_IDataSet {
	function get($p);
	function set($p, $v);
	function exists($p);
}
