/**
 * ...
 * @author Rafael Moreira
 */
export class BiomeArea {
	#_x1;
	#_x2;
	#_y1;
	#_y2;
	#_tw;
	#_th;
	#_htw;
	#_hth;
	constructor(width, height){
		this.#_x1 = 0xFFFFFFFF;
		this.#_x2 = 0;
		this.#_y1 = 0xFFFFFFFF;
		this.#_y2 = 0;
		this.#_tw = width || 1;
		this.#_th = height || 1;
		this.#_htw = this.#_tw * .5;
		this.#_hth = this.#_th * .5;
	}
	fit(x1,y1,x2,y2){
		if(y1 < this.#_y1){
			this.#_y1 = y1;
		}
		if(y2 > this.#_y2){
			this.#_y2 = y2;
		}
		if(x1 < this.#_x1){
			this.#_x1 = x1;
		}
		if(x2 > this.#_x2){
			this.#_x2 = x2;
		}
	}
	inside(x,y){
		return this.#_x1 <= x && x <= this.#_x2 && this.#_y1 <= y && y <= this.#_y2;
	}
	get left(){
		return this.#_x1;
	}
	get right(){
		return this.#_x2;
	}
	get top(){
		return this.#_y1;
	}
	get bottom(){
		return this.#_y2;
	}
	get gridWidth(){
		return this.#_x2 - this.#_x1;
	}
	get gridHeight(){
		return this.#_y2 - this.#_y1;
	}
	get size(){
		return this.gridWidth * this.gridHeight;
	}
	get tileWidth(){
		return this.#_tw;
	}
	get tileHeight(){
		return this.#_th;
	}
	tx(x){
		return x * this.#_tw;
	}
	ty(y){
		return y * this.#_th;
	}
	ax(x, y){
		return (x - y) * this.#_htw;
	}
	ay(y, x){
		return (x + y) * this.#_hth;
	}
}