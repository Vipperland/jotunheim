<?php

interface sirius_db_tools_IQueryBuilder {
	function add($table, $clause = null, $parameters = null, $order = null, $limit = null);
	function find($fields, $table, $clause = null, $order = null, $limit = null);
	function update($table, $clause = null, $parameters = null, $order = null, $limit = null);
	function delete($table, $clause = null, $order = null, $limit = null);
	function copy($from, $to, $clause = null, $filter = null, $limit = null);
	function truncate($table);
	function rename($name, $to);
}
