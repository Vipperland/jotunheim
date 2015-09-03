<?php

interface sirius_php_db_IGate {
	//;
	function isOpen();
	function open($token);
	function prepare($query, $parameters = null, $options = null);
	function fields($table);
}
