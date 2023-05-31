import {RealmsTimer} from './RealmsTimer.class.js';
class RealmsPublicToken {
	#_state;
	#_user;
	get state(){
		return this.#_state;
	}
	get user(){
		return this.#_user;
	}
	get valid(){
		return this.#_state ? this.#_state.valid : false;
	}
	constructor(state, user){
		this.#_state = state;
		this.#_user = user;
	}
	toString(){
		return "[RealmsPublicToken(user=" + JSON.stringify(this.#_user) + ",state=" + this.#_state.toString() + ")]";
	}
}
class RealmsAuthenticationState {
	#_key;
	#_state;
	constructor(token){
		this.#_key = token[0];
		if(this.#_key != null){
			this.#_key = this.#_key.toLowerCase();
		}
		this.#_state = token[1];
	}
	get valid(){
		return this.#_key != null;
	}
	get expired(){
		return this.#_state == 'expired';
	}
	get revoked(){
		return this.#_state == 'revoke';
	}
	get invalid(){
		return this.#_state == 'invalid';
	}
	get updated(){
		return this.#_state == 'updated';
	}
	get status(){
		return this.#_state;
	}
	get key(){
		return this.#_key;
	}
	toString(){
		return "[RealmsAuthenticationState(valid=" + this.valid + ",key=" + this.#_key + ",status=" + this.#_state + ")]";
	}
}
export class RealmsAuthentication {
	#_i;
	#_o;
	#_state;
	#_user;
	#_time;
	#_extract(token){
		token = J_Packager.decodeBase64(token || "");
		if(token.substr(0, this.#_i.length) == this.#_i){
			return new RealmsAuthenticationState(token.split(this.#_i));
		}else{
			return new RealmsAuthenticationState([null, null]);
		}
	}
	constructor(io){
		this.#_i = io.input || '(I)<=';
		this.#_o = io.output || '(O)=>';
		this.#_time = new RealmsTimer();
		this.clear();
	}
	get header(){
		return J_Packager.encodeBase64(this.#_o + this.#_state.key);
	}
	get valid(){
		return this.#_state.valid;
	}
	get publicToken(){
		return new RealmsPublicToken(this.#_state, this.#_user);
	}
	get time(){
		return this.#_time;
	}
	get state(){
		return this.#_state;
	}
	get user(){
		return this.#_user;
	}
	get signin(){
		return this.#_i;
	}
	get signout(){
		return this.#_o;
	}
	update(key, user, time){
		if(key != null){
			this.#_state = this.#_extract(token);
		}
		if(user != null){
			this.#_user = user;
		}
		if(time != null){
			this.#_time.bind(time);
		}
	}
	match(value){
		return this.#_state && this.#_state.key == value;
	}
	validate(token){
		return this.#_extract(token);
	}
	clear(){
		this.#_state = new RealmsAuthenticationState([null, null]);
		this.#_user = null;
		this.#_time.unbind();
	}
}