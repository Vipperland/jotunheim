export class RealmsRequest {
	constructor(url, data, method, callback){
		this.url = url;
		this.data = data;
		this.method = method;
		this.callback = callback;
		this.updateOAuth = false;
	}
	forceUpdate(){
		this.updateOAuth = true;
		return this;
	}
}