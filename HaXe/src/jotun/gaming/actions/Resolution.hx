package jotun.gaming.actions;
import jotun.tools.Utils;

/**
 * ...
 * @author Rim Project
 */
@:expose("J_Resolution")
class Resolution {
	
	private var _type:String;
	
	public var id:String;
	
	public var query:Array<String>;
	
	public var onSuccess:Events;
	
	public var onFail:Events;
	
	public function new(type:String, data:Dynamic) {
		_type = type;
		if (Std.is(data.query, Array)){
			query = data.query;
			query.unshift('@result');
		}else if (Utils.isValid(data.query)){
			query = ['@result', data.query];
		}
		if (data.onSuccess != null) {
			onSuccess = new Events(_type + ".onSuccess", data.onSuccess);
		}
		if (data.onFail != null) {
			onFail = new Events(_type + ".onFail", data.onFail);
		}
		id = data.id;
	}
	
	public function resolve(result:Bool, context:IEventContext):Bool {
		++context.ident;
		if (result){
			if (onSuccess != null)
				onSuccess.run(context);
		}else{
			if (onFail != null)
				onFail.run(context);
		}
		--context.ident;
		return result;
	}
	
	public function length():Int {
		return query != null ? query.length - 1 : 0;
	}
	
}