export class RealmsRequest {
	#_pulsar;
	#_url;
	#_data;
	#_response;
	#_method;
	#_callback;
	#_updateOAuth = false;
	constructor(url, data, method, callback, pulsar){
		this.#_method = method;
		this.#_callback = callback;
		if(pulsar == true){
			if(url.indexOf('?') == -1){
				url += '?';
			}else {
				url += '&';
			}
			url += 'pulsar=y';
		}
		this.#_url = url;
		this.#_data = data;
		this.#_pulsar = pulsar;
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
	parseData(request, locale){
		var data;
		if(this.#_pulsar){
			data = request.pulsar();
			data.link('errors').filter('error', function(error){
				error.set('message', locale.get('E_' + error.prop('code')));
			});
		}else{
			data = data.object();
			if(data.error){
				data = {
					errors: [result.error.message.split('#').pop()],
				};
			}
			data.success = data.errors.length == 0;
			if(!data.success){
				for(var error in data.errors){
					var code = data.errors[error];
					data.errors[error] = {
						code: code,
						message: locale.get('E_' + code),
					};
				}
			}
		}
		this.#_response = data;
		return data;
	}
	dataIn(){
		if(this.#_pulsar){
			if(this.#_response != null){
				return this.#_response.getObject();
			}else{
				return null;
			}
		}else{
			return this.#_response;
		}
	}
	dataOut(){
		if(this.#_pulsar){
			if(this.#_data != null){
				return this.#_data.getObject();
			}else{
				return null;
			}
		}else{
			return this.#_data;
		}
	}
	sync(){
		if(this.#_callback != null){
			this.#_callback(this.#_response);
		}
	}
	
}