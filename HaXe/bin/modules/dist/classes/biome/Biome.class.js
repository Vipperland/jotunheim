/**
 * ...
 * @author Rafael Moreira
 */
import {BiomeConstants} from './data/BiomeConstants.class.js';
import {BiomeHeart} from './events/BiomeHeart.class.js';
import {Iterator} from './math/Iterator.class.js';
import {BiomeRoom} from './objects/BiomeRoom.class.js';
import {BiomeTile} from './objects/BiomeTile.class.js';
export class Biome {
	#_tiles;
	#_rooms;
	#_loaded;
	#_heart;
	#_area;
	get heart(){
		return this.#_heart;
	}
	get area(){
		return this.#_area;
	}
	constructor(){
		this.#_tiles = [];
		this.#_rooms = {};
		this.#_loaded = [];
		this.#_heart = new BiomeHeart();
		this.#_area = new BiomeArea();
	}
	#_create(x1,y1,x2,y2){
		let tx = x1;
		let ty = null;
		let t;
		while(y1<=y2){
			if(this.#_tiles[y1] == null){
				this.#_tiles[y1] = [];
			}
			ty = this.#_tiles[y1];
			while(x1<=x2){
				t = new BiomeTile(x1,y1);
				ty[x1] = t;
				this.#_heart.call(BiomeConstants.EVT_TILE_CREATED, t);
				++x1;
			}
			x1 = tx;
			++y1;
		}
		this.#_area.fit(x1,y1,x2,y2);
	}
	exists(x,y){
		return this.#_tiles[y] != null && this.#_tiles[y][x] != null;
	}
	/*
		Create/Add a Biome Room and allocate tiles 
	*/
	add(room,x,y,width,height,walls,data){
		if(typeof room == 'string'){
			room = new BiomeRoom(room, x, y, width, height, walls || BiomeConstants.WALL_ALL, data);
		}
		this.#_create(room.left, room.top, room.right, room.bottom);
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
	/*
		Iterate valid tiles in an area, calls fn(tile)
	*/
	map(x1,y1,x2,y2,fn){
		if(x1 < this.#_area.left){
			x1 = this.#_area.left;
		}
		if(x2 > this.#_area.right){
			x2 = his.#_area.right;
		}
		if(y1 < this.#_area.top){
			y1 = this.#_area.top;
		}
		if(y2 > this.#_area.bottom){
			y2 = this.#_area.bottom;
		}
		Iterator.map(this.#_tiles,x1,y1,x2,y2,fn);
	}
	collision(x1,y1,x2,y2,filter){
		var r = [];
		if(filter == null) {
			filter = function(o){
				r.push(o);
			}
		}
		this.map(x1,y1,x2,y2,function(t){
			t.objects(filter);
		});
		return r;
	}
	under(x,y,filter){
		return this.collision(x,y,x,y,filter);
	}
}
class BiomeArea {
	#_x1;
	#_x2;
	#_y1;
	#_y2;
	constructor(){
		this.#_x1 = 0xFFFFFFFF;
		this.#_x2 = 0xFFFFFFFF;
		this.#_y1 = 0;
		this.#_y2 = 0;
	}
	fit(x1,y1,x2,y2){
		if(y1 < this.#_y1){
			this.#_y1 = y1;
		}
		if(y2 > this.#_y2){
			this.#_y2 = y2;
		}
		if(x1 < this.#_x1){
			this.#_x1 = x1;
		}
		if(x2 > this.#_x2){
			this.#_x2 = x2;
		}
	}
	get left(){
		return this.#_x1;
	}
	get right(){
		return this.#_x2;
	}
	get top(){
		return this.#_y1;
	}
	get bottom(){
		return this.#_y2;
	}
	get width(){
		return this.#_x2 - this.#_x1;
	}
	get height(){
		return this.#_y2 - this.#_y1;
	}
	get size(){
		return this.width * this.height;
	}
}