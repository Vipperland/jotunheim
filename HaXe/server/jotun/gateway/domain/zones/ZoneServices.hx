package jotun.gateway.domain.zones;
import jotun.Jotun;
import jotun.gateway.domain.zones.ForbiddenZone;
import jotun.utils.Dice;
import php.Syntax;
import jotun.gateway.domain.DomainServices;
import jotun.gateway.database.DataAccess;
import jotun.gateway.domain.zones.NotFoundZone;
import jotun.gateway.domain.zones.pass.ZonePass;
import jotun.gateway.domain.zones.ZoneServices;
import jotun.gateway.errors.ErrorCodes;

/**
 * ...
 * @author 
 */
class ZoneServices extends DomainServices {
	
	private var _defaultMap:Dynamic = {
		"*": NotFoundZone,
	}
	
	private var _readFlag:Int;
	private var _writeFlag:Int;
	
	private var _name:String;
	private var _pass:ZonePass;
	
	public var name(get, null):String;
	private function get_name():String {
		return _name;
	}
	
	private var _zone:ZoneServices;
	public var zone(get, null):ZoneServices;
	private function get_zone():ZoneServices {
		return _zone;
	}
	
	private var _parent:ZoneServices;
	public var parent(get, null):ZoneServices;
	private function get_parent():ZoneServices {
		return _parent;
	}
	
	private var _value:Dynamic;
	public var value(get, null):Dynamic;
	private function get_value():Dynamic {
		return _value;
	}
	
	final private function _logService(message:String):Void {
		output.log(message, "runtime");
	}
	
	public function new(?pass:ZonePass) {
		_name = Type.getClassName(Type.getClass(this)).split(".").pop();
		_pass = pass;
		_buildZoneMap();
		super();
	}
	
	final public function setEndZone():Void {
		_defaultMap = null;
	}
	
	final private function isPassRequired():Bool {
		return _pass != null;
	}
	
	final private function hasValidPass():Bool {
		return _pass == null || (input.isAuthenticated() && _pass.isCarrier()) || input.hasAuthentication(_pass);
	}
	
	final private function _setZoneMap(data:Dynamic):Void {
		Dice.All(data, function(p:String, v:Dynamic){
			Reflect.setField(_defaultMap, p, v);
		});
	}
	
	final private function _setParent(parent:ZoneServices):Void {
		_parent = parent;
	}
	
	private function _buildup(zoneName:String):Void {
	}
	
	private function getZoneMap():Dynamic {
		return _defaultMap;
	}

	private function _buildZoneMap():Void {
		
	}
	
	private function _prefab(data:Array<String>):Dynamic {
		if (data.length > 0){
			var name:String = data[0];
			var map:Dynamic = getZoneMap();
			if (Reflect.hasField(map, name)){
				return Reflect.field(map, name);
			}else if (Reflect.hasField(map, "*")){
				return Reflect.field(map, "*");
			}
		}
		return null;
	}
	
	private function _execute(data:Array<String>):Void {
		if (_defaultMap != null){
			error(ErrorCodes.SERVICE_FORBIDDEN);
		}
	}
	
	final private function carry(parent:ZoneServices, data:Array<String>):ZoneServices {
		_setParent(parent);
		var Def:Dynamic = _prefab(data);
		if (hasValidPass()){
			if (Def != null){
				var ZoneName:String = data.shift();
				_zone = Syntax.construct(Def);
				_zone._buildup(ZoneName);
				_logService(toString() + "->carry('" + ZoneName + "')");
				_zone.carry(this, data);
				return _zone;
			}else{
				if (data.length > 0){
					_logService(toString() + "->execute(" + data + ")");
				}else{
					_logService(toString() + "->execute()");
				}
				_execute(data);
				return this;
			}
		}else{
			_logService(toString() + "->" + (Def != null ? "carry" : "execute") + "(UNAUTORIZED " + _pass.toString() + ")");
			if (input.isAuthenticated()){
				error(ErrorCodes.SERVICE_UNAUTHORIZED);
			}else{
				error(ErrorCodes.LOGIN_REQUIRED);
			}
			return null;
		}
	}
	
	public function toString():String {
		var val:String = "";
		if(_value != null){
			if (!Std.isOfType(_value, Array) && !Std.isOfType(_value, String) && !Std.isOfType(_value, Float) && !Std.isOfType(_value, Bool)){
				if (Reflect.hasField(_value, "toString")){
					val = _value.toString();
				}else{
					val = Type.getClassName(Type.getClass(_value)).split(".").pop();
				}
			}else{
				val = _value;
			}
		}
		return _name + "[" + val + "]";
	}
	
}