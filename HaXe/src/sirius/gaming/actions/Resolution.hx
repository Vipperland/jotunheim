package sirius.gaming.actions;
import sirius.tools.Utils;

/**
 * ...
 * @author Rim Project
 */
class Resolution {

	private var _type:String;
		
	public var query:Array<String>;
	
	public var onSuccess:Events;
	
	public var onFail:Events;
	
	public function new(type:String, data:Dynamic) {
		_type = type;
		if (Std.is(data.query, Array)){
			query = data.query;
		}else if (Utils.isValid(data.query)){
			query = [data.query];
		}
		if (query != null){
			query.unshift('@result');
		}
		if (data.onSuccess != null) 
			onSuccess = new Events(_type + ".onSuccess", data.onSuccess);
		if (data.onFail != null) 
			onFail = new Events(_type + ".onFail", data.onFail);
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
	
}