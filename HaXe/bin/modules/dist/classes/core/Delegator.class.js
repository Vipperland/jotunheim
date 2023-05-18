export class Delegator {
	static create(thisObj, method, ... outterArgs){
		if(typeof method == "string"){
			method = thisObj[method];
		}
		return function(... innerArgs) {
			return method.apply(thisObj, innerArgs.concat(outterArgs));
		};
	}
}