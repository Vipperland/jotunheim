/**
 * ...
 * @author Rafael Moreira
 */
export default class Location {
	x;
	y;
	w;
	h;
	xT;
	yT;
	wT;
	hT;
	c;
	constructor(x, y, w, h){
		this.move(x, y);
		this.scale(w, h);
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
		this.c = false;
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
		Set [x,y] to this location
	*/
	place(x,y){
		this.xT = x;
		this.yT = y;
		this.c = true;
	}
	/*
		Move [x,y] by a ammount
	*/
	move(x,y){
		this.xT = x;
		this.yT = y;
		this.c = true;
	}
	/*
		Scale [width,height] by a ammount
	*/
	scale(w, h){
		this.wT = w;
		this.hT = h;
		this.c = true;
	}
	/*
		Cancel the changes
	*/
	revert(){
		this.xT = this.x;
		this.yT = this.y;
		this.wT = this.w;
		this.hT = this.h;
		this.c = false;
	}
	get changed(){
		return this.c;
	}
}