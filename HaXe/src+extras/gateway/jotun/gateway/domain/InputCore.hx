package jotun.gateway.domain;
import haxe.DynamicAccess;
import jotun.Jotun;
import jotun.gateway.domain.zones.pass.IPassCarrier;
import jotun.gateway.domain.zones.pass.ZonePass;
import jotun.net.DataSource;
import jotun.utils.Dice;
import php.ErrorException;
import php.Syntax;

/**
 * ...
 * @author 
 */
class InputCore extends DataSource {
	
	static private var _instance:InputCore;
	static public function getInstance():InputCore {
		return _instance;
	}
	
	public var carrier(get, null):IPassCarrier;
	
	/**
	 * GET amd POST params
	 */
	public var params(get, null):DataSource;
	final private function get_params():DataSource {
		return Jotun.params;
	}
	
	/**
	 * Object from All Input Data
	 */
	public var object(get, null):DataSource;
	final private function get_object():DataSource {
		return this.object;
	}
	
	public function get_carrier():IPassCarrier {
		return this.carrier;
	}
	
	final private function _getProperty(name:String, alt:Dynamic):Dynamic {
		if (object.exists(name)){
			return object.string(name);
		}
		if (params.exists(name)){
			return params.string(name);
		}
		return alt;
	}
	
	public function new() {
		if (_instance != null){
			throw new ErrorException("gateway.Input is a Singleton");
		}
		_instance = this;
		super(null);
		this.object = Jotun.domain.input;
		if(this.object == null){
			this.object = new DataSource({ });
		}
	}
	
	final public function hasPass():Bool {
		return this.carrier != null;
	}
	
	final public function hasAuthentication(pass:ZonePass):Bool {
		return hasPass() && pass.validate(this.carrier);
	}
	
	final public function construct(DefClass:Class<Any>):Dynamic {
		return Syntax.construct(DefClass, this);
	}
	
	override public function isEmpty():Bool {
		return object.isEmpty() && params.isEmpty();
	}
	
	override function get(q:String, ?alt:Dynamic):Dynamic {
		if(object.exists(q)){
			return object.get(q, alt);
		}
		if(params.exists(q)){
			return params.get(q, alt);
		}
		return alt;
	}
	
	public function allData():DynamicAccess<Dynamic> {
		return Dice.Blend([object.data, params.data], { });
	}
	
}