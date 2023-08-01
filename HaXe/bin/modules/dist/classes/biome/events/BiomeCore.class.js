/**
 * ...
 * @author Rafael Moreira
 */
export class BiomeCore {
	#_biome;
	#_paused;
	#_time;
	#_time_id;
	#_runables;
	#_lenght;
	#_frametime;
	#_frametarget;
	#_fpsChannels;
	#_fpsChannel;
	#_init(){
		var target = 1000/this.#_frametarget;
		var diff = target/this.#_frametarget;
		for (let i = 0; i < this.#_frametarget; i++) {
			this.#_fpsChannels[i] = new FrameChannel(target, diff * i);
		}
	}
	#_render(){
		if(!this.#_paused){
			let time = Date.now();
			this.#_frametime = time - this.#_time;
			for (let i = 0; i < this.#_lenght; i++) {
				this.#_runables[i]();
			}
			for (let i = 0; i < this.#_frametarget; i++) {
				this.#_fpsChannels[i].tick(this.#_frametime);
			}
			this.#_time  = time;
			this.#_biome.update();
		}
	}
	/*
		Return a timed controlled channel to distribute processes. The frameChannel.active indicates when a frame can be executed.
			biome.core.frameChannel
	*/
	get frameChannel(){
		if(this.#_fpsChannel >= this.#_frametarget){
			this.#_fpsChannel -= this.#_frametarget;
		}
		return this.#_fpsChannels[this.#_fpsChannel++].info;
	}
	/*
		Indicates if processor is active
			biome.core.active
	*/
	get active(){
		return this.#_paused != true;
	}
	constructor(biome, fps){
		this.#_time = Date.now();
		this.#_biome = biome;
		this.#_paused = true;
		this.#_runables = [];
		this.#_lenght = 0;
		this.#_frametime = 0;
		this.#_frametarget = fps || 60;
		this.#_fpsChannel = 0;
		this.#_fpsChannels = [];
		this.#_init();
	}
	/*
		Last frame time execution
			biome.core.frameRate
	*/
	frameRate(){
		return this.#_frametime;
	}
	/*
		Register a method to be executed in runtime processor
			biome.core.add(method);
	*/
	add(handler){
		if(!this.#_runables.includes(handler)){
			this.#_runables[this.#_lenght] = handler;
			++this.#_lenght;
		}
	}
	/*
		Remove a method to be executed in runtime processor
			biome.core.remove(method);
	*/
	remove(handler){
		var iof = this.#_runables.indexOf(handler);
		if(iof != -1){
			this.#_runables.splice(iof, 1);
			--this.#_lenght;
		}
	}
	/*
		Pause Biome processor
			biome.core.pause();
	*/
	pause(){
		if(this.#_paused == false && this.#_time_id != null){
			clearInterval(this.#_time_id);
			this.#_time_id = null;
			this.#_paused = true;
		}
	}
	/*
		Resume Biome processor
			biome.core.resume();
	*/
	resume(){
		if(this.#_paused == true && this.#_time_id == null){
			this.#_time_id = setInterval(this.#_render.bind(this), 1);
			this.#_paused = false;
		}
	}
	/*
		Call a delayed function using the processor. If paused, delayed calls will wait for resume time.
	*/
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
class FrameChannel {
	#_count;
	#_target;
	info;
	constructor(target, start){
		this.#_target = target;
		this.#_count = start;
		this.info = new FrameActivation(target);
	}
	tick(time){
		if(this.info.active){
			this.#_count -= this.#_target;
		}
		this.#_count += time;
		this.info.active = this.#_count >= this.#_target;
	}
}
class FrameActivation {
	#_time;
	active;
	get time(){
		return this.#_time;
	}
	constructor(time){
		this.active = false;
		this.#_time = time;
	}
}