<?php

interface sirius_db_objects_ITable {
	function get_name();
	function get_description();
	//;
	//;
	function create($clausule = null, $parameters = null, $order = null, $limit = null);
	function find($fields, $clausule = null, $order = null, $limit = null);
	function update($clausule = null, $parameters = null, $order = null, $limit = null);
	function delete($clausule = null, $order = null, $limit = null);
}
