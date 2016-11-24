<?php

interface sirius_db_objects_IDataTable {
	function get_name();
	function get_autoIncrement();
	function get_description();
	//;
	//;
	//;
	function add($parameters = null, $clause = null, $order = null, $limit = null);
	function findAll($clause = null, $order = null, $limit = null);
	function findOne($clause = null);
	function update($parameters = null, $clause = null, $order = null, $limit = null);
	function delete($clause = null, $order = null, $limit = null);
	function copy($toTable, $clause = null, $order = null, $limit = null);
	function clear();
	function optimize($paramaters);
	function length($clause = null);
	function restrict($fields, $times = null);
	function unrestrict();
	function hasColumn($name);
	function getColumn($name);
}
