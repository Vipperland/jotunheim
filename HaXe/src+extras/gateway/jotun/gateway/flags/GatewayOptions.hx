package jotun.gateway.flags;
import jotun.logical.Flag;

/**
 * ...
 * @author Rafael Moreira
 */
class GatewayOptions {

	static public inline var INFO_LOG:Int = 1 << 0;
	
	static public inline var DEBUG_MODE:Int = 1 << 1;
	
	static public inline var ERROR_LOG:Int = 1 << 2;
	
	static public inline var DATABASE_LOG:Int = 1 << 3;
	
	static public inline var MAINTENANCE:Int = 1 << 4;
	
	static public inline var ENCODED_OUTPUT:Int = 1 << 5;
	
	static public inline var ENCODED_INPUT:Int = 1 << 6;
	
	static public inline var ALL:Int = INFO_LOG | DEBUG_MODE | ERROR_LOG | DATABASE_LOG;
	
	static public inline var ALL_ENCODED:Int = ALL | ENCODED_OUTPUT | ENCODED_INPUT;
	
	
}