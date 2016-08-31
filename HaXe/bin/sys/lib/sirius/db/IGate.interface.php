<?php

interface sirius_db_IGate {
	function get_errors();
	function get_log();
	//;
	//;
	//;
	//;
	function isOpen();
	function open($token, $log = null);
	function prepare($query, $parameters = null, $options = null);
	function schema($table = null);
	function table($table);
	function insertedId();
}
