package jotun.gateway.domain.zones.pass;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.logical.Flag;

/**
 * ...
 * @author Rafael Moreira
 */
class ZonePass {
	
	static public var CARRIER_PASS(get, null):ZonePass;
	static private function get_CARRIER_PASS():ZonePass {
		if (CARRIER_PASS == null){
			CARRIER_PASS = new ZonePass(0, 0);
		}
		return CARRIER_PASS;
	}
	
	private var _read:Int;
	private var _write:Int;
	
	public function new(read:Int, write:Int){
		this._read = read;
		this._write = write;
	}
	
	public function validate(carrier:IPassCarrier):Bool {
		return (_read == 0 || carrier.canRead(_read)) && (_write == 0 || carrier.canWrite(_write));
	}
	
	public function isCarrier():Bool {
		return this == CARRIER_PASS || (_read == 0 && _write == 0);
	}
	
	public function toString():String {
		return "[R:" + _read + ",W:" + _write + "]";
	}
	
}