import {Delegator} from './Delegator.class.js';
import {RealmsEvents} from './RealmsEvents.class.js';
import {RealmsLocale} from './RealmsLocale.class.js';
import {RealmsDatabase} from './RealmsDatabase.class.js';
import {RealmsHeartbeat} from './RealmsHeartbeat.class.js';
import {RealmsRequest} from './RealmsRequest.class.js';
import {RealmsAuthentication} from './RealmsAuthentication.class.js';
import {RealmsTimer} from './RealmsTimer.class.js';
import {RealmsSparkError} from './sparks/RealmsSparkError.class.js';

/*

	Event oauthstatus
		timeout		Needs to be updated
		updated		Local token or user changed 
		revoked		Token is invalidated by server or client
		invalid		Token has an invalid value
		expired		Token has expired

*/

export class Realms {

	static #_config;
	static #_pulsar;
	static #_busy;
	static #_authentication;
	static #_oauth;
	static #_user;
	static #_queue = [];
	static #_database;
	static #_locale;
	static #_events = new RealmsEvents();
	static #_timer = RealmsTimer.now();
	static #_heartbeat;

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
				this.#_logPreCall(ticket, h.authorization);
				Jotun.request(ticket.url, ticket.data, (ticket.method || 'GET').toUpperCase(), Delegator.create(this, function(result){
					var data = ticket.parseData(result, this.locale);
					var oauth = result.headers ? result.headers['authorization'] || result.headers['Authorization'] : '';
					this.#_events.call('request', { ticket: ticket, request: data, authentication: this.#_authentication.publicToken});
					if(ticket.updateOAuth != true && (oauth == null || this.#_authentication.match(oauth))){
						this.#_logAfterCall(data, ticket);
					}else {
						this.#_verifyOAuth(oauth, data, ticket);
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
	
	static #_init(config, callback){
		if(config == null){
			config = {
				name: null,
				auth: null,
				db: {},
			};
		}
		if(config.auth == null){
			config.auth = {};
		}
		this.#_config = config;
		this.#_heartbeat = new RealmsHeartbeat();
		this.#_locale = new RealmsLocale();
		this.#_database = new RealmsDatabase(config.db.name || 'realms.db', config.db.version || 1, config.db.structure || {});
		this.#_authentication = new RealmsAuthentication(config.auth);
		Singularity.signals.add('onMain', Delegator.create(this, this.#_singularMain));
		//Singularity.signals.add('onVisibility', Delegator.create(this, this.#_singularProxy));
		Singularity.signals.add('onConnect', Delegator.create(this, this.#_singularShare));
		Singularity.signals.add('onDisconnect', Delegator.create(this, this.#_singularProxy));
		Singularity.signals.add('onSync', Delegator.create(this, this.#_singularProxy));
		Singularity.connect(config.name);
		if(config.pulsar){
			this.pulsar();
		}
		this.#_initOAuth();
		this.#_testOAuth();
		if(callback != null){
			callback();
		}
	}
	
	static open(config, callback){
		Jotun.run(Delegator.create(this, this.#_init, config, callback));
	}
	
	static pulsar(...map){
		if(this.#_pulsar != true){
			this.#_pulsar = true;
			Dice.Values([
				["_input"],
				["_logs"],
				["_logp", ['name','value']],
				["_logo", ['value']],
				["_logq", ['*']],
				["_logq", ['*']],
				["errors"],
				["error", ['code','message']],
				["time", ['*']],
				["status", ['*']]
			], function(v){
				Pulsar.map.apply(null, v);
			});
		}
		Dice.Values(map, function(v){
			Pulsar.map.apply(null, v);
		});
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
	
	static #_singularMain(event){
		this.#_initMainRoutines();
		this.#_singularProxy(event);
	}
	
	static #_singularShare(event){
		this.#_singularProxy(event);
	}
	
	static #_singularProxy(event){
		this.#_events.call('singularity', event);
	}
	
	static #_sendOAuthStatus(status){
		this.#_events.call('oauthstatus', {status: status, authentication: this.#_authentication.publicToken});
	}
	
	static #_initMainRoutines(){
		if(Singularity.isMain()){
			this.#_heartbeat.start();
		}
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

	static #_verifyOAuth(oauth, data, ticket){
		var state = this.#_authentication.validate(oauth);
		if(state.valid){
			var time = this.timer.value;
			if(state.expired || state.revoked || state.invalid){
				this.#_updateAuthentication(oauth, null, null);
				this.#_database.del('oauth', Delegator.create(this, function(){
					this.#_logAfterCall(data, ticket);
				}));
				this.#_sendOAuthStatus(event);
			}else{
				if(data.user != null){
					this.#_updateAuthentication(oauth, data.user, time);
					this.#_database.replace('oauth', { key:oauth, time:time, user:data.user }, Delegator.create(this, function(o){
						this.#_logAfterCall(data, ticket);
						this.#_sendOAuthStatus('updated');
					}));
				}else{
					this.#_updateAuthentication(oauth, null, null);
				}
			}
		}
	}

	static #_logPreCall(ticket, oauth){
		trace('[API] ' + this.#_authentication.signout + (oauth?'*':'') + ' @ ' + ticket.url + ' : ', ticket.dataOut());
	}

	static #_logAfterCall(data, callback){
		trace('[API] ' + this.#_authentication.signout + ' @ ', ticket.dataIn());
		ticket.sync();
	}

	static request(url, data, method, callback, important){
		var ticket = new RealmsRequest(url, data, method, callback, this.#_pulsar);
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