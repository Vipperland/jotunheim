/**
 * ...
 * @author Rafael Moreira
 */
export class BiomeCore {
	#_biome;
	#_paused;
	#_time;
	#_runables;
	#_lenght;
	#_render(){
		if(!this.#_paused){
			let time = Date.now();
			let elapsed = time - this.#_time;
			for (let i = 0; i < this.#_lenght; i++) {
				this.#_runables[i](elapsed);
			}
			this.#_time  = time;
			this.#_biome.update();
		}
	}
	constructor(biome){
		this.#_time = Date.now();
		this.#_biome = biome;
		this.#_paused = false;
		this.#_runables = [];
		this.#_lenght = 0;
		setInterval(this.#_render.bind(this), 1);
	}
	add(handler){
		if(!this.#_runables.includes(handler)){
			this.#_runables[this.#_lenght] = handler;
			++this.#_lenght;
		}
	}
	remove(handler){
		var iof = this.#_runables.indexOf(handler);
		if(iof != -1){
			this.#_runables.splice(iof, 1);
			--this.#_lenght;
		}
	}
	pause(){
		this.#_paused = true;
	}
	unpause(){
		this.#_paused = false;
	}
	delay(handler, delay, repeat, ...args){
		return new DelayedMethod(this, handler, delay, repeat, args);
	}
	
}
class DelayedMethod {
	#_elapsed;
	#_timeout;
	#_method;
	#_core;
	#_args;
	#_count;
	#_repeat;
	#_proxy;
	#_advance(time){
		this.#_elapsed += time;
		if(this.#_elapsed >= this.#_timeout){
			this.#_elapsed -= this.#_timeout;
			this.call();
		}
	}
	constructor(core, method, delay, repeat, args){
		this.#_core = core;
		this.#_count = 0;
		this.#_repeat = repeat || 1;
		this.#_elapsed = 0;
		this.#_timeout = delay * 1000;
		this.#_method = method;
		this.#_args = args;
		this.#_proxy = this.#_advance.bind(this);
		core.add(this.#_proxy);
	}
	cancel(){
		this._core.remove(this.advance);
	}
	call(){
		++this.#_count;
		this.#_method.apply(null, this.#_args);
		if(this.#_count >= this.#_repeat){
			this.#_core.remove(this.#_proxy);
			this.#_proxy = null;
			this.#_method = null;
			this.#_args = null;
		}
	}
}