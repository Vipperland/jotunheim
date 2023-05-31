export class RealmsHeartbeat {
	#_initialized;
	constructor(){ }
	start(){
		if(!this.#_initialized){
			this.#_initialized = true;
			J_Ticker.start();
		}
	}
	stop(){
		if(this.#_initialized){
			this.#_initialized = false;
			J_Ticker.stop();
		}
	}
}