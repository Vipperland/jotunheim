package jotun.gateway.domain.zones.pass;

/**
 * @author Rafael Moreira
 */
interface IPassCarrier {
	function canRead(read:Int):Bool;
	function canWrite(write:Int):Bool;
	function getInfo():Dynamic;
}