package jotun.gateway.errors;

/**
 * ...
 * @author 
 */
class ErrorCodes {

	static public inline var NO_INPUT:Int = 0;
	
	static public inline var MAINTENANCE_MODE:Int = 1;
	
	static public inline var LOGIN_REQUIRED:Int = 2;
	
	// ============================== DATABASE
	
	static public inline var DATABASE_CONNECT_ERROR:Int = 100;
	
	static public inline var DATABASE_UNAVAILABLE:Int = 101;
	
	static public inline var DATABASE_MISSING_TABLE:Int = 102;
	
	// ============================== ACEESS
	
	static public inline var SERVICE_UNAUTHORIZED:Int = 401;
	
	static public inline var SERVICE_FORBIDDEN:Int = 403;
	
	static public inline var SERVICE_NOT_FOUND:Int = 404;
	
	
}