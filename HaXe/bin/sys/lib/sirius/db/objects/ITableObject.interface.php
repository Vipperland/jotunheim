<?php

interface sirius_db_objects_ITableObject {
	function get_id();
	//;
	//;
	function create($data, $verify = null);
	function update($data, $verify = null);
	function copy();
	function delete();
}
