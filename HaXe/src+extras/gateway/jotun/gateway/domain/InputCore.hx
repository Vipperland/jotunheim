package jotun.gateway.domain;
import haxe.Json;
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
		return !Dice.Params(params, function(p:String){
			return true;
		}).completed;
	}
	
	final public function getInput():String {
		return Jotun.domain.getInput();
	}
	
	final public function getInputJson():String {
		return Json.parse(Jotun.domain.getInput());
	}
	
	final public function hasPass():Bool {
		return this.carrier != null;
	}
	
	final public function hasAuthentication(pass:ZonePass):Bool {
		return hasPass() && pass.validate(this.carrier);
	}
	
	final public function paramAsBool(q:String):Bool {
		return Jotun.domain.paramAsBool(q);
	}
	
	final public function paramAsInt(q:String):Int {
		return Jotun.domain.paramAsInt(q);
	}
	
	final public function paramAsFloat(q:String):Float {
		return Jotun.domain.paramAsFloat(q);
	}
	
	final public function paramAsArray(q:String, ?split:String = ','):Array<Dynamic> {
		return Jotun.domain.paramAsArray(q, split);
	}
	
	final public function paramAsObject(q:String):Dynamic {
		return Jotun.domain.paramAsObject(q);
	}
	
}