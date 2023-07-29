/**
 * ...
 * @author Rafael Moreira
 */
export class BiomeLocation {
	x;
	y;
	w;
	h;
	xT;
	yT;
	wT;
	hT;
	constructor(x, y, width, height){
		this.move(x, y);
		this.scale(width, height);
		this.sync();
	}
	/*
		Update end values. The end values will be loaded to object and room data on sync request.
	*/
	sync(){
		this.x = this.xT;
		this.y = this.yT;
		this.w = this.wT;
		this.h = this.hT;
	}
	/*
		Top location
	*/
	get top(){
		return this.yT;
	}
	/*
		Left location
	*/
	get left(){
		return this.xT;
	}
	/*
		Bottom location
	*/
	get bottom(){
		return this.yT + this.hT - 1;
	}
	/*
		Right location
	*/
	get right(){
		return this.xT + this.wT - 1;
	}
	/*
		Width in tiles
	*/
	get width(){
		return this.wT;
	}
	/*
		Height in tiles
	*/
	get height(){
		return this.hT;
	}
	/*
		Tile x position
	*/
	get x(){
		return this.xT;
	}
	/*
		Tile y position
	*/
	get y(){
		return this.yT;
	}
	/*
		Center tile x
	*/
	get pivotX(){
		return this.xT - (this.wT >> 1);
	}
	/*
		Center tile y
	*/
	get pivotY(){
		return this.yT - (this.hT >> 1);
	}
	/*
		Move [x,y] by a ammount
	*/
	move(x,y){
		this.xT = x;
		this.yT = y;
	}
	/*
		Scale [width,height] by a ammount
	*/
	scale(width, height){
		this.wT = width;
		this.hT = height;
	}
	
}