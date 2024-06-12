package jotun.gateway.domain.zones.pass;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.logical.Flag;
import jotun.logical.FlagValue;

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
	
	static public var BASIC_PASS(get, null):ZonePass;
	static private function get_BASIC_PASS():ZonePass {
		if (BASIC_PASS == null){
			BASIC_PASS = new ZonePass(FlagValue.BIT_01, FlagValue.BIT_01);
		}
		return BASIC_PASS;
	}
	
	static public var READER_PASS(get, null):ZonePass;
	static private function get_READER_PASS():ZonePass {
		if (READER_PASS == null){
			READER_PASS = new ZonePass(0, FlagValue.BIT_32);
		}
		return READER_PASS;
	}
	
	static public var WRITER_PASS(get, null):ZonePass;
	static private function get_WRITER_PASS():ZonePass {
		if (WRITER_PASS == null){
			WRITER_PASS = new ZonePass(0, FlagValue.BIT_32);
		}
		return WRITER_PASS;
	}
	
	static public var MASTER_PASS(get, null):ZonePass;
	static private function get_MASTER_PASS():ZonePass {
		if (MASTER_PASS == null){
			MASTER_PASS = new ZonePass(FlagValue.BIT_32, FlagValue.BIT_32);
		}
		return MASTER_PASS;
	}
	
	private var _read:Int;
	private var _write:Int;
	
	public function new(read:Int, write:Int){
		this._read = read;
		this._write = write;
	}
	
	final public function validate(carrier:IPassCarrier):Bool {
		return (_read == 0 || carrier.canRead(_read)) && (_write == 0 || carrier.canWrite(_write));
	}
	
	final public function isCarrier():Bool {
		return this == CARRIER_PASS || (_read == 0 && _write == 0);
	}
	
	final public function isBasic():Bool {
		return this == BASIC_PASS || (_read == FlagValue.BIT_01 && _write == FlagValue.BIT_01);
	}
	
	final public function isReader():Bool {
		return this == READER_PASS || (_read == FlagValue.BIT_32);
	}
	
	final public function isWriter():Bool {
		return this == READER_PASS || (_write == FlagValue.BIT_32);
	}
	
	final public function isMaster():Bool {
		return this == MASTER_PASS || (_read == FlagValue.BIT_32 && _write == FlagValue.BIT_32);
	}
	
	final public function getRead():UInt {
		return _read;
	}
	
	final public function getWrite():UInt {
		return _write;
	}
	
	final public function toString():String {
		return "ZonePass[R:" + _read + ",W:" + _write + "]";
	}
	
}