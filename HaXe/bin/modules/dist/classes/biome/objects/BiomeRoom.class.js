/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeTile} from './BiomeTile.class.js';
import {BiomeObject} from './BiomeObject.class.js';
import {BiomeConstants} from '../data/BiomeConstants.class.js';
import {BiomeLocation} from '../math/BiomeLocation.class.js';

export class BiomeRoom {
	#_name;
	#_objects;
	#_updated;
	#_pending;
	#_visible;
	#_doors;
	#_tile;
	#_test(flag,opt){
		return (flag & opt) == opt;
	}
	
	/*
		Create a new BiomeRoom
	*/
	constructor(name, x, y, width, height, data){
		this.biome = null;
		this.#_name = name;
		this.#_objects = [];
		this.#_updated = [];
		this.#_doors = [];
		this.#_tile = new BiomeLocation(x, y, width, height);
	}
	/*
		The name of this room
			room.name
	*/
	get name(){
		return this.#_name;
	}
	/*
		The top bound of this room
			room.top
	*/
	get top(){
		return this.#_tile.top;
	}
	/*
		The left bound of this room
			room.left
	*/
	get left(){
		return this.#_tile.left;
	}
	/*
		The bottom bound of this room
			room.bottom
	*/
	get bottom(){
		return this.#_tile.bottom;
	}
	/*
		The right bound of this room
			room.right
	*/
	get right(){
		return this.#_tile.right;
	}
	/*
		The center X point of this room
			room.visible
	*/
	get centerX(){
		return this.#_tile.xT + (this.#_tile.wT >> 1);
	}
	/*
		The center Y point of this room
			room.visible
	*/
	get centerY(){
		return this.#_tile.yT + (this.#_tile.hT >> 1);
	}
	/*
		If room is loaded in Biome
			room.visible
	*/
	get visible(){
		return this.#_visible && this.biome != null;
	}
	/*
		Check if a coordinate is inside this room
			room.inside(x, y);
	*/
	inside(x, y){
		return x >= this.left && y >= this.top && x <= this.right && y <= this.bottom;
	}
	border(x, y){
		x = (x == this.left -1 || x == this.right + 1);
		y = (y == this.top -1 || y == this.bottom + 1);
		return (x || y) && (x != y);
	}
	/*
		Check if a tile in inside this room
			room.contain(tile);
	*/
	contain(tile){
		return this.inside(tile.x, tile.y);
	}
	/*
		Add an object in this room
		The x and y coordinates of the object is relative to room, not to biome itself
			room.add(object) 
		or
			room.add(name, x, y, width, height, data);
	*/
	add(object, x, y, width, height, data){
		if(typeof object == 'string'){
			object = new BiomeObject(object, x, y, width, height, data);
		}
		this.#_objects.push(object);
		if(this.visible){
			this.update(object);
		}
		return object;
	}
	/* 
		Set enter/exit point in this room for extra instructions 
		Doors need to be outside the room, in the border tiles
			room.doors();
	*/
	door(tile){
		if(border(tile.x, tile.y) && !this.#_doors.contains(tile)){
			this.#_doors.push(tile);
			tile.junction(this);
		}
	}
	/*
		Call fx(tile) on each enter/exit points in this room
			room.doors(function(t){
			});
	*/
	doors(filter){
		for(let i=0; i<this.#_doors.length; ++i){
			if(filter(this.#_doors[i]) == false){
				break;
			}
		}
	}
	/*
		Remove an object from room
			room.remove(object);
	*/
	remove(object){
		var iof = this.objects.indexOf(o);
		if(iof != -1){
			this.objects.splice(iof, 1);
			if(this.visible){
				this.objects.unload();
			}
		}
	}
	/*
		Load this room and all objects into biome
			room.load();
	*/
	load(){
		if(!this.visible && !this.#_pending){
			this.#_pending = true;
			this.biome.load(this);
			return true;
		}else{
			return false;
		}
	}
	/*
		Unload this room and all objects from biome
			room.unload();
	*/
	unload(){
		if(this.biome && this.visible){
			this.#_visible = false;
			this.biome.unload(this);
			return true;
		}else{
			return false;
		}
	}
	/*
		Check if room needs to be loaded and mark as loaded in biome context
			room.commit();
	*/
	commit(){
		if(this.#_pending){
			this.#_pending = false;
			this.#_visible = true;
			return true;
		}else{
			return false;
		}
	}
	/*
		Runs fx(tile) for each tile inside of this room
			room.inner(function(t){
			});
	*/ 
	inner(options, filter){
		this.biome.map(
			this.left + 1, 
			this.top + 1, 
			this.right - 1, 
			this.bottom - 1, 
			filter
		);
	}
	/*
		Runs fx(tile) for each tile in border of this room
			room.outer(function(t){
			});
	*/ 
	outer(options, filter){
		if(this.#_test(options, BiomeConstants.WALL_TOP)){
			this.biome.map(this.left, this.top, this.right, this.top, filter);
		}
		if(this.#_test(options, BiomeConstants.WALL_RIGHT)){
			this.biome.map(this.right, this.top, this.right, this.bottom, filter);
		}
		if(this.#_test(options, BiomeConstants.WALL_BOTTOM)){
			this.biome.map(this.left, this.bottom, this.right, this.bottom, filter);
		}
		if(this.#_test(options, BiomeConstants.WALL_LEFT)){
			this.biome.map(this.left, this.top, this.left, this.bottom, filter);
		}
	}
	/*
		Lock all tiles sorrounding this room, except for doors entries
			room.lock();
	*/
	lock(){
		this.biome.lock(this.left - 1, this.top - 1, this.right, this.top - 1);
		this.biome.lock(this.right + 1, this.top - 1, this.right + 1, this.bottom);
		this.biome.lock(this.left, this.bottom + 1, this.right + 1, this.bottom + 1);
		this.biome.lock(this.left - 1, this.top, this.left - 1, this.bottom + 1);
		doors(function(t){
			t.unlock();
		});
	}
	/*
		Unlock all tiles sorrounding this room
			room.unlock();
	*/
	unlock(){
		this.biome.unlock(this.left - 1, this.top - 1, this.right, this.top - 1);
		this.biome.unlock(this.right + 1, this.top - 1, this.right + 1, this.bottom);
		this.biome.unlock(this.left, this.bottom + 1, this.right + 1, this.bottom + 1);
		this.biome.unlock(this.left - 1, this.top, this.left - 1, this.bottom + 1);
	}
	/*
		Runs fx(tile) for each tile in this room
			room.map(function(t){
			});
	*/
	map(filter){
		this.biome.map(this.left, this.top, this.right, this.bottom, filter);
	}
	/*
		Call fx(object) for each added object in room
			room.objects(function(o){
			});
	*/
	objects(filter){
		for(let i=0; i<this.#_objects.length; ++i){
			if(filter(this.#_objects[i]) == false){
				break;
			}
		}
	}
	/*
		Get all updated objects
			room.updated(function(o){
			});
	*/
	updated(filter){
		if(this.#_updated.length > 0){
			for(let i=0; i<this.#_updated.length; ++i){
				if(filter(this.#_updated[i]) == false){
					break;
				}
			}
			this.#_updated = [];
			this.biome.heart.call();
			return true;
		}else{
			return false;
		}
	}
	/*
		Signals an object to be updated
			room.queue(object);
	*/
	queue(object){
		if(object.commit()){
			this.#_updated.push(object);
		}
	}
	sort(){
	}
}