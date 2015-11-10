<?php

interface sirius_db_objects_IDataTable {
	function get_name();
	function get_description();
	//;
	//;
	function create($clausule = null, $parameters = null, $order = null, $limit = null);
	function find($clausule = null, $order = null, $limit = null);
	function update($clausule = null, $parameters = null, $order = null, $limit = null);
	function delete($clausule = null, $order = null, $limit = null);
	function restrict($fields);
}
