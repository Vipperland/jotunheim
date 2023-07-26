/**
 * ...
 * @author Rafael Moreira
 */
export class Positionable {
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
	sync(){
		this.x = this.xT;
		this.y = this.yT;
		this.w = this.wT;
		this.h = this.hT;
	}
	get top(){
		return this.yT;
	}
	get left(){
		return this.xT;
	}
	get bottom(){
		return this.yT + this.hT;
	}
	get right(){
		return this.xT + this.wT;
	}
	get width(){
		return this.wT;
	}
	get height(){
		return this.hT;
	}
	get x(){
		return this.xT;
	}
	get y(){
		return this.yT;
	}
	get pivotX(){
		return this.xT - (this.wT >> 1);
	}
	get pivotY(){
		return this.yT - (this.hT >> 1);
	}
	move(x,y){
		this.xT = x;
		this.yT = y;
	}
	scale(width, height){
		this.wT = width;
		this.hT = height;
	}
	
}