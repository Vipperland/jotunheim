package jotun.gateway.domain;
import jotun.Jotun;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.serial.Packager;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.gateway.database.objects.ZoneCoreSession;
import jotun.gateway.domain.OutputCore;
import jotun.gateway.domain.zones.pass.ZonePass;
import php.ErrorException;

/**
 * ...
 * @author 
 */
class InputCore {
	
	static private var _instance:InputCore;
	static public function getInstance():InputCore {
		return _instance;
	}
	
	private var _testToken:String;
	
	public var carrier(get, null):IPassCarrier;
	
	public var params:Dynamic;
	
	public var object:Dynamic;
	
	public function get_carrier():IPassCarrier {
		return this.carrier;
	}
	
	
	public function new() {
		if (_instance != null){
			throw new ErrorException("gateway.Input is a Singleton");
		}
		_instance = this;
		params = Jotun.domain.params;
		object = Jotun.domain.input;
	}
	
	final public function hasAnyParam():Bool {
		return Dice.Params(params, function(p:String){
			return true;
		}).param != null;
	}
	
	final public function getInput():String {
		return Jotun.domain.getInput();
	}
	
	final public function getInputJson():String {
		return Jotun.domain.getInput();
	}
	
	final public function hasPass():Bool {
		return this.carrier != null;
	}
	
	final public function hasAuthentication(pass:ZonePass):Bool {
		return hasPass() && pass.validate(this.carrier);
	}
	
}