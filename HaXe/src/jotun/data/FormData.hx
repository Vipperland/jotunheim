package jotun.data;
import jotun.Jotun;
import jotun.data.FormParam;
import jotun.data.IFormData;
import jotun.dom.IDisplay;
import jotun.net.IRequest;
import jotun.tools.Utils;
import jotun.utils.Dice;
import jotun.utils.IDiceRoll;

/**
 * ...
 * @author Rafael Moreira <vipperland@live.com,rafael@gateofsirius.com>
 */
@:expose('J_FormData')
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
	public function new(?target:Dynamic) {
		if (target != null) {
			if (Std.isOfType(target, String)){
				scan(Jotun.one(target));
			}
			if (Std.isOfType(target, IDisplay)){
				scan(target);
			}
		}
	}
	
	public function reset():IFormData {
		params = [];
		return this;
	}
	
	public function scan(?target:IDisplay):IFormData {
		reset();
		_form = target == null ? Jotun.document.body : target;
		target.all("[form-data]").each(function(o:IDisplay) {
			params[params.length] = new FormParam(o);
		});
		return this;
	}
	
	public function valueOf(p:String):FormParam {
		return cast Dice.Values(params, function(v:FormParam) {
			return v.getName() == p;
		}).value; 
	}
	
	public function isValid(?needAll:Bool):Bool {
		errors = [];
		Dice.Values(params, function(v:FormParam) {
			if (!v.isValid(needAll)) {
				errors[errors.length] = v;
			}
		});
		return errors.length == 0;
	}
	
	public function getParam(p:String):FormParam {
		return cast Dice.Values(params, function(v:FormParam) {
			return v.getName() == p; 
		}).value;
	}
	
	public function getData(?feed:Dynamic):Dynamic {
		if (feed == null){
			feed = {};
		}
		Dice.Values(params, function(v:FormParam) {
			return Reflect.setField(feed, v.getName(), v.getValue());
		});
		return feed;
	}
	
	public function clear():IFormData {
		Dice.Values(params, function(v:FormParam) {
			v.clear();
		});
		return this;
	}
	
	public function send(url:String, ?handler:IRequest->Void, method:String = 'post'):Void {
		Jotun.request(url, getData(), handler, method);
	}
	
	public function match(paramA:String, paramB:String):Bool {
		return getParam(paramA).getValue() == getParam(paramB).getValue();
	}
	
}