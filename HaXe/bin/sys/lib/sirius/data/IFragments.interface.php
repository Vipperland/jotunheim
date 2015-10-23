<?php

interface sirius_data_IFragments {
	//;
	//;
	//;
	//;
	function split($separator);
	function glue($value);
	function addPiece($value, $at = null);
	function get($i);
	function find($value);
	function clear();
}
