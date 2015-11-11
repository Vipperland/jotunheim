package iam.rim.db;
import sirius.db.objects.IDataTable;
import sirius.Sirius;

/**
 * ...
 * @author Rafael Moreira
 */
class Collection {
	
	static private var _sessions:IDataTable;
	
	static public var sessions(get, null):IDataTable;
	static private function get_sessions():IDataTable {
		if (_sessions == null) _sessions = Sirius.gate.getTable('sessions');
		return _sessions;
	}
	
	static private var _users:IDataTable;
	
	static public var users(get, null):IDataTable;
	static private function get_users():IDataTable {
		if (_users == null) _users = Sirius.gate.getTable('users');
		return _users;
	}
	
}