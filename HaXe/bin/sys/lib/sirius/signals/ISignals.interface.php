<?php

interface sirius_signals_ISignals {
	//;
	function has($name);
	function get($name);
	function add($name, $handler = null);
	function remove($name, $handler = null);
	function call($name, $data = null);
	function reset($name = null);
}
