/**
 * ...
 * @author Rafael Moreira
 */
export default class Area {
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
	/*
		Update area bounds
	*/
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
	/*
		Test if a location is inside this area
	*/
	inside(x,y){
		return this.#_x1 <= x && x <= this.#_x2 && this.#_y1 <= y && y <= this.#_y2;
	}
	/*
		Left point
	*/
	get left(){
		return this.#_x1;
	}
	/*
		Right point
	*/
	get right(){
		return this.#_x2;
	}
	/*
		Top point
	*/
	get top(){
		return this.#_y1;
	}
	/*
		Bottom point
	*/
	get bottom(){
		return this.#_y2;
	}
	/*
		Area width in tiles
	*/
	get gridWidth(){
		return this.#_x2 - this.#_x1;
	}
	/*
		Area height in tiles
	*/
	get gridHeight(){
		return this.#_y2 - this.#_y1;
	}
	/*
		Ammount of tiles in this area
	*/
	get size(){
		return this.gridWidth * this.gridHeight;
	}
	/*
		Tile width
	*/
	get tileWidth(){
		return this.#_tw;
	}
	/*
		Tile height
	*/
	get tileHeight(){
		return this.#_th;
	}
	/* 
		Covert a grid point [x] in tile position X
	*/
	tx(x){
		return x * this.#_tw;
	}
	/* 
		Covert a grid point [y] in tile position Y
	*/
	ty(y){
		return y * this.#_th;
	}
	/* 
		Covert a grid point [x,y] in isometric tile position X
	*/
	ax(x, y){
		return (x - y) * this.#_htw;
	}
	/* 
		Covert a grid point [y,x] in isometric tile position Y
	*/
	ay(y, x){
		return (x + y) * this.#_hth;
	}
}