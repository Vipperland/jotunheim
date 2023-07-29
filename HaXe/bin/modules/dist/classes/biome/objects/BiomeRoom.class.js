/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeTile} from './BiomeTile.class.js';
import {BiomeObject} from './BiomeObject.class.js';
import {BiomeLiveObject} from './BiomeLiveObject.class.js';
import {BiomeConstants} from '../data/BiomeConstants.class.js';
import {BiomeUtils} from '../data/BiomeUtils.class.js';
import {BiomeLocation} from '../math/BiomeLocation.class.js';

export class BiomeRoom {
	#_name;
	#_objects;
	#_updated;
	#_pending;
	#_visible;
	#_doors;
	#_position;
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
		this.#_position = new BiomeLocation(x, y, width, height);
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
		return this.#_position.top;
	}
	/*
		The left bound of this room
			room.left
	*/
	get left(){
		return this.#_position.left;
	}
	/*
		The bottom bound of this room
			room.bottom
	*/
	get bottom(){
		return this.#_position.bottom;
	}
	/*
		The right bound of this room
			room.right
	*/
	get right(){
		return this.#_position.right;
	}
	/*
		The center X point of this room
			room.visible
	*/
	get centerX(){
		return this.#_position.xT + (this.#_position.wT >> 1);
	}
	/*
		The center Y point of this room
			room.visible
	*/
	get centerY(){
		return this.#_position.yT + (this.#_position.hT >> 1);
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
	inside(x, y, border){
		return x >= this.left && y >= this.top && x <= this.right && y <= this.bottom;
	}
	/*
		Check if location is on the border outside, but not in the diagonal corners
	*/
	border(x, y){
		return ((x == this.left -1 || x == this.right + 1) && (y >= this.top && y <= this.bottom)) || ((y == this.top -1 || y == this.bottom + 1) && (x >= this.left && x <= this.right));
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
		Set enter/exit point in this room for extra instructions. Doors can only be created between rooms.
		Doors need to be outside the room, in the border tiles
			room.doors();
	*/
	door(x, y){
		x += this.left;
		y += this.top;
		if(this.biome.area.inside(x, y)){
			let tile = this.biome.tile(x, y);
			if(this.border(tile.x, tile.y) && !this.#_doors.includes(tile)){
				this.#_doors.push(tile);
				tile.junction(this);
				return true;
			}
		}
		throw new Error("Biome: Can't create door(x:" + x + ",y:" + y + ") junction. Doors can only be added in gaps between rooms.");
	}
	/*
		Call fx(tile) on each enter/exit points in this room
			room.doors(function(t){
			});
	*/
	doors(filter){
		filter = BiomeUtils.scanner(filter);
		for(let i=0; i<this.#_doors.length; ++i){
			filter.add(this.#_doors[i]);
			if(!filter.active){
				break;
			}
		}
		return filter;
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
		Runs fx(tile) for each tile in this room
			room.map(function(t){
			});
	*/
	map(filter){
		return this.biome.map(this.left, this.top, this.right, this.bottom, filter);
	}
	/*
		Get room tile from [x,y] offsets
	*/
	tile(x, y){
		return this.biome.tile(this.left + x, this.right + y);
	}
	/*
		Call fx(object) for each added object in room
			room.objects(function(o){
			});
	*/
	objects(filter){
		filter = BiomeUtils.scanner(filter);
		for(let i=0; i<this.#_objects.length; ++i){
			filter.add(this.#_objects[i]);
			if(!filter.active){
				break;
			}
		}
	}
	/*
		Get all updated objects. This method don't use filter scanner for optimizations.
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
	/*
		Return all rooms linked to this by doors
	*/
	neighbors(filter){
		filter = BiomeUtils.scanner(filter);
		let origin = this;
		function j(r){
			if(r != origin && !filter.result.includes(r)){
				filter.add(r);
			}
		}
		this.doors(function(d){
			d.junctions(j);
		});
		return filter;
	}
}