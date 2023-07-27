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
	#_pending;
	#_updated;
	#_options;
	#_position;
	#_blocked;
	#_test(flag){
		return (this.#_options & flag) == flag;
	}
	#_testf(opt,flag){
		return (opt & flag) == flag;
	}
	constructor(name, x, y, width, height, options, data){
		this.#_id = '' + OBJECT_UID++;
		this.#_name = name;
		this.#_data = data || {};
		this.#_options = options || BiomeConstants.TILE_WALKABLE;
		this.#_position = new Positionable(x, y, width, height);
	}
	get room(){
		return this.#_room;
	}
	set room(value){
		this.#_room = value;
	}
	get isWalkable(){
		return !this.#_blocked && this.#_test(BiomeConstants.TILE_WALKABLE);
	}
	get isSolid(){
		return this.#_test(BiomeConstants.TILE_SOLID);
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
		return this.room.top + this.#_position.yT;
	}
	get left(){
		return this.room.left + this.#_position.xT;
	}
	get bottom(){
		return this.room.top +this.#_position.yT + this.#_position.hT;
	}
	get right(){
		return this.room.left + this.#_position.xT + this.#_position.wT;
	}
	get biomeX(){
		return (this.room ? this.room.left + this.#_position.xT: 0);
	}
	get biomeY(){
		return (this.room ? this.room.top + this.#_position.yT: 0);
	}
	get biomePivotX(){
		return this.left + (this.#_position.wT >> 1);
	}
	get biomePivotY(){
		return this.top + (this.#_position.hT >> 1);
	}
	get visible(){
		return this.room && this.#_visible;
	}
	block(value){
		this.#_blocked = value;
	}
	get blocked(){
		return this.#_blocked;
	}
	#_load(){
		let object = this;
		this.room.biome.map(this.left, this.top, this.right, this.bottom, function(t){
			t.load(object);
		});
	}
	#_unload(){
		let object = this;
		this.room.biome.map(this.left, this.top, this.right, this.bottom, function(t){
			t.unload(object);
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
			this.#_updated = false;
			this.#_pending = false;
			this.#_unload();
			return true;
		}else{
			return false;
		}
	}
	update(){
		if(!this.#_updated && this.visible){
			this.#_updated = true;
			this.#_pending = true;
			this.room.queue(this);
		}
	}
	commit(){
		if(this.#_pending == true){
			this.#_pending = false;
			return true;
		}else{
			return false;
		}
	}
	normalize(){
		if(this.#_updated == true){
			this.#_updated = false;
			if(this.room && this.room.biome){
				this.#_unload();
				this.#_position.sync();
				this.#_load();
			}
			return true;
		}else{
			return false;
		}
	}
	move(x,y){
		this.#_position.move(x,y);
	}
	scale(w,h){
		this.#_position.scale(w,h);
	}
	get position(){
		return this.#_position;
	}
	get tx(){
		return this.#_room.biome.area.tx(this.biomeX);
	}
	get ty(){
		return this.#_room.biome.area.ty(this.biomeY);
	}
	collision(filter){
		if(this.visible){
			return this.room.biome.collision(this.left, this.top, this.right, this.bottom, filter);
		}
	}
	signal(distance,filter){
		return this.room.biome.signal(this.biomePivotX, this.biomePivotY, distance, filter);
	}
	raycast(direction, distance, filter){
		switch(direction){
			case BiomeConstants.TOP : {
				return this.room.biome.raycast(this.room.biome.tiles(this.left, this.top, this.right, this.top), [{x:0,y:-1}], distance, filter);
				break;
			}
			case BiomeConstants.RIGHT : {
				return this.room.biome.raycast(this.room.biome.tiles(this.right, this.top, this.right, this.bottom), [{x:1,y:0}], distance, filter);
				break;
			}
			case BiomeConstants.BOTTOM : {
				return this.room.biome.raycast(this.room.biome.tiles(this.left, this.bottom, this.right, this.bottom), [{x:0,y:1}], distance, filter);
				break;
			}
			case BiomeConstants.LEFT : {
				return this.room.biome.raycast(this.room.biome.tiles(this.left, this.top, this.left, this.bottom), [{x:-1,y:0}], distance, filter);
				break;
			}
		}
		return null;
	}
	toString(){
		return "[RomObject{id:" + this.id + ",name:" + this.name + ",x:" + this.biomeX + ",y:" + this.biomeY + ",width:" + this.position.width + ",height:" + this.position.height + "}]";
	}
	
}