<?php

interface sirius_db_IQueryBuilder {
	function create($table, $clausule = null, $parameters = null, $order = null, $limit = null);
	function find($fields, $table, $clausule = null, $order = null, $limit = null);
	function update($table, $clausule = null, $parameters = null, $order = null, $limit = null);
	function delete($table, $clausule = null, $order = null, $limit = null);
}
