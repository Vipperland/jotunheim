/**
 * ...
 * @author Rafael Moreira
 */
export class BiomeScan {
	data;
	max;
	result;
	#_length;
	#_filter;
	#_active;
	constructor(filter, max){
		this.result = [];
		this.#_filter = filter;
		this.#_length = 0;
		this.#_active = true;
		this.max = max || 0;
		this.data = {};
	}
	get active(){
		return this.#_active;
	}
	get length(){
		return this.#_length;
	}
	add(value){
		if(this.#_filter == null || this.#_filter(value, this)){
			this.result[this.#_length] = value;
			++this.#_length;
			if(this.#_length == this.max){
				this.stop();
			}
		}
	}
	call(){
		this.#_filter.apply(this, arguments);
	}
	stop(){
		this.#_active = false;
	}
	each(fx){
		for(var i in this.result){
			fx(this.result[i]);
		}
	}
	get(index){
		return this.result[index];
	}
}