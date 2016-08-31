<?php

interface sirius_signals_IPipe {
	//;
	//;
	//;
	//;
	//;
	function add($handler);
	function remove($handler);
	function call($data = null);
	function stop();
	function reset();
}
