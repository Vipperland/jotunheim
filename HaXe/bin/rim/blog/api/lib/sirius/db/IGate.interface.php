<?php

interface sirius_db_IGate {
	function get_errors();
	//;
	//;
	//;
	function isOpen();
	function open($token);
	function prepare($query, $parameters = null, $options = null);
	function schemaOf($table = null);
	function getTable($table);
	function insertedId();
}
