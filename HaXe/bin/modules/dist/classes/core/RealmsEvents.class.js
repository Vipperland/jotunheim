export class RealmsEvents {
	#_events = {};
	#_get(event){
		if(this.#_events[event] == null){
			this.#_events[event] = [];
		}
		return this.#_events[event];
	}
	constructor(){ }
	call(event, data){
		let ticket = {
			event: event,
			data: data,
		}
		Dice.Values(this.#_get(event), function(method){
			method(ticket);
		});
		Dice.Values(this.#_get("*"), function(method){
			method(ticket);
		});
	}
	listen(event, handler){
		this.#_get(event).push(handler);
	}
	unlisten(event, handler){
		let iof = this.#_get(event).indexOf(handler);
		if(iof >= 0){
			this.#_get(event).splice(iof, 1);
		}
	}
}