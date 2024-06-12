package jotun.gateway.domain.zones;
import haxe.DynamicAccess;
import haxe.Rest;
import jotun.gateway.domain.DomainServicesCore;
import jotun.gateway.domain.zones.DomainZoneCore;
import jotun.gateway.domain.zones.ForbiddenZone;
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
	
	private var _requiredPass:ZonePass;
	
	private var _dbRequired:Bool;
	private var _requiredMethod:String;
	
	private var _name:String;
	public var name(get, null):String;
	final private function get_name():String {
		return _name;
	}
	
	private var _zone:DomainZoneCore;
	public var zone(get, null):DomainZoneCore;
	final private function get_zone():DomainZoneCore {
		return _zone;
	}
	
	private var _parent:DomainZoneCore;
	public var parent(get, null):DomainZoneCore;
	final private function get_parent():DomainZoneCore {
		return _parent;
	}
	
	private var _value:Dynamic;
	public var value(get, null):Dynamic;
	final private function get_value():Dynamic {
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
	
	/**
	 * 
	 * @param	name
	 */
	final private function restrictToGet():Void {
		_requiredMethod = 'GET';
	}
	
	final private function restrictToPost():Void {
		_requiredMethod = 'POST';
	}
	
	final private function restrictToDel():Void {
		_requiredMethod = 'POST';
	}
	
	final private function restrictToPut():Void {
		_requiredMethod = 'PUT';
	}
	
	final private function restrictToPatch():Void {
		_requiredMethod = 'PATCH';
	}
	
	final private function restrictToOptions():Void {
		_requiredMethod = 'OPTIONS';
	}
	
	final private function isMethodMatch():Bool {
		return _requiredMethod == null || Jotun.domain.data.REQUEST_METHOD.toUpperCase() == _requiredMethod.toUpperCase();
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
	
	final private function _setZonePass(pass:ZonePass):Void {
		_requiredPass = pass;
	}
	
	/**
	 * Current zone internal mapping
	 * @return
	 */
	final private function _getZoneMap():Dynamic {
		return _defaultMap;
	}

	/**
	 * Defines the current domain zone map
	 * Use override to define the mao of this and next zones {"zoneA":DomainZoneCore, "zoneB":DomainZoneCore, ...}
	 */
	private function _buildZoneMap():Void {
	}
	
	/**
	 * Get next level zone
	 * @param	data
	 * @return
	 */
	final private function _prefab(data:Array<String>):Dynamic {
		if (data.length > 0){
			var name:String = data[0];
			var map:Dynamic = _getZoneMap();
			if (Reflect.hasField(map, name)){
				return Reflect.field(map, name);
			}else if (Reflect.hasField(map, "*")){
				return Reflect.field(map, "*");
			}
		}
		return null;
	}
	
	/**
	 * Can only be executed IF: 
	 * 	is the end zone (setEndZone())
	 * 	match datase requirement: db is not required OR is connected to db
	 * @param	data
	 */
	private function _execute(data:Array<String>):Void {
	}
	
	/**
	 * Prepare the zone to carry to the next level defined in zone map (_setZoneMap({...})).
	 * First prepare([...]) then carry([...])
	 * @return
	 */
	private function _prepare(data:Array<String>):Bool {
		return _defaultMap != null;
	}
	
	/**
	 * Set 403 HTTP Status
	 */
	final private function _setStatusForbidden():Void {
		output.setStatus(ErrorCodes.SERVICE_FORBIDDEN);
	}
	
	/**
	 * Set 401 HTTp Status
	 */
	final private function _setStatusUnauthorized():Void {
		output.setStatus(ErrorCodes.SERVICE_UNAUTHORIZED);
	}
	
	/**
	 * Require user login
	 */
	final private function _setLoginRequired():Void {
		output.setStatus(ErrorCodes.SERVICE_LOGIN_REQUIRED);
	}
	
	/**
	 * Test if is connected to database and and is required by the zone
	 * @return
	 */
	final private function _matchDabaseRequirement():Bool {
		return !isDatabaseRequired() || database.isConnected();
	}
	
	/**
	 * Carry input data to the next zone
	 * @param	parent
	 * @param	data
	 * @return
	 */
	final private function carry(parent:DomainZoneCore, data:Array<String>):DomainZoneCore {
		
		var Def:Dynamic = _prefab(data);
		
		if(!hasValidPass()){
			if (output.isLogEnabled()){
				_logService(toString() + "->" + (Def != null ? "carry" : "execute") + "(Error.Auth." + _requiredPass.toString() + ")");
			}
			if (input.hasPass()){
				output.setStatus(ErrorCodes.SERVICE_UNAUTHORIZED);
			}else{
				output.setStatus(ErrorCodes.SERVICE_LOGIN_REQUIRED);
			}
			return null;
		}
		
		if(!isMethodMatch()){
			if (output.isLogEnabled()){
				_logService(toString() + "->" + (Def != null ? "carry" : "execute") + "(Method.Restrict." + _requiredMethod + ")");
			}
			output.setStatus(ErrorCodes.SERVICE_NOT_ACCEPTABLE);
			return null;
		}
		
		if (Def != null){
			var ZoneName:String = data.shift();
			_zone = Syntax.construct(Def);
			if (_prepare(data) || Def == NotFoundZone || Def == ForbiddenZone){
				if (output.isLogEnabled()){
					_logService(toString() + "->carry('" + ZoneName + "') Status.SUCESS");
				}
				_zone._parent = parent;
				_zone.carry(this, data);
				return _zone;
			}else{
				if (output.isLogEnabled()){
					_logService(toString() + "->carry('" + ZoneName + "') Error.FAILED");
				}
			}
		}else{
			if (_matchDabaseRequirement()){
				if (output.getStatus() == 200){
					if (output.isLogEnabled()){
						_logService(toString() + "->execute(" + (data.length > 0 ? data.join("/") : "") + ") Status.SUCESS");
					}
					_execute(data);
					return this;
				}
			}else{
				if (output.isLogEnabled()){
					_logService(toString() + "->execute(" + data + ") Error.DB_REQUIRED");
				}
				output.error(ErrorCodes.DATABASE_UNAVAILABLE);
			}
		}
		
		return null;
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
		if (isDatabaseRequired()){
			val += val.length > 0 ? ',' : '';
			val += 'DB';
		}
		if (isPassRequired()){
			val += val.length > 0 ? ',' : '';
			val += 'Pass';
		}
		if (_defaultMap == null){
			val += val.length > 0 ? ',' : '';
			val += 'Tail';
		}
		return _name + "[" + val + "]";
	}
	
}