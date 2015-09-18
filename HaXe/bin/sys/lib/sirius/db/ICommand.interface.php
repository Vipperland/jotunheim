<?php

interface sirius_db_ICommand {
	//;
	//;
	//;
	function bind($arguments);
	function execute($handler = null, $type = null, $queue = null, $parameters = null);
	function fetch($handler);
	function queue($name);
	function log();
}
