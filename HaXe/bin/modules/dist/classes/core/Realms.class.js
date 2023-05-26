import {Delegator} from './Delegator.class.js';
import {RealmsEvents} from './RealmsEvents.class.js';
import {RealmsLocale} from './RealmsLocale.class.js';
import {RealmsDatabase} from './RealmsDatabase.class.js';
import {RealmsRequest} from './RealmsRequest.class.js';
import {RealmsAuthentication} from './RealmsAuthentication.class.js';
import {RealmsTimer} from './RealmsTimer.class.js';

/*

	Event oauthstatus
		timeout		Needs to be updated
		updated		Local token or user changed 
		revoked		Token is invalidated by server or client
		invalid		Token has an invalid value
		expired		Token has expired

*/

export class Realms {

	static #_busy;
	static #_authentication;
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
				if(this.#_authentication.valid){
					var oauth = this.#_authentication.header;
					if(oauth){
						h.authorization = oauth;
					}
				}
				trace('[API] (y) ' + (h.authorization?'*':'') + '=> ' + ticket.url + ' : ', ticket.data);
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
					this.#_events.call('request', { ticket: ticket, request: data, authentication: this.#_authentication.publicToken});
					if(ticket.updateOAuth != true && (oauth == null || this.#_authentication.match(oauth))){
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
	
	static init(instance, config){
		if(config == null){
			config = {
				auth: null,
				db: {},
			};
		}
		this.#_locale = new RealmsLocale();
		this.#_database = new RealmsDatabase(config.db.name || 'realms.db', config.db.version || 1, config.db.structure || {});
		this.#_authentication = new RealmsAuthentication(config.auth || {});
		Singularity.signals.add('onMain', Delegator.create(this, this.#_singularityProxy));
		Singularity.signals.add('onVisibility', Delegator.create(this, this.#_singularityProxy));
		Singularity.signals.add('onConnect', Delegator.create(this, this.#_singularityShare));
		Singularity.signals.add('onDisconnect', Delegator.create(this, this.#_singularityProxy));
		Singularity.signals.add('onSync', Delegator.create(this, this.#_singularityProxy));
		Singularity.connect(instance);
		this.#_initOAuth();
		this.#_testOAuth();
	}
	
	static #_initOAuth(){
		this.#_database.get('oauth', Delegator.create(this, function(value){
			if(value != null){
				this.#_updateAuthentication(value.key, value.user, value.time);
			}
			this.#_sendOAuthStatus('updated');
		}));
	}
	
	static #_updateAuthentication(key, user, time){
		this.#_authentication.update(key, user, time);
		if(this.#_authentication.time.hours.elapsed() >= 1){
			this.#_sendOAuthStatus('timeout');
		}else{
			Singularity.sync({
				authentication: {
					key:value.key,
					user:value.user,
					time:data.time
				}
			});
		}
	}
	
	static #_singularityShare(event){
		this.#_singularityProxy(event);
	}
	
	static #_singularityProxy(event){
		this.#_events.call('singularity', event);
	}
	
	static #_sendOAuthStatus(status){
		this.#_events.call('oauthstatus', {status: status, authentication: this.#_authentication.publicToken});
	}
	
	static #_testOAuth(){
		this.request('/sys/session/verify', null, 'get', function(result){
			if(result.success){ }
		}).authenticate();
	}

	static #_cancel(){
		Realms.#_queue = [];
		Realms.#_busy = false;
	}

	static #_verifyOAuth(oauth, data, callback){
		var state = this.#_authentication.validate(oauth);
		if(state.valid){
			var time = this.timer.value;
			if(state.expired || state.revoked || state.invalid){
				this.#_updateAuthentication(oauth, null, null);
				this.#_database.del('oauth', Delegator.create(this, function(){
					this.#_logBefore(data, callback);
				}));
				this.#_sendOAuthStatus(event);
			}else{
				if(data.user != null){
					this.#_updateAuthentication(oauth, data.user, time);
					this.#_database.replace('oauth', { key:oauth, time:time, user:data.user }, Delegator.create(this, function(o){
						this.#_logBefore(data, callback);
						this.#_sendOAuthStatus('updated');
					}));
				}else{
					this.#_updateAuthentication(oauth, null, null);
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