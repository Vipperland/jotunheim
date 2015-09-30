package sirius.data;
import sirius.data.FormParam;
import sirius.data.IFormData;
import sirius.dom.IDisplay;
import sirius.utils.Dice;
import sirius.utils.IDiceRoll;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
class FormData implements IFormData {
	
	private var _form:IDisplay;
	
	public var params:Array<FormParam>;
	
	public var errors:Array<FormParam>;
	
	/**
	 * Create a new Instance of FormData
	 * form-data			Target param for form
	 * form-required			
	 * form-message			
	 * form-persistent		
	 * @param	target
	 */
	public function new(?target:IDisplay) {
		if(target != null) scan(target);
	}
	
	public function reset():IFormData {
		params = [];
		return this;
	}
	
	public function scan(?target:IDisplay):IFormData {
		reset();
		_form = target == null ? Sirius.document : target;
		target.all("[form-data]").each(function(el:IDisplay) { params[params.length] = new FormParam(el); });
		return this;
	}
	
	public function valueOf(p:String):FormParam {
		var res:IDiceRoll = Dice.Values(params, function(v:FormParam) {	return v.getName() == p; } );
		return cast res.value; 
	}
	
	public function isValid():Bool {
		errors = [];
		Dice.Values(params, function(v:FormParam) {	if (!v.isValid()) errors[errors.length] = v; });
		return errors.length == 0;
	}
	
	public function getParam(p:String):FormParam {
		var res:IDiceRoll = Dice.Values(params, function(v:FormParam) {	return v.getName() == p; });
		return cast res.value;
	}
	
	public function getData():Dynamic {
		var d:Dynamic = { };
		Dice.Values(params, function(v:FormParam) {	return Reflect.setField(d, v.getName(), v.getValue()); } );
		return d;
	}
	
	public function clear():IFormData {
		Dice.Values(params, function(v:FormParam) {
			v.clear();
		});
		return this;
	}
	
}