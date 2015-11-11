<?php

interface sirius_db_objects_IQueryResult {
	//;
	function each($handler);
	function one($i);
	function first();
	function last();
	function slice();
}
