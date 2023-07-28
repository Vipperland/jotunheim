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
	test(value){
		return this.#_filter == null || this.#_filter(value, this);
	}
	put(value){
		if(value != null){
			this.add(value);
		}
	}
	call(){
		this.#_filter.apply(this, Array.from(arguments));
	}
	stop(){
		this.#_active = false;
	}
	each(filter){
		for (let i = 0; i < this.result.length; i++) {
			if(filter(this.result[i]) == false){
				break;
			}
		}
	}
	get(index){
		return this.result[index];
	}
}