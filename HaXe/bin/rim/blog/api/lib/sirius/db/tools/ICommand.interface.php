<?php

interface sirius_db_tools_ICommand {
	function get_errors();
	//;
	//;
	//;
	//;
	function bind($arguments);
	function execute($handler = null, $type = null, $parameters = null);
	function fetch($handler);
	function log();
	function find($param, $values, $limit = null);
}
