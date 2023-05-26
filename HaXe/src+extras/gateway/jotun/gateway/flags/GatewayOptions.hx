package jotun.gateway.flags;
import jotun.logical.Flag;

/**
 * ...
 * @author Rafael Moreira
 */
class GatewayOptions {

	static public inline var INFO:Int = 1 << 0;
	
	static public inline var DEBUG:Int = 1 << 1;
	
	static public inline var ERROR:Int = 1 << 2;
	
	static public inline var DATABASE:Int = 1 << 3;
	
	static public inline var MAINTENANCE:Int = 1 << 4;
	
	static public inline var ALL:Int = INFO | DEBUG | ERROR | DATABASE;
	
}