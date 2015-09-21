<?php

interface sirius_db_ICommand {
	//;
	//;
	//;
	function bind($arguments);
	function execute($handler = null, $type = null, $parameters = null);
	function fetch($handler);
	function log();
}
