/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeConstants} from './data/BiomeConstants.class.js';
import {BiomeGrid} from './data/BiomeGrid.class.js';
import {BiomeUtils} from './data/BiomeUtils.class.js';
import {BiomeCore} from './events/BiomeCore.class.js';
import {BiomeHeart} from './events/BiomeHeart.class.js';
import {BiomeRoom} from './objects/BiomeRoom.class.js';
export class Biome {
	#_grid;
	#_rooms;
	#_loaded;
	#_heart;
	#_core;
	#_area;
	/*
		The core of the Biome controls process and active updates
			biome.core.add(function(time){});
	*/
	get core(){
		return this.#_core;
	}
	/*
		The heart of the Biome create and dispatch signals
			biome.heart.listen(BiomeConstants.EVT_TILE_CREATED, onEvtHandler);
	*/
	get heart(){
		return this.#_heart;
	}
	/*
		The current area of the biome
			biome.area
	*/
	get area(){
		return this.#_grid.area;
	}
	/*
		Create a new Biome, with tile width and height as params
			The tile width and height represents the position of an object in orthogonal and isometric space
	*/
	constructor(tw,th,fps){
		this.#_rooms = new Array();
		this.#_loaded = new Array();
		this.#_heart = new BiomeHeart(this);
		this.#_core = new BiomeCore(this, fps);
		this.#_grid = new BiomeGrid(this, tw, th);
	}
	/*
		If tile coordinate exists
			biome.exists(x, y);
	*/
	exists(x,y){
		return this.#_grid.exists(x,y);
	}
	/*
		Create/Add a Biome Room and allocate tiles
		Room names are not unique
			biome.add(room);
		or
			biome.add('myroom', x, y, width, height, mydata);
		or
			biome.add({name,x,y,width,height});
	*/
	add(room, x, y, width, height, data){
		if(typeof room == 'string'){
			room = new BiomeRoom(room, x, y, width, height, data);
		}else if(!(room instanceof BiomeRoom)){
			room = new BiomeRoom(room.name, room.x, room.y, room.width, room.height, room.data);
		}
		if(!this.#_rooms.includes(room)){
			this.#_grid.create(room.left, room.top, room.right, room.bottom);
			this.#_rooms.push(room);
			room.biome = this;
			this.#_heart.call(BiomeConstants.EVT_ROOM_ADDED, room);
		}
		return room;
	}
	/*
		Load a room into Biome processor
		If you pass a room name, all rooms with match will be loaded
			biome.load(myroom);
		or
			biome.load("roomname");
	*/
	load(room){
		if(!(room instanceof BiomeRoom)){
			this.rooms(function(r){
				if(r.name == room){
					r.load();
				}
			});
		}else if(this.#_rooms.includes(room)){
			if(room && room.commit()){
				this.#_loaded.push(room);
				room.objects(function(o){
					o.room = room;
					if(o.load()){
						this.#_heart.call(BiomeConstants.EVT_OBJECT_LOADED, o);
					}
				}.bind(this));
				this.#_heart.call(BiomeConstants.EVT_ROOM_LOADED, room);
			}
		}
	}
	/*
		Unload a room from Biome processor
		If you pass a room name, all rooms with match will be unloaded
			biome.unload(myroom);
		or
			biome.unload("roomname");
	*/
	unload(room){
		if(!(room instanceof BiomeRoom)){
			this.rooms(function(r){
				if(r.name == room){
					r.unload();
				}
			});
		}else if(room != null){
			var iof = this.#_loaded.indexOf(room);
			if(iof > 0 && room.unload()){
				this.#_loaded.splice(iof, 1);
				room.objects(function(o){
					if(o.unload()){
						this.#_heart.call(BiomeConstants.EVT_OBJECT_UNLOADED, o);
					}
				}.bind(this));
				this.#_heart.call(BiomeConstants.EVT_ROOM_UNLOADED, room);
			}
		}
	}
	/*
		Unload all loaded rooms
			biome.purge();
	*/
	purge(){
		for(let i=0; i<this.#_loaded.length; ++i){
			this.#_loaded[i].unload();
		}
	}
	/*
		Call fx(room) for each room added in this Biome
			biome.rooms(function(r){
			})
	*/
	rooms(filter){
		filter = BiomeUtils.scanner(filter);
		for(let i=0; i<this.#_rooms.length; ++i){
			filter.add(this.#_rooms[i]);
			if(!filter.active){
				break;
			}
		}
		return filter;
	}
	/*
		Get existing room in a location
			biome.under(x, y, function(r){
			})
	*/
	under(x,y,filter){
		filter = BiomeUtils.scanner(filter);
		for(let i=0; i<this.#_rooms.length; ++i){
			if(this.#_rooms[i].inside(x, y)){
				filter.add(this.#_rooms[i]);
				if(!filter.active){
					break;
				}
			}
		}
		return filter;
	}
	/*
		Proccess all pending updates in objects and rooms
			biome.update();
	*/
	update(){
		let room;
		for(let i=0; i<this.#_loaded.length; ++i){
			room = this.#_loaded[i];
			if(room.updated(function(o){
				if(o.normalize()){
					this.#_heart.call(BiomeConstants.EVT_OBJECT_UPDATED, room);
				}
			})){
				this.#_heart.call(BiomeConstants.EVT_ROOM_UPDATED, room);
			}
		}
	}
	/*
		Get tile in a position
			biome.tile(x, y);
	*/
	tile(x, y){
		return this.#_grid.tile(x, y);
	}
	/*
		Get all objects in a point, calls fx(object) for each
	*/
	under(x,y,filter){
		return this.#_grid.tile(x, y).objects(filter);
	}
	/*
		Iterate valid tiles in an area using two locations, calls fx(tile)
			biome.map(x1, y1, x2, y2, fx);
	*/
	map(x1, y1, x2, y2, filter){
		return this.#_grid.map(x1, y1, x2, y2, filter);
	}
	/*
		Iterate valid tiles in an area using two tiles, calls fx(tile)
			biome.map(x1, y1, x2, y2, fx);
	*/
	map2(a, b, filter){
		return this.#_grid.map(a.x, a.y, b.x, b.y, filter);
	}
	/*
		Find a path from a location to another location
			biome.find(x1, y1, x2, y2, room, fx);
	*/
	find(x1, y1, x2, y2, room, filter){
		if(room == null || room.inside(x1, y1, 1) && room.inside(x2, y2, 1)){
			return this.#_grid.find(x1, y1, x2, y2, room, filter);
		}else{
			null;
		}
	}
	/*
		Find a path from a tile to another tile
			biome.find(tile, tile, room, fx);
	*/
	find2(a, b, room, filter){
		return this.find(a.x, a.y, b.x, b.y, room, filter);
	}
	/*
		Cast a line to any direction from source tiles and apply a movement path on each interaction, then calls fx(tile)
			biome.raycast([...tiles], [{x,y}], distance, fx)
			
	*/
	raycast(source, movement, distance, filter){
		return this.#_grid.raycast(source, movement, distance, filter);
	}
	/* 
		Calls fx(object) for each loaded object in Biome processor
			biome.objects(function(o){ });
	*/
	objects(filter){
		filter = BiomeUtils.scanner(filter);
		let stop;
		for(let i=0; i<this.#_loaded.length; ++i){
			this.#_loaded[i].objects(function(o){
				stop = true;
				return filter.add(o);
			});
			if(stop){
				break;
			}
		}
		return filter;
	}
	/* 
		Set tiles in an area as locked to pathfind
			biome.lock(x1, y1, x2, y2);
	*/
	lock(x1,y1,x2,y2){
		return this.#_grid.map(x1,y1,x2,y2,function(tile){
			tile.lock();
		});
	}
	/* 
		Set tiles in an area as unlocked to pathfind
			biome.unlock(x1, y1, x2, y2);
	*/
	unlock(x1,y1,x2,y2){
		return this.#_grid.map(x1,y1,x2,y2,function(tile){
			tile.unlock();
		});
	}
}