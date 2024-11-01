<?php
/**
 * Generated by Haxe 4.3.6
 */

namespace jotun\php\db\objects;

use \php\Boot;
use \jotun\php\db\tools\ICommand;

/**
 * @author Rafael Moreira
 */
interface IDataTable {
	/**
	 * Insert a new object
	 * @param	parameters
	 * @return
	 * 
	 * @param mixed $parameters
	 * 
	 * @return IQuery
	 */
	public function add ($parameters = null) ;

	/**
	 * Insert multiples objects
	 * @param	parameters
	 * @return
	 * 
	 * @param mixed $parameters
	 * 
	 * @return IQuery[]|\Array_hx
	 */
	public function addAll ($parameters = null) ;

	/**
	 * Erase all table entries (TRUNCATE)
	 * @return
	 * 
	 * @return IQuery
	 */
	public function clear () ;

	/**
	 * Copy entry to another table
	 * @param	toTable
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 * 
	 * @param string $toTable
	 * @param mixed $clause
	 * @param mixed $order
	 * @param string $limit
	 * 
	 * @return IQuery
	 */
	public function copy ($toTable, $clause = null, $order = null, $limit = null) ;

	/**
	 * Copy ONE entry to another table
	 * @param	toTable
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 * 
	 * @param string $toTable
	 * @param mixed $clause
	 * @param mixed $order
	 * 
	 * @return IQuery
	 */
	public function copyOne ($toTable, $clause = null, $order = null) ;

	/**
	 * Delete an entry
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 * 
	 * @param mixed $clause
	 * @param mixed $order
	 * @param string $limit
	 * 
	 * @return IQuery
	 */
	public function delete ($clause = null, $order = null, $limit = null) ;

	/**
	 * Delete ONE entry
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 * 
	 * @param mixed $clause
	 * @param mixed $order
	 * 
	 * @return IQuery
	 */
	public function deleteOne ($clause = null, $order = null) ;

	/**
	 * Select all entries
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 * 
	 * @param mixed $fields
	 * @param mixed $clause
	 * @param mixed $order
	 * @param string $limit
	 * 
	 * @return IExtQuery
	 */
	public function find ($fields = null, $clause = null, $order = null, $limit = null) ;

	/**
	 *
	 * @param	tables
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 * 
	 * @param mixed $fields
	 * @param mixed $tables
	 * @param mixed $clause
	 * @param mixed $order
	 * @param string $limit
	 * 
	 * @return IExtQuery
	 */
	public function findJoin ($fields, $tables, $clause = null, $order = null, $limit = null) ;

	/**
	 * Select a single entry
	 * @param	clause
	 * @return
	 * 
	 * @param mixed $fields
	 * @param mixed $clause
	 * @param mixed $order
	 * 
	 * @return mixed
	 */
	public function findOne ($fields = null, $clause = null, $order = null) ;

	/**
	 *
	 * @param	tables
	 * @param	clause
	 * @param	order
	 * @return
	 * 
	 * @param mixed $fields
	 * @param mixed $tables
	 * @param mixed $clause
	 * @param mixed $order
	 * 
	 * @return mixed
	 */
	public function findOneJoin ($fields, $tables, $clause = null, $order = null) ;

	/**
	 * Current AUTO_INCREMENT value for table
	 * 
	 * @return int
	 */
	public function getAutoIncrement () ;

	/**
	 * Get table column data erference
	 * @param	name
	 * @return
	 * 
	 * @param string $name
	 * 
	 * @return Column
	 */
	public function getColumn ($name) ;

	/**
	 * All table fields description
	 * 
	 * @return mixed
	 */
	public function getInfo () ;

	/**
	 * @return string
	 */
	public function get_name () ;

	/**
	 * If has a class definition for fetch
	 * @return
	 * 
	 * @param mixed $Def
	 * 
	 * @return bool
	 */
	public function hasClassObj ($Def) ;

	/**
	 * If table as a specified column name
	 * @param	name
	 * @return
	 * 
	 * @param string $name
	 * 
	 * @return bool
	 */
	public function hasColumn ($name) ;

	/**
	 * The ammount of rows in table
	 * @return
	 * 
	 * @param mixed $clause
	 * @param string $limit
	 * 
	 * @return int
	 */
	public function length ($clause = null, $limit = null) ;

	/**
	 * @param string $id
	 * @param string $key
	 * @param string $table
	 * @param string $field
	 * @param string $del
	 * @param string $update
	 * 
	 * @return ICommand
	 */
	public function link ($id, $key, $table, $field, $del = null, $update = null) ;

	/**
	 * Validate parameters with table description and remove invalid ones
	 * @param	paramaters
	 * @return
	 * 
	 * @param mixed $paramaters
	 * 
	 * @return mixed
	 */
	public function optimize ($paramaters) ;

	/**
	 * Run a custom query
	 * @param	data
	 * @param	params
	 * @return
	 * 
	 * @param string $data
	 * @param mixed $params
	 * 
	 * @return IQuery
	 */
	public function query ($data, $params = null) ;

	/**
	 *
	 * @param	to
	 * @return
	 * 
	 * @param string $to
	 * 
	 * @return IQuery
	 */
	public function rename ($to) ;

	/**
	 * Restrict the field selection of find command
	 * @param	fields
	 * @return
	 * 
	 * @param mixed $fields
	 * @param int $times
	 * 
	 * @return IDataTable
	 */
	public function restrict ($fields, $times = null) ;

	/**
	 * Default Constructor Object for SELECT
	 * @param	value
	 * @return
	 * 
	 * @param mixed $value
	 * 
	 * @return IDataTable
	 */
	public function setClassObj ($value) ;

	/**
	 * Sum field values and return its value
	 * @param	field
	 * @param	clausule
	 * @return
	 * 
	 * @param string $field
	 * @param mixed $clausule
	 * 
	 * @return int
	 */
	public function sum ($field, $clausule = null) ;

	/**
	 * @param string $id
	 * 
	 * @return ICommand
	 */
	public function unlink ($id) ;

	/**
	 * Unrestrict all fields for find command
	 * @return
	 * 
	 * @return IDataTable
	 */
	public function unrestrict () ;

	/**
	 * Update a entry
	 * @param	parameters
	 * @param	clause
	 * @param	order
	 * @param	limit
	 * @return
	 * 
	 * @param mixed $parameters
	 * @param mixed $clause
	 * @param mixed $order
	 * @param string $limit
	 * 
	 * @return IQuery
	 */
	public function update ($parameters = null, $clause = null, $order = null, $limit = null) ;

	/**
	 * Update ONE entry
	 * @param	parameters
	 * @param	clause
	 * @param	order
	 * @return
	 * 
	 * @param mixed $parameters
	 * @param mixed $clause
	 * @param mixed $order
	 * 
	 * @return IQuery
	 */
	public function updateOne ($parameters = null, $clause = null, $order = null) ;
}

Boot::registerClass(IDataTable::class, 'jotun.php.db.objects.IDataTable');
Boot::registerGetters('jotun\\php\\db\\objects\\IDataTable', [
	'name' => true
]);
