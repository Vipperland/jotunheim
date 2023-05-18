import {Delegator} from './Delegator.class.js';
import {RealmsEvents} from './RealmsEvents.class.js';
import {RealmsLocale} from './RealmsLocale.class.js';
import {RealmsDatabase} from './RealmsDatabase.class.js';
import {RealmsRequest} from './RealmsRequest.class.js';
import {RealmsTimer} from './RealmsTimer.class.js';

/*

	Event oauthstatus
		request		Needs to be updated
		refresh		Initial 

*/

export class Realms {

	static #_busy;
	static #_oauth;
	static #_user;
	static #_queue = [];
	static #_database;
	static #_locale;
	static #_events = new RealmsEvents();
	static #_timer = RealmsTimer.now();

	static #_callNext(){
		if(!Realms.#_busy && Realms.#_queue.length > 0){
			var ticket = Realms.#_queue.shift();
			if(ticket != null){
				Realms.#_busy = true;
				var h = { 'Content-Type':'application/json' };
				if(Realms.#_oauth != null){
					var oauth = J_Packager.encodeBase64('(y)=>' + Realms.#_getOAuth());
					if(oauth){
						h.authorization = oauth;
					}
				}
				if(ticket.url.substr(0,1)=='/'){
					ticket.url = '/api' + ticket.url;
				}
				trace('[API] (y) ' + (h.authorization?'*':'') + '=> ' + ticket.url + ' => ', ticket.data);
				Jotun.request(ticket.url, ticket.data, (ticket.method || 'GET').toUpperCase(), Delegator.create(this, function(result){
					var data;
					if(result.error){
						data = {
							errors: [result.error.message.split('#').pop()],
						};
					}else{
						data = result.object();
					}
					data.success = data.errors.length == 0;
					if(!data.success){
						for(var error in data.errors){
							var code = data.errors[error];
							data.errors[error] = {
								code: code,
								message: this.locale.get('E_' + code),
							};
						}
					}
					var oauth = result.headers ? result.headers['authorization'] || result.headers['Authorization'] : '';
					data.authentication = {
						identity: this.#_oauth != null,
						revoked: false,
						expired: false,
					};
					this.#_events.call('request', { ticket: ticket, request: data });
					if(ticket.updateOAuth != true && (oauth == null || oauth == this.#_oauth)){
						this.#_logBefore(data, ticket.callback);
					}else {
						this.#_verifyOAuth(oauth, data, ticket.callback);
					}
					this.#_busy = false;
					this.#_callNext();
				}), h);
			}
		}
	}

	static get events(){
		return this.#_events;
	}
	
	static get locale(){
		return this.#_locale;
	}
	
	static get timer(){
		return this.#_timer;
	}
	
	static get timestamp(){
		return new Date().getTime();
	}
	
	static init(dbInfo){
		this.#_locale = new RealmsLocale();
		if(dbInfo != null){
			this.#_database = new RealmsDatabase(dbInfo.name || 'realms.db', dbInfo.version || 1, dbInfo.structure || {});
			this.#_database.get('oauth', Delegator.create(this, function(value){
				if(value != null){
					this.#_oauth = value.key;
					this.#_user = value.user;
					if(this.#_timer.elapsed(value.time) > 1){
						this.#_sendOAuthStatus('request');
					}
				}
				this.#_sendOAuthStatus('refresh');
			}));
		}
	}
	
	static #_sendOAuthStatus(status){
		this.#_events.call('oauthstatus', {status: status, token: this.#_getOAuth(), user: this.#_user });
	}
	
	//static #_refreshOAuth(){
		//Realms.request('/session/verify', null, 'get', function(result){
			//if(result.success){ }
		//}).forceUpdate();
	//}

	static #_cancel(){
		Realms.#_queue = [];
		Realms.#_busy = false;
	}

	static #_getOAuth(){
		return Realms.#_oauth != null ? J_Packager.decodeBase64(Realms.#_oauth).split('(y)<=').pop() : null;
	}

	static #_verifyOAuth(oauth, data, callback){
		var tmp = J_Packager.decodeBase64(oauth);
		if(tmp.substr(0, 5) == '(y)<='){
			tmp = tmp.split('(y)<=').pop();
			switch(tmp.toUpperCase()){
				case 'EXPIRED' : {
					this.#_sendOAuthStatus('expired');
				}
				case 'REVOKE' : {
					this.#_sendOAuthStatus('revoked');
				}
				case 'INVALID' : {
					Realms.#_oauth = null;
					this.#_sendOAuthStatus('invalid');
					this.#_database.del('oauth', Delegator.create(this, function(){
						Realms.#_logBefore(data, callback);
					}));
					break;
				}
				default : {
					Realms.#_oauth = oauth;
					if(data.user != null){
						Realms.#_user = data.user;
						this.#_database.replace('oauth', { key:oauth, time:this.timer.now, user:data.user }, Delegator.create(this, function(o){
							this.#_logBefore(data, callback);
							this.#_sendOAuthStatus('updated');
						}));
					}
					break;
				}
			}
		}
	}

	static #_logBefore(data, callback){
		trace('[API] (y) <=', data);
		if(callback != null){
			callback(data);
		}
	}

	static request(url, data, method, callback, important){
		var ticket = new RealmsRequest(url, data, method, callback, important);
		if(important){
			this.#_queue.unshift(ticket);
		}else{
			this.#_queue.push(ticket);
		}
		this.#_callNext();
		return ticket;
	}
	
	static expose(){
		window.Realms = Realms;
	}

}