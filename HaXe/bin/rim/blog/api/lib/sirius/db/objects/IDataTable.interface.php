<?php

interface sirius_db_objects_IDataTable {
	function get_name();
	function get_description();
	//;
	//;
	function create($parameters = null, $clausule = null, $order = null, $limit = null);
	function findAll($clausule = null, $order = null, $limit = null);
	function findOne($clausule = null);
	function update($parameters = null, $clausule = null, $order = null, $limit = null);
	function delete($clausule = null, $order = null, $limit = null);
	function restrict($fields);
}
