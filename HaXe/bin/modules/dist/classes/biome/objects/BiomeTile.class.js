/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeScan} from '../data/BiomeScan.class.js';
export class BiomeTile {
	#_id;
	#_x;
	#_y;
	#_objects;
	#_biome;
	#_tTop;
	#_tTRight;
	#_tTLeft;
	#_tRight;
	#_tBottom;
	#_tBRight;
	#_tBLeft;
	#_tLeft;
	#_put(os,o){
		if(o != null){
			os[os.length] = o;
		}
		return os;
	}
	constructor(x,y,biome){
		this.#_id = x + '.' + y;
		this.#_x = x;
		this.#_y = y;
		this.#_objects = {};
		this.#_biome = biome;
	}
	get id(){
		return this.#_id;
	}
	get x(){
		return this.#_x;
	}
	get y(){
		return this.#_y;
	}
	get biome(){
		return this.#_biome;
	}
	get tx(){
		return this.biome.area.tx(this.#_x);
	}
	get ty(){
		return this.biome.area.ty(this.#_y);
	}
	get borderTop(){
		return this.#_y <= this.#_biome.area.top;
	}
	get borderRight(){
		return this.#_x >= this.#_biome.area.right;
	}
	get borderBottom(){
		return this.#_y >= this.#_biome.area.bottom;
	}
	get borderLeft(){
		return this.#_x <= this.#_biome.area.left;
	}
	get tileTop(){
		if(!this.borderTop && this.#_tTop == null){
			this.#_tTop = this.#_biome.tile(this.#_x, this.#_y - 1);
		}
		return this.#_tTop;
	}
	get tileTopLeft(){
		if(!this.borderTop && !this.borderLeft && this.#_tTLeft == null){
			this.#_tTLeft = this.#_biome.tile(this.#_x - 1, this.#_y - 1);
		}
		return this.#_tTLeft;
	}
	get tileTopRight(){
		if(!this.borderTop && !this.borderRight && this.#_tTRight == null){
			this.#_tTRight = this.#_biome.tile(this.#_x + 1, this.#_y - 1);
		}
		return this.#_tTRight;
	}
	get tileBottom(){
		if(!this.borderBottom && this.#_tBottom == null){
			this.#_tBottom = this.#_biome.tile(this.#_x, this.#_y + 1);
		}
		return this.#_tBottom;
	}
	get tileBottomLeft(){
		if(!this.borderBottom && !this.borderLeft && this.#_tBLeft == null){
			this.#_tBLeft = this.#_biome.tile(this.#_x - 1, this.#_y + 1);
		}
		return this.#_tBLeft;
	}
	get tileBottomRight(){
		if(!this.borderBottom && !this.borderRight && this.#_tBRight == null){
			this.#_tBRight = this.#_biome.tile(this.#_x + 1, this.#_y + 1);
		}
		return this.#_tBRight;
	}
	get tileLeft(){
		if(!this.borderLeft && this.#_tLeft == null){
			this.#_tLeft = this.#_biome.tile(this.#_x - 1, this.#_y);
		}
		return this.#_tLeft;
	}
	get tileRight(){
		if(!this.borderRight && this.#_tRight == null){
			this.#_tRight = this.#_biome.tile(this.#_x + 1, this.#_y);
		}
		return this.#_tRight;
	}
	objects(fn, max){
		for(var object in this.#_objects){
			fn(this.#_objects[object]);
			if(max != null && --max <= 0){
				break;
			}
		}
	}
	get occupation(){
		var scanner = new BiomeScan();
		this.objects(function(o){
			scanner.add(o);
		});
		return scanner;
	}
	load(object){
		this.#_objects[object.id] = object;
	}
	unload(object){
		delete this.#_objects[object.id];
	}
	next(x,y){
		return this.#_biome.tile(this.x + x, this.y + y);
	}
	neighbors(objects,square){
		if(square){
			this.#_put(objects, this.tileTop);
			this.#_put(objects, this.tileTopRight);
			this.#_put(objects, this.tileRight);
			this.#_put(objects, this.tileBottomRight);
			this.#_put(objects, this.tileBottom);
			this.#_put(objects, this.tileBottomLeft);
			this.#_put(objects, this.tileLeft);
			this.#_put(objects, this.tileTopLeft);
		}else{
			this.#_put(objects, this.tileTop);
			this.#_put(objects, this.tileRight);
			this.#_put(objects, this.tileBottom);
			this.#_put(objects, this.tileLeft);
		}
		return objects;
	}
	toString(){
		return "[BiomeTile{id:" + this.id + "}]";
	}
}