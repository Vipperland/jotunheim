package jotun.gateway.domain.zones;
import jotun.gateway.domain.DomainServicesCore;
import jotun.gateway.domain.zones.DomainZoneCore;
import jotun.gateway.domain.zones.NotFoundZone;
import jotun.gateway.domain.zones.pass.ZonePass;
import jotun.gateway.errors.ErrorCodes;
import jotun.utils.Dice;
import php.Syntax;

/**
 * ...
 * @author 
 */
class DomainZoneCore extends DomainServicesCore {
	
	private var _defaultMap:Dynamic = {
		"*": NotFoundZone,
	}
	
	private var _readFlag:Int;
	private var _writeFlag:Int;
	
	private var _name:String;
	private var _requiredPass:ZonePass;
	
	private var _dbRequired:Bool;
	
	public var name(get, null):String;
	private function get_name():String {
		return _name;
	}
	
	private var _zone:DomainZoneCore;
	public var zone(get, null):DomainZoneCore;
	private function get_zone():DomainZoneCore {
		return _zone;
	}
	
	private var _parent:DomainZoneCore;
	public var parent(get, null):DomainZoneCore;
	private function get_parent():DomainZoneCore {
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
		_requiredPass = pass;
		_buildZoneMap();
		super();
	}
	
	final public function setEndZone():Void {
		_defaultMap = null;
	}
	
	final public function setDatabaseRequired():Void {
		_dbRequired = true;
	}
	
	final private function isDatabaseRequired():Bool {
		return _dbRequired == true;
	}
	
	final private function isPassRequired():Bool {
		return _requiredPass != null;
	}
	
	final private function hasValidPass():Bool {
		return _requiredPass == null || (input.hasPass() && _requiredPass.isCarrier()) || input.hasAuthentication(_requiredPass);
	}
	
	final private function _setZoneMap(data:Dynamic):Void {
		Dice.All(data, function(p:String, v:Dynamic){
			Reflect.setField(_defaultMap, p, v);
		});
	}
	
	final private function _setParent(parent:DomainZoneCore):Void {
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
			output.setStatus(ErrorCodes.SERVICE_FORBIDDEN);
		}
	}
	
	final private function carry(parent:DomainZoneCore, data:Array<String>):DomainZoneCore {
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
				var dbPassed:Bool = !isDatabaseRequired() || database.isConnected();
				
				if (data.length > 0){
					_logService(toString() + "->execute(" + data + ") " + (dbPassed ? "SUCCESS" : "DB_REQUIRED"));
				}else{
					_logService(toString() + "->execute() " + (dbPassed ? "SUCCESS" : "DB_REQUIRED"));
				}
				if (dbPassed && output.getStatus() == 200){
					_execute(data);
				}else {
					output.error(ErrorCodes.DATABASE_UNAVAILABLE);
				}
				return this;
			}
		}else{
			_logService(toString() + "->" + (Def != null ? "carry" : "execute") + "(UNAUTORIZED " + _requiredPass.toString() + ")");
			if (input.hasPass()){
				output.setStatus(ErrorCodes.SERVICE_UNAUTHORIZED);
			}else{
				output.setStatus(ErrorCodes.SERVICE_LOGIN_REQUIRED);
			}
			return null;
		}
	}
	
	final public function toString():String {
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
		if (_defaultMap == null){
			val += val.length > 0 ? ',' : '';
			val += 'EndZone';
		}
		if (isDatabaseRequired()){
			val += val.length > 0 ? ',' : '';
			val += 'DatabaseRequired';
		}
		return _name + "[" + val + "]";
	}
	
}