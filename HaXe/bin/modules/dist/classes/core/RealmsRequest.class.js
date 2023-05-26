export class RealmsRequest {
	#_url;
	#_data;
	#_method;
	#_callback;
	#_updateOAuth = false;
	constructor(url, data, method, callback){
		this.#_url = url;
		this.#_data = data;
		this.#_method = method;
		this.#_callback = callback;
	}
	get url(){
		return this.#_url;
	}
	get data(){
		return this.#_data;
	}
	get method(){
		return this.#_method;
	}
	get callback(){
		return this.#_callback;
	}
	get updateOAuth(){
		return this.#_updateOAuth;
	}
	authenticate(){
		this.#_updateOAuth = true;
		return this;
	}
}