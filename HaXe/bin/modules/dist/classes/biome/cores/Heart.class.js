/**
 * ...
 * @author Rafael Moreira
 */
export default class Heart {
	#_biome;
	#_get(event){
		event = event.toLowerCase();
		if(this.events[event] == null){
			this.events[event] = [];
		}
		return this.events[event];
	}
	#_execute(fns, data){
		for (let i = 0; i < fns.length; i++) {
			fns[i](data);
		}
	}
	constructor(biome){
		this.events = {};
		this.#_biome = biome;
	}
	/*
		Dispatches a hearthbeat with data for all listeners
	*/
	call(event, target, data){
		this.#_execute(this.#_get(event), new Heartbeat(event, target, data));
	}
	/*
		Listen for hearthbeats
			biome.heart.listen(name, onHeartbeat);
	*/
	listen(event, handler){
		this.#_get(event).push(handler);
	}
	/*
		Unlisten hearthbeats
			biome.heart.unlisten(name, onHeartbeat);
	*/
	unlisten(event, handler){
		var evts = this.#_get(event);
		for(var e in evts){
			if(evts[e] == handler){
				evts.splice(e, 1);
				break;
			}
		}
	}
}
class Heartbeat {
	#_data;
	#_event;
	#_target;
	get data(){
		return this.#_data;
	}
	get event(){
		return this.#_event;
	}
	get target(){
		return this.#_target;
	}
	constructor(event, target, data){
		this.#_event = event;
		this.#_target = target;
		this.#_data = data;
	}
}