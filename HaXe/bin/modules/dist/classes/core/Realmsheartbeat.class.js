export class RealmsHeartbeat {
	#_initialized;
	constructor(){ }
	start(){
		if(!this.#_initialized){
			this.#_initialized = true;
			Jotun.timer.resume();
		}
	}
	stop(){
		if(this.#_initialized){
			this.#_initialized = false;
			Jotun.timer.pause();
		}
	}
}