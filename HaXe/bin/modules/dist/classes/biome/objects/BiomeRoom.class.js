/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeTile} from './BiomeTile.class.js';
import {RoomObject} from './RoomObject.class.js';
import {BiomeConstants} from '../data/BiomeConstants.class.js';
import {Positionable} from '../math/Positionable.class.js';

export class BiomeRoom {
	#_name;
	#_objects;
	#_updated;
	#_pending;
	#_visible;
	#_walls;
	#_tile;
	#_test(flag,opt){
		return (flag & opt) == opt;
	}
	constructor(name, x, y, width, height, walls, data){
		this.biome = null;
		this.#_objects = [];
		this.#_updated = [];
		this.#_walls = walls;
		this.#_tile = new Positionable(x, y, width, height);
	}
	get name(){
		return this.#_name;
	}
	get top(){
		return this.#_tile.yT;
	}
	get left(){
		return this.#_tile.xT;
	}
	get bottom(){
		return this.#_tile.yT + this.#_tile.hT;
	}
	get right(){
		return this.#_tile.xT + this.#_tile.wT;
	}
	get centerX(){
		return this.#_tile.xT + (this.#_tile.wT >> 1);
	}
	get centerY(){
		return this.#_tile.yT + (this.#_tile.hT >> 1);
	}
	get walls(){
		return this.#_walls;
	}
	get visible(){
		return this.#_visible && this.biome != null;
	}
	isPosInside(x, y){
		return x >= this.left && y >= this.top && x <= this.right && y <= this.bottom;
	}
	isTileInside(tile){
		return this.isPosInside(tile.x, tile.y);
	}
	map(fn){
		if(this.biome != null){
			this.biome.map(this.left, this.top, this.right, this.bottom, fn);
		}
	}
	add(object, x, y, width, height, data){
		if(typeof object == 'string'){
			object = new RoomObject(object, x, y, width, height, data);
		}
		this.#_objects.push(object);
		if(this.visible){
			this.update(object);
		}
	}
	remove(object){
		var iof = this.objects.indexOf(o);
		if(iof != -1){
			this.objects.splice(iof, 1);
		}
	}
	load(){
		if(!this.visible && !this.#_pending){
			this.#_pending = true;
			this.biome.load(this);
			return true;
		}else{
			return false;
		}
	}
	commit(){
		if(this.#_pending){
			this.#_pending = false;
			this.#_visible = true;
			return true;
		}else{
			return false;
		}
	}
	unload(){
		if(this.biome && this.visible){
			this.#_visible = false;
			this.biome.unload(this);
			return true;
		}else{
			return false;
		}
	}
	inner(){
		this.biome.map(
			this.left + (this.isWalled(BiomeConstants.WALL_LEFT) ? 1 : 0), 
			this.top + (this.isWalled(BiomeConstants.WALL_TOP) ? 1 : 0), 
			this.right - (this.isWalled(BiomeConstants.WALL_RIGHT) ? 1 : 0), 
			this.bottom - (this.isWalled(BiomeConstants.WALL_BOTTOM) ? 1 : 0), 
			fn
		);
	}
	outer(filter){
		if(filter == null || filter == 0){
			filter = this.#_walls;
		}
		if(this.#_test(filter, BiomeConstants.WALL_TOP)){
			this.biome.map(this.left, this.top, this.right, this.top, fn);
		}
		if(this.#_test(filter, BiomeConstants.WALL_RIGHT)){
			this.biome.map(this.right, this.top, this.right, this.bottom, fn);
		}
		if(this.#_test(filter, BiomeConstants.WALL_BOTTOM)){
			this.biome.map(this.left, this.bottom, this.right, this.bottom, fn);
		}
		if(this.#_test(filter, BiomeConstants.WALL_LEFT)){
			this.biome.map(this.left, this.top, this.left, this.bottom, fn);
		}
	}
	map(){
		this.biome.map(this.left, this.top, this.right, this.bottom, fn);
	}
	isWalled(flags){
		return this.#_test(this.#_walls, flags);
	}
	objects(fn){
		for(var o in this.#_objects){
			fn(this.#_objects[o]);
		}
	}
	updated(fn){
		if(this.#_updated.length > 0){
			for(var o in this.#_updated){
				fn(this.#_updated[o]);
			}
			this.#_updated = [];
			return true;
		}else{
			return false;
		}
	}
	queue(object){
		if(object.commit()){
			this.#_updated.push(object);
		}
	}
	sort(){
	}
}