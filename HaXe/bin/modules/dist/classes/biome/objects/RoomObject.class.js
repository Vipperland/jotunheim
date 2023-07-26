/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeConstants} from '../data/BiomeConstants.class.js';
import {Positionable} from '../math/Positionable.class.js';
var OBJECT_UID = 0;
export class RoomObject {
	#_id;
	#_name;
	#_data;
	#_room;
	#_visible;
	#_updated;
	#_options;
	#_tile;
	#_test(flag){
		return (this.#_options & flag) == flag;
	}
	#_testf(opt,flag){
		return (opt & flag) == flag;
	}
	constructor(name, x, y, width, height, options, data){
		this.#_id = '' + OBJECT_UID++;
		this.#_name = name;
		this.#_data = data;
		this.#_options = options || BiomeConstants.TILE_WALKABLE;
		this.#_tile = new Positionable(x, y, width, height);
	}
	get isWalkable(){
		return this.#_test(BiomeConstants.TILE_WALKABLE);
	}
	get data(){
		return this.#_data;
	}
	get id(){
		return this.#_id;
	}
	get name(){
		return this.#_name;
	}
	get top(){
		return this.room.top + this.#_tile.yT;
	}
	get left(){
		return this.room.left + this.#_tile.xT;
	}
	get bottom(){
		return this.room.top +this.#_tile.yT + this.#_tile.hT;
	}
	get right(){
		return this.room.left + this.#_tile.xT + this.#_tile.wT;
	}
	get biomeX(){
		return (this.room ? this.room.left + this.#_tile.xT: 0);
	}
	get biomeY(){
		return (this.room ? this.room.top + this.#_tile.yT: 0);
	}
	get biomePivotX(){
		return this.left + (this.#_tile.wT >> 1);
	}
	get biomePivotY(){
		return this.top + (this.#_tile.hT >> 1);
	}
	get room(){
		return this.#_room;
	}
	set room(value){
		this.#_room = value;
	}
	get visible(){
		return this.room && this.#_visible;
	}
	#_load(){
		this.room.biome.map(this.room.x + this.#_tile.x, this.room.y + this.#_tile.y, this.room.x + this.#_tile.w, this.room.y + this.#_tile.h, function(t){
			t.load(this);
		});
	}
	#_unload(){
		this.room.biome.map(this.room.x + this.#_tile.x, this.room.y + this.#_tile.y, this.room.x + this.#_tile.w, this.room.y + this.#_tile.h, function(t){
			t.unload(this);
		});
	}
	load(){
		if(this.room && !this.#_visible){
			this.#_visible = true;
			this.#_load();
			return true;
		}else{
			return false;
		}
	}
	unload(){
		if(this.visible){
			this.room = null;
			this.#_visible = false;
			this.#_unload();
			return true;
		}else{
			return false;
		}
	}
	update(){
		if(!this.#_updated && this.visible){
			this.#_updated = true;
			this.room.queue(this);
		}
	}
	normalize(){
		if(this.#_updated){
			this.#_updated = false;
			if(this.room && this.room.biome){
				this.#_unload();
				this.#_tile.sync();
				this.#_load();
			}
			return true;
		}else{
			return false;
		}
	}
	move(x,y){
		this.#_tile.move(x,y);
	}
	scale(w,h){
		this.#_tile.scale(w,h);
	}
	collision(filter){
		if(this.visible){
			return this.room.biome.collision(this.left, this.top, this.right, this.bottom, filter);
		}
	}
	neighboors(filter){
	}
	ray(direction, filter){
		if(this.#_testf(direction, BiomeConstants.TOP)){
			
		}
	}
	
}