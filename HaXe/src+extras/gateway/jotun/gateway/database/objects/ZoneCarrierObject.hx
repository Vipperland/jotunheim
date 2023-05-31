package jotun.gateway.database.objects;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.logical.Flag;

/**
 * ...
 * @author Rafael Moreira
 */
class ZoneCarrierObject extends ZoneCoreObject implements IPassCarrier {

	public var _read:Int;
	
	public var _write:Int;
	
	public function new() {
		super();
	}
	
	
	/* INTERFACE jotun.gateway.domain.zones.pass.IPassCarrier */
	
	public function canRead(read:Int):Bool {
		return Flag.FTest(_read, read);
	}
	
	public function canWrite(write:Int):Bool {
		return Flag.FTest(_write, write);
	}
	
	public function getInfo():Dynamic {
		return this;
	}
	
}