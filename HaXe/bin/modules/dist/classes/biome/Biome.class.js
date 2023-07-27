/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeConstants} from './data/BiomeConstants.class.js';
import {BiomeGrid} from './data/BiomeGrid.class.js';
import {BiomeHeart} from './events/BiomeHeart.class.js';
import {BiomeRoom} from './objects/BiomeRoom.class.js';
export class Biome {
	#_grid;
	#_rooms;
	#_loaded;
	#_heart;
	#_area;
	get constants(){
		return BiomeConstants;
	}
	get heart(){
		return this.#_heart;
	}
	get area(){
		return this.#_grid.area;
	}
	constructor(tw,th){
		this.#_rooms = {};
		this.#_loaded = [];
		this.#_heart = new BiomeHeart(this);
		this.#_grid = new BiomeGrid(this);
	}
	exists(x,y){
		return this.#_grid.exists(x,y);
	}
	/*
		Create/Add a Biome Room and allocate tiles 
	*/
	add(room,x,y,width,height,walls,data){
		if(typeof room == 'string'){
			room = new BiomeRoom(room, x, y, width, height, walls || BiomeConstants.WALL_ALL, data);
		}
		this.#_grid.create(room.left, room.top, room.right, room.bottom);
		this.#_rooms[room.name] = room;
		room.biome = this;
		this.#_heart.call(BiomeConstants.EVT_ROOM_ADDED, room);
		return room;
	}
	load(room){
		if(typeof room == 'string'){
			room = this.getRoom(name);
		}
		if(room && room.commit()){
			this.#_loaded.push(room);
			var h = this.#_heart;
			room.objects(function(o){
				o.room = room;
				if(o.load()){
					h.call(BiomeConstants.EVT_OBJECT_LOADED, o);
				}
			});
			this.#_heart.call(BiomeConstants.EVT_ROOM_LOADED, room);
		}
	}
	unload(room){
		if(typeof room == 'string'){
			room = this.getRoom(name);
		}
		if(room && room.unload()){
			var iof = this.#_loaded.indexOf(room);
			if(iof > 0){
				this.#_loaded.splice(iof, 1);
				room.objects(function(o){
					if(o.unload()){
						this.#_heart.call(BiomeConstants.EVT_OBJECT_UNLOADED, room);
					}
				});
				this.#_heart.call(BiomeConstants.EVT_ROOM_UNLOADED, room);
			}
		}
	}
	getRoom(name){
		return this.#_rooms[room.name];
	}
	getRoomUnder(x,y){
		for(var room in this.#_rooms){
			room = this.#_rooms[room];
			if(room.isPosInside(x,y)){
				return room;
			}
		}
		return null;
	}
	update(){
		for(var room in this.#_loaded){
			room = this.#_loaded[room];
			if(room.updated(function(o){
				if(o.normalize()){
					this.#_heart.call(BiomeConstants.EVT_OBJECT_UPDATED, room);
				}
			})){
				this.#_heart.call(BiomeConstants.EVT_ROOM_UPDATED, room);
			}
		}
	}
	tile(x,y){
		return this.#_grid.tile(x,y);
	}
	tiles(x1,y1,x2,y2){
		return this.#_grid.tiles(x1,y1,x2,y2);
	}
	/*
		Iterate valid tiles in an area, calls fn(tile)
	*/
	map(x1,y1,x2,y2,filter){
		return this.#_grid.map(x1,y1,x2,y2,filter);
	}
	collision(x1,y1,x2,y2,filter){
		return this.map(x1,y1,x2,y2,filter);
	}
	under(x,y,filter){
		return this.collision(x,y,x,y,filter);
	}
	signal(x,y,distance,filter){
		//this.#_grid.signal(this.#_grid,x,y,distance,filter);
	}
	raycast(source, movement, distance, filter){
		return this.#_grid.raycast(source, movement, distance, filter);
	}
}